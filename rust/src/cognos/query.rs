use serde_json::Value;

use super::utils::as_slice;

/// Query Extraction — equivalent to query.sh
pub fn parse_queries(v: &Value) {
    println!("\n==================== Query Extraction ======================");

    let raw = &v["report"]["queries"]["query"];
    let queries = as_slice(raw);

    if queries.is_empty() {
        println!("No queries found");
        return;
    }

    for q in queries {
        let name = q["+@name"].as_str().unwrap_or("unnamed");
        println!("QUERY: {}", name);

        let raw_items = &q["selection"]["dataItem"];
        let items = as_slice(raw_items);

        for item in items {
            let item_name = item["+@name"].as_str().unwrap_or("N/A");
            let expression = item["expression"].as_str().unwrap_or("N/A");
            let aggregate = item["+@aggregate"].as_str().unwrap_or("none");
            let rollup = item["+@rollupAggregate"].as_str().unwrap_or("none");

            // XMLAttributes: can be a single object or array
            let xml_attrs_raw = &item["XMLAttributes"]["XMLAttribute"];
            let xml_attrs = as_slice(xml_attrs_raw);
            let xml_str = if xml_attrs.is_empty() {
                "none".to_string()
            } else {
                xml_attrs
                    .iter()
                    .map(|a| {
                        format!(
                            "name={}, value={}, output={}",
                            a["+@name"].as_str().unwrap_or("N/A"),
                            a["+@value"].as_str().unwrap_or("N/A"),
                            a["+@output"].as_str().unwrap_or("N/A"),
                        )
                    })
                    .collect::<Vec<_>>()
                    .join("; ")
            };

            println!("  - Name:             {}", item_name);
            println!("    Expression:       {}", expression);
            println!("    Aggregate:        {}", aggregate);
            println!("    RollupAggregate:  {}", rollup);
            println!("    XMLAttributes:    {}", xml_str);
        }

        println!("---");
    }
}
