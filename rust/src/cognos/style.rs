use serde_json::Value;

use super::utils::as_slice;

fn collect_styles<'a>(v: &'a Value, results: &mut Vec<&'a Value>) {
    match v {
        Value::Object(map) => {
            if map.contains_key("style") {
                results.push(&map["style"]);
            }
            for val in map.values() {
                collect_styles(val, results);
            }
        }
        Value::Array(arr) => {
            for val in arr {
                collect_styles(val, results);
            }
        }
        _ => {}
    }
}

/// Style Extraction — equivalent to styles.sh
pub fn parse_styles(v: &Value) {
    println!("\n==================== Styles =====================");

    let mut styles: Vec<&Value> = Vec::new();
    collect_styles(v, &mut styles);

    if styles.is_empty() {
        println!("No styles found");
        return;
    }

    for style in styles {
        let css = style["CSS"]["+@value"].as_str();

        // defaultStyles.defaultStyle can be array or object
        let ref_styles: Vec<&str> = {
            let ds = &style["defaultStyles"]["defaultStyle"];
            as_slice(ds)
                .into_iter()
                .filter_map(|s| s["+@refStyle"].as_str())
                .collect()
        };

        // Skip entries with nothing to show
        if css.is_none() && ref_styles.is_empty() {
            continue;
        }

        println!("{{");
        if let Some(c) = css {
            println!("  CSS          : {}", c);
        }
        if !ref_styles.is_empty() {
            println!("  defaultStyles: [{}]", ref_styles.join(", "));
        }
        println!("}}");
    }
}
