use serde_json::Value;

use super::utils::as_slice;

/// Report Parameters — equivalent to reportParameters.sh
pub fn parse_parameters(v: &Value) {
    println!("\n==================== Report Parameters =====================");

    let raw = &v["report"]["parameters"]["parameter"];
    let params = as_slice(raw);

    if params.is_empty() {
        println!("No parameters found");
        return;
    }

    for p in params {
        let name = p["+@name"].as_str().unwrap_or("N/A");

        // Type: XMLAttributes.XMLAttribute["+@value"] (may be array or object)
        let type_val = {
            let attr = &p["XMLAttributes"]["XMLAttribute"];
            match attr {
                Value::Array(arr) => arr
                    .first()
                    .and_then(|a| a["+@value"].as_str())
                    .unwrap_or("N/A"),
                Value::Object(_) => attr["+@value"].as_str().unwrap_or("N/A"),
                _ => "N/A",
            }
        };

        // Default: defaultValues.defaultValue["+@refQuery"] or "null"
        let default_val = {
            let dv = &p["defaultValues"]["defaultValue"];
            if dv.is_null() {
                "null".to_string()
            } else {
                dv["+@refQuery"]
                    .as_str()
                    .map(|s| format!("Query: {}", s))
                    .unwrap_or_else(|| "null".to_string())
            }
        };

        // RefDataItem: defaultValues.defaultValue.propertyList.propertyItem
        let ref_data_item = {
            let items_raw = &p["defaultValues"]["defaultValue"]["propertyList"]["propertyItem"];
            let items = as_slice(items_raw);
            if items.is_empty() {
                String::new()
            } else {
                items
                    .iter()
                    .filter_map(|i| i["+@refDataItem"].as_str())
                    .collect::<Vec<_>>()
                    .join(", ")
            }
        };

        println!("--------------------------------------");
        println!("Name        : {}", name);
        println!("Type        : {}", type_val);
        println!("Default     : {}", default_val);
        println!("Ref DataItem: {}", ref_data_item);
    }
}
