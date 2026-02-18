use serde_json::Value;

use super::utils::as_slice;

/// Report Data Stores — equivalent to reportDataStores.sh
pub fn parse_datastores(v: &Value) {
    println!("\n==================== Report Data Stores =====================");

    let raw = &v["report"]["reportDataStores"]["reportDataStore"];
    let stores = as_slice(raw);

    if stores.is_empty() {
        println!("No data stores found");
        return;
    }

    for store in stores {
        let name = store["+@name"].as_str().unwrap_or("N/A");
        let ref_query = store["dsSource"]["dsV5ListQuery"]["+@refQuery"]
            .as_str()
            .unwrap_or("N/A");

        // Data items: dsSource.dsV5ListQuery.dsV5DataItems.dsV5DataItem → normalize
        let items_raw = &store["dsSource"]["dsV5ListQuery"]["dsV5DataItems"]["dsV5DataItem"];
        let items = as_slice(items_raw);
        let items_str = if items.is_empty() {
            "N/A".to_string()
        } else {
            items
                .iter()
                .map(|item| {
                    let ref_di = item["+@refDataItem"].as_str().unwrap_or("N/A");
                    let col_type = item["+@dsColumnType"].as_str().unwrap_or("N/A");
                    format!("+ {} ({})", ref_di, col_type)
                })
                .collect::<Vec<_>>()
                .join(", ")
        };

        println!("--------------------------------------");
        println!("Data Store Name : {}", name);
        println!("Ref Query       : {}", ref_query);
        println!("Data Items      : {}", items_str);
    }
}
