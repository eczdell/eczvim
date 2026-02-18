use serde_json::Value;

use super::utils::{as_slice, collect_with_key};

fn cell_content_type(contents: &Value) -> String {
    if contents.is_null() {
        return "(no contents)".to_string();
    }
    if contents.get("date").is_some() {
        "date".to_string()
    } else if contents.get("time").is_some() {
        "time".to_string()
    } else if contents.get("pageNumber").is_some() {
        "pageNumber".to_string()
    } else if contents.get("textItem").is_some() {
        "text (static)".to_string()
    } else if contents.get("customControl").is_some() {
        "customControl / slicer".to_string()
    } else {
        let keys: Vec<&str> = contents
            .as_object()
            .map(|m| m.keys().map(|k| k.as_str()).collect())
            .unwrap_or_default();
        format!("contents: {}", keys.join(", "))
    }
}

/// Table Details — equivalent to pages.sh §3
pub fn parse_relationships(v: &Value) {
    println!("\n==================== Table Details =====================");

    let mut table_objects: Vec<&Value> = Vec::new();
    collect_with_key(v, "table", &mut table_objects);

    let null = Value::Null;

    for (i, obj) in table_objects.iter().enumerate() {
        let table = &obj["table"];
        println!("──────────────────────────────────────");
        println!("Table #{}", i + 1);

        let rows = as_slice(&table["tableRows"]["tableRow"]);
        println!("Rows: {}", rows.len());

        let first_row = rows.first().copied().unwrap_or(&null);
        let cols = as_slice(&first_row["tableCells"]["tableCell"]);
        println!("Columns: {}", cols.len());

        for (ri, row_val) in rows.iter().enumerate() {
            let cells = as_slice(&row_val["tableCells"]["tableCell"]);
            for (ci, cell) in cells.iter().enumerate() {
                let content_type = cell_content_type(&cell["contents"]);

                // XML→JSON converters use either `_value` or `+@value` for attributes
                let css = cell["style"]["CSS"]["_value"]
                    .as_str()
                    .or_else(|| cell["style"]["CSS"]["+@value"].as_str())
                    .unwrap_or("(no CSS)");

                println!("Row {}, Col {}: {} | Cell CSS: {}", ri, ci, content_type, css);
            }
        }
    }
}
