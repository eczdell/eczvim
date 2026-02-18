use std::collections::BTreeSet;

use serde_json::Value;

/// Extract staticValue from a dataSource node (object or first of array).
fn get_static_value(datasource: &Value) -> Option<&str> {
    match datasource {
        Value::Array(arr) => arr.iter().find_map(|ds| ds["staticValue"].as_str()),
        Value::Object(_) => datasource["staticValue"].as_str(),
        _ => None,
    }
}

/// Extract CSS "+@value" from a style node (object or first of array).
fn get_css(style: &Value) -> Option<&str> {
    match style {
        Value::Array(arr) => arr.iter().find_map(|s| s["CSS"]["+@value"].as_str()),
        Value::Object(_) => style["CSS"]["+@value"].as_str(),
        _ => None,
    }
}

fn extract_from_node(obj: &Value) -> (Option<&str>, Option<&str>) {
    let text = if !obj["textItem"].is_null() {
        let ti = &obj["textItem"];
        match ti {
            Value::Array(arr) => arr
                .iter()
                .find_map(|item| get_static_value(&item["dataSource"])),
            _ => get_static_value(&ti["dataSource"]),
        }
    } else if !obj["dataSource"].is_null() {
        get_static_value(&obj["dataSource"])
    } else {
        None
    };

    let css = if !obj["textItem"].is_null() {
        let ti = &obj["textItem"];
        match ti {
            Value::Array(arr) => arr.iter().find_map(|item| get_css(&item["style"])),
            _ => get_css(&ti["style"]),
        }
    } else if !obj["style"].is_null() {
        get_css(&obj["style"])
    } else {
        None
    };

    (text, css)
}

fn walk<'a>(v: &'a Value, seen: &mut BTreeSet<(String, String)>) {
    match v {
        Value::Object(map) => {
            let (text, css) = extract_from_node(v);
            let t = text.unwrap_or("").to_string();
            let c = css.unwrap_or("").to_string();
            if !t.is_empty() || !c.is_empty() {
                seen.insert((t, c));
            }
            for val in map.values() {
                walk(val, seen);
            }
        }
        Value::Array(arr) => {
            for val in arr {
                walk(val, seen);
            }
        }
        _ => {}
    }
}

/// Unique Text & CSS Extraction — equivalent to extract_text_and_css_unique.sh
pub fn parse_text_css(v: &Value) {
    println!("\n==================== Unique Text & CSS =====================");

    // BTreeSet keeps entries sorted, giving us the same dedup+sort as `sort -u`
    let mut seen: BTreeSet<(String, String)> = BTreeSet::new();
    walk(v, &mut seen);

    if seen.is_empty() {
        println!("No text or CSS found");
        return;
    }

    for (text, css) in &seen {
        if !text.is_empty() {
            println!("Text: {}", text);
        }
        if !css.is_empty() {
            println!("CSS : {}", css);
        }
        println!("--------------------------------------");
    }
}
