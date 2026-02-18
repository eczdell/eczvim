use serde_json::Value;

use super::utils::collect_with_key;

fn str_or<'a>(v: &'a Value, fallback: &'a str) -> &'a str {
    v.as_str().unwrap_or(fallback)
}

/// Recursively collect all objects that have `+@refDataItem` within a subtree.
fn collect_ref_data_items<'a>(v: &'a Value, results: &mut Vec<&'a Value>) {
    match v {
        Value::Object(map) => {
            if map.contains_key("+@refDataItem") {
                results.push(v);
            }
            for val in map.values() {
                collect_ref_data_items(val, results);
            }
        }
        Value::Array(arr) => {
            for val in arr {
                collect_ref_data_items(val, results);
            }
        }
        _ => {}
    }
}

/// Crosstab Extraction — equivalent to crosstab_with_css.sh
pub fn parse_crosstabs(v: &Value) {
    println!("\n==================== Crosstab Extraction ======================");

    let mut crosstab_objects: Vec<&Value> = Vec::new();
    collect_with_key(v, "crosstab", &mut crosstab_objects);

    if crosstab_objects.is_empty() {
        println!("No crosstabs found");
        return;
    }

    for obj in crosstab_objects {
        let c = &obj["crosstab"];

        println!("------------------------------------------------------------");
        println!("Name          : {}", str_or(&c["+@name"], "unnamed"));
        println!("Query         : {}", str_or(&c["+@refQuery"], "unknown"));
        println!("Paging        : {}", str_or(&c["+@horizontalPagination"], "false"));
        println!("Crosstab CSS  : {}", str_or(&c["style"]["CSS"]["+@value"], ""));
        println!(
            "Crosstab RefStyle : {}",
            str_or(&c["style"]["defaultStyles"]["defaultStyle"]["+@refStyle"], "")
        );
        println!(
            "NoData CSS    : {}",
            str_or(&c["noDataHandler"]["contents"]["block"]["style"]["CSS"]["+@value"], "")
        );
        println!(
            "Corner RefStyle: {}",
            str_or(
                &c["crosstabCorner"]["style"]["defaultStyles"]["defaultStyle"]["+@refStyle"],
                ""
            )
        );

        // Rows
        let mut row_nodes: Vec<&Value> = Vec::new();
        collect_ref_data_items(&c["crosstabRows"]["crosstabNode"], &mut row_nodes);
        for node in row_nodes {
            let ref_item = str_or(&node["+@refDataItem"], "N/A");
            let ref_style = str_or(
                &node["style"]["defaultStyles"]["defaultStyle"]["+@refStyle"],
                "",
            );
            println!("Row      : {} | RefStyle: {}", ref_item, ref_style);
        }

        // Columns
        let mut col_nodes: Vec<&Value> = Vec::new();
        collect_ref_data_items(&c["crosstabColumns"]["crosstabNode"], &mut col_nodes);
        for node in col_nodes {
            let ref_item = str_or(&node["+@refDataItem"], "N/A");
            let ref_style = str_or(
                &node["style"]["defaultStyles"]["defaultStyle"]["+@refStyle"],
                "",
            );
            println!("Column   : {} | RefStyle: {}", ref_item, ref_style);
        }

        // Fact cell style
        let fact_style = c["crosstabFactCell"]["style"]["defaultStyles"]["defaultStyle"]
            ["+@refStyle"]
            .as_str();
        if let Some(s) = fact_style {
            println!("FactStyle: {}", s);
        }
    }
}
