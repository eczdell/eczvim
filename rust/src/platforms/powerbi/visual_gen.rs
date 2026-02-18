use serde_json::{json, Value};
use std::fs;
use std::path::Path;
use uuid::Uuid;

use crate::cognos::utils::sanitise_name;
use crate::cognos::visual::{extract_lists, print_lists, ListColumn};

// ---------------------------------------------------------------------------
// Build Power BI visualContainer JSON
// ---------------------------------------------------------------------------
fn build_visual_json(columns: &[ListColumn]) -> Value {
    let visual_id = Uuid::new_v4().to_string();

    let projections: Vec<Value> = columns
        .iter()
        .map(|col| {
            let body = col.body.as_str();
            json!({
                "field": {
                    "Column": {
                        "Expression": {
                            "SourceRef": { "Entity": body }
                        },
                        "Property": body
                    }
                },
                "queryRef": format!("{}.{}", body, body),
                "nativeQueryRef": body
            })
        })
        .collect();

    json!({
        "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/visualContainer/2.4.0/schema.json",
        "name": visual_id,
        "position": {
            "x": 10, "y": 0, "z": 0,
            "height": 280, "width": 500, "tabOrder": 0
        },
        "visual": {
            "visualType": "tableEx",
            "query": {
                "queryState": {
                    "Values": {
                        "projections": projections
                    }
                }
            },
            "drillFilterOtherVisuals": true
        }
    })
}

// ---------------------------------------------------------------------------
// Extract the first Cognos report-page name to use as the PBI page display name
// ---------------------------------------------------------------------------
fn cognos_page_name(v: &Value) -> String {
    let layout = &v["report"]["layouts"]["layout"];
    let pages_obj = &layout["reportPages"];
    if !pages_obj.is_null() {
        let page = &pages_obj["page"];
        let name = match page {
            Value::Array(arr) => arr.first().and_then(|p| p["+@name"].as_str()),
            Value::Object(_) => page["+@name"].as_str(),
            _ => None,
        };
        if let Some(n) = name {
            return n.to_string();
        }
    }
    "Page 1".to_string()
}

// ---------------------------------------------------------------------------
// Public entry point
// ---------------------------------------------------------------------------
pub fn generate_list_visuals(v: &Value) {
    let report_name = sanitise_name(
        v["report"]["reportName"].as_str().unwrap_or("unknown"),
    );

    let project_dir = Path::new("/tmp/projects").join(&report_name);

    // ── 1. Bootstrap full project from template if it doesn't exist yet ──────
    if !project_dir.exists() {
        super::create_report::run(&report_name);
    }

    let pages_dir = project_dir
        .join(format!("{}.Report", report_name))
        .join("definition/pages");

    // ── 2. Create a new page ──────────────────────────────────────────────────
    let page_id = Uuid::new_v4().to_string();
    let page_name = cognos_page_name(v);
    let page_dir = pages_dir.join(&page_id);
    let visuals_dir = page_dir.join("visuals");

    if let Err(e) = fs::create_dir_all(&visuals_dir) {
        eprintln!("Error creating visuals dir: {}", e);
        return;
    }

    let page_json = json!({
        "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/page/2.0.0/schema.json",
        "name": page_id,
        "displayName": page_name,
        "displayOption": "FitToPage",
        "height": 720,
        "width": 1280
    });
    if let Err(e) = fs::write(
        page_dir.join("page.json"),
        serde_json::to_string_pretty(&page_json).unwrap(),
    ) {
        eprintln!("Error writing page.json: {}", e);
        return;
    }

    // ── 3. Remove the template's placeholder page, replace pages.json ────────
    if let Ok(entries) = fs::read_dir(&pages_dir) {
        for entry in entries.flatten() {
            let name = entry.file_name().to_string_lossy().to_string();
            if name != "pages.json" && name != page_id && entry.path().is_dir() {
                let _ = fs::remove_dir_all(entry.path());
            }
        }
    }

    let pages_meta = json!({
        "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/pagesMetadata/1.0.0/schema.json",
        "pageOrder": [page_id],
        "activePageName": page_id
    });
    if let Err(e) = fs::write(
        pages_dir.join("pages.json"),
        serde_json::to_string_pretty(&pages_meta).unwrap(),
    ) {
        eprintln!("Error writing pages.json: {}", e);
        return;
    }

    // ── 4. Extract lists, print, write visual.json for each ──────────────────
    let lists = extract_lists(v);
    print_lists(&lists);

    for l in &lists {
        let visual_json = build_visual_json(&l.columns);
        let visual_id = visual_json["name"].as_str().unwrap_or("unknown");
        let visual_dir = visuals_dir.join(visual_id);

        match fs::create_dir_all(&visual_dir) {
            Ok(_) => {
                let out_path = visual_dir.join("visual.json");
                match fs::write(
                    &out_path,
                    serde_json::to_string_pretty(&visual_json).unwrap(),
                ) {
                    Ok(_) => println!("  Saved: {}", out_path.display()),
                    Err(e) => eprintln!("  Error writing visual.json: {}", e),
                }
            }
            Err(e) => eprintln!("  Error creating dir '{}': {}", visual_dir.display(), e),
        }
    }
}
