use serde_json::Value;

use crate::platforms::powerbi::layout_map::{map_cogvis, map_slot};

/// Convert a `%` or plain pixel string to f64 pixels given `total` dimension.
fn to_px(val: &str, total: f64) -> f64 {
    if let Some(pct) = val.strip_suffix('%') {
        pct.parse::<f64>().unwrap_or(0.0) / 100.0 * total
    } else {
        val.parse::<f64>().unwrap_or(0.0)
    }
}

/// Cognos layout → Power BI visual mapping — equivalent to visual.sh
pub fn parse_layout(v: &Value) {
    println!("\n==================== Layout Visuals =====================");

    let page_width = v["layout"]["pageWidth"].as_f64().unwrap_or(1280.0);
    let page_height = v["layout"]["pageHeight"].as_f64().unwrap_or(720.0);

    println!("Page: {}×{}", page_width, page_height);

    let items = match v["layout"]["items"].as_object() {
        Some(m) => m,
        None => {
            println!("No layout items found");
            return;
        }
    };

    let mut sorted_keys: Vec<&String> = items.keys().collect();
    sorted_keys.sort_by_key(|k| k.parse::<usize>().unwrap_or(usize::MAX));

    for key in sorted_keys {
        let page = &items[key];
        let page_title = page["title"]["translationTable"]["Default"]
            .as_str()
            .unwrap_or("N/A");

        let sub_items = match page["items"].as_array() {
            Some(a) => a,
            None => continue,
        };

        for group in sub_items {
            let group_items = match group["items"].as_array() {
                Some(a) => a,
                None => continue,
            };

            for item in group_items {
                let feat = &item["features"]["Models_internal"];
                if feat.is_null() {
                    continue;
                }

                let title = feat["name"]["translationTable"]["Default"]
                    .as_str()
                    .unwrap_or("N/A");

                let cogvis = feat["visId"]
                    .as_str()
                    .or_else(|| feat["type"].as_str())
                    .unwrap_or("N/A");

                let pbi_type = map_cogvis(cogvis);

                // Style / position
                let left = item["style"]["left"].as_str().unwrap_or("0%");
                let top = item["style"]["top"].as_str().unwrap_or("0%");
                let width = item["style"]["width"].as_str().unwrap_or("100%");
                let height = item["style"]["height"].as_str().unwrap_or("100%");

                let px_x = to_px(left, page_width);
                let px_y = to_px(top, page_height);
                let px_w = to_px(width, page_width);
                let px_h = to_px(height, page_height);

                println!("======================================================");
                println!("Page       : {}", page_title);
                println!("Title      : {}", title);
                println!("Cognos vis : {}", cogvis);
                println!("PowerBI    : {}", pbi_type);
                println!(
                    "Position   : x={:.2} y={:.2} w={:.2} h={:.2}",
                    px_x, px_y, px_w, px_h
                );

                // Slot mappings
                if let Some(slots) = feat["slotmapping"]["slots"].as_array() {
                    for slot in slots {
                        let slot_name = slot["name"].as_str().unwrap_or("");
                        let pb_field = map_slot(slot_name);
                        if let Some(data_items) = slot["dataItems"].as_array() {
                            for di in data_items {
                                let id = di.as_str().unwrap_or("N/A");
                                println!(
                                    "  Slot: {} → DataItemId: {} → PB Field: {}",
                                    slot_name, id, pb_field
                                );
                            }
                        } else {
                            println!("  Slot: {} → (empty) → PB Field: {}", slot_name, pb_field);
                        }
                    }
                }

                // DataViews
                if let Some(dviews) = feat["data"]["dataViews"].as_array() {
                    for dv in dviews {
                        println!(
                            "  DataView: {} | ModelRef: {}",
                            dv["id"].as_str().unwrap_or("N/A"),
                            dv["modelRef"].as_str().unwrap_or("N/A")
                        );
                        if let Some(ditems) = dv["dataItems"].as_array() {
                            for di in ditems {
                                println!(
                                    "    * DataItemId: {} | ItemId: {} | Label: {}",
                                    di["id"].as_str().unwrap_or("N/A"),
                                    di["itemId"].as_str().unwrap_or("N/A"),
                                    di["itemLabel"].as_str().unwrap_or("N/A")
                                );
                            }
                        }
                    }
                }

                if pbi_type == "Unknown" {
                    println!("  ⚠ Unsupported visual type — skipped");
                }
            }
        }
    }
}
