use serde_json::Value;

use super::utils::{as_slice, collect_with_key};

// ---------------------------------------------------------------------------
// Public structs — stable interface between cognos ↔ platform
// ---------------------------------------------------------------------------

pub struct VizControl {
    pub name: String,
    pub full_type: String,
    pub short_type: String,
    pub width: String,
    pub height: String,
}

#[allow(dead_code)]
pub struct ListColumn {
    pub title: String,
    pub title_css: String,
    pub title_ref_style: String,
    pub body: String,
    pub body_css: String,
    pub body_ref_style: String,
}

pub struct CognosList {
    pub name: String,
    pub css: String,
    pub ref_query: String,
    pub no_data_css: String,
    pub columns: Vec<ListColumn>,
}

// ---------------------------------------------------------------------------
// vizControl length property helper
// ---------------------------------------------------------------------------
fn get_viz_prop(viz_control: &Value, prop_name: &str) -> String {
    let props = as_slice(&viz_control["vizPropertyValues"]["vizPropertyLengthValue"]);
    for p in props {
        if p["+@name"].as_str() == Some(prop_name) {
            if let Some(v) = p["+content"].as_str() {
                return v.to_string();
            }
        }
    }
    "N/A".to_string()
}

// ---------------------------------------------------------------------------
// List column text-item extraction helper
// ---------------------------------------------------------------------------
fn extract_text_ref(text_item: &Value, data_key: &str) -> String {
    match text_item {
        Value::Array(arr) => arr
            .iter()
            .filter_map(|item| item["dataSource"][data_key]["+@refDataItem"].as_str())
            .collect::<Vec<_>>()
            .join(", "),
        Value::Object(_) => text_item["dataSource"][data_key]["+@refDataItem"]
            .as_str()
            .unwrap_or("")
            .to_string(),
        _ => String::new(),
    }
}

// ---------------------------------------------------------------------------
// VizControl extraction
// ---------------------------------------------------------------------------

pub fn extract_viz_controls(v: &Value) -> Vec<VizControl> {
    let mut viz_objects: Vec<&Value> = Vec::new();
    collect_with_key(v, "vizControl", &mut viz_objects);

    viz_objects
        .iter()
        .map(|obj| {
            let vc = &obj["vizControl"];
            let name = vc["+@name"].as_str().unwrap_or("N/A").to_string();
            let full_type = vc["+@type"].as_str().unwrap_or("N/A").to_string();
            let short_type = full_type.split('.').last().unwrap_or("N/A").to_string();
            let width = get_viz_prop(vc, "vcWidth");
            let height = get_viz_prop(vc, "vcHeight");
            VizControl { name, full_type, short_type, width, height }
        })
        .collect()
}

pub fn print_viz_controls(controls: &[VizControl]) {
    println!("\n==================== IBM Visual Controls =====================");
    for c in controls {
        println!("--------------------------------------");
        println!("Name:              {}", c.name);
        println!("Full Type:         {}", c.full_type);
        println!("Short Type:        {}", c.short_type);
        println!("Width:             {}", c.width);
        println!("Height:            {}", c.height);
    }
}

// ---------------------------------------------------------------------------
// List extraction
// ---------------------------------------------------------------------------

pub fn extract_lists(v: &Value) -> Vec<CognosList> {
    let mut list_objects: Vec<&Value> = Vec::new();
    collect_with_key(v, "list", &mut list_objects);

    list_objects
        .iter()
        .map(|obj| {
            let l = &obj["list"];
            let name = l["+@name"].as_str().unwrap_or("N/A").to_string();
            let css = l["style"]["CSS"]["+@value"].as_str().unwrap_or("").to_string();
            let ref_query = l["+@refQuery"].as_str().unwrap_or("").to_string();
            let no_data_css = l["noDataHandler"]["contents"]["block"]["style"]["CSS"]["+@value"]
                .as_str()
                .unwrap_or("")
                .to_string();

            let raw_cols = as_slice(&l["listColumns"]["listColumn"]);
            let columns: Vec<ListColumn> = raw_cols
                .iter()
                .map(|col| {
                    let title_item = &col["listColumnTitle"]["contents"]["textItem"];
                    let body_item = &col["listColumnBody"]["contents"]["textItem"];

                    let title = extract_text_ref(title_item, "dataItemLabel");
                    let body = extract_text_ref(body_item, "dataItemValue");

                    let title_css = col["listColumnTitle"]["style"]["CSS"]["+@value"]
                        .as_str()
                        .unwrap_or("")
                        .to_string();
                    let body_css = col["listColumnBody"]["style"]["CSS"]["+@value"]
                        .as_str()
                        .unwrap_or("")
                        .to_string();
                    let title_ref_style = col["listColumnTitle"]["style"]["defaultStyles"]
                        ["defaultStyle"]["+@refStyle"]
                        .as_str()
                        .unwrap_or("")
                        .to_string();
                    let body_ref_style = col["listColumnBody"]["style"]["defaultStyles"]
                        ["defaultStyle"]["+@refStyle"]
                        .as_str()
                        .unwrap_or("")
                        .to_string();

                    ListColumn {
                        title,
                        title_css,
                        title_ref_style,
                        body,
                        body_css,
                        body_ref_style,
                    }
                })
                .collect();

            CognosList { name, css, ref_query, no_data_css, columns }
        })
        .collect()
}

pub fn print_lists(lists: &[CognosList]) {
    println!("\n==================== Lists =====================");
    for l in lists {
        println!("--------------------------------------");
        println!("List:      {}", l.name);
        println!("Query:     {}", if l.ref_query.is_empty() { "(none)" } else { &l.ref_query });
        println!("CSS:       {}", if l.css.is_empty() { "(none)" } else { &l.css });
        println!("NoDataCSS: {}", if l.no_data_css.is_empty() { "(none)" } else { &l.no_data_css });
        println!("Columns:   {}", l.columns.len());
        for col in &l.columns {
            println!("  title={:?}  body={:?}", col.title, col.body);
        }
    }
}
