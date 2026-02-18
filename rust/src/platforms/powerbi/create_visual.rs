use serde_json::{json, Value};
use std::fs;
use std::path::{Path, PathBuf};
use uuid::Uuid;

const VALID_TYPES: &[&str] = &[
    "globalProperties", "page", "report", "shape", "actionButton", "filter",
    "pageNavigator", "bookmarkNavigator", "stackedBarChart", "stackedColumnChart",
    "clusteredBarChart", "clusteredColumnChart", "100%StackedBarChart",
    "100%StackedColumnChart", "lineChart", "areaChart", "stackedAreaChart",
    "lineAndStackedColumnChart", "lineAndClusteredColumnChart", "ribbonChart",
    "waterfallChart", "funnel", "scatterChart", "pieChart", "donutChart",
    "treemap", "map", "filledMap", "shapeMap", "gauge", "card", "card(new)",
    "multi-rowCard", "kPI", "slicer", "slicer(new)", "table", "matrix",
    "keyInfluencers", "decompositionTree", "q&AVisual", "textBox", "metrics",
    "paginatedReport",
];

/// Types that accept a full custom visual body (not just visualType)
const CUSTOM_BODY_TYPES: &[&str] = &["table", "card", "pieChart", "areaChart", "scatterChart"];

const DEFAULT_STYLE: &str =
    r#"{"x":52,"y":170,"width":400,"height":280,"z":0,"tabOrder":0}"#;

fn find_report_dir(base: &Path) -> Option<PathBuf> {
    fs::read_dir(base).ok()?.find_map(|e| {
        let p = e.ok()?.path();
        if p.is_dir() && p.extension().map(|x| x == "Report").unwrap_or(false) {
            Some(p)
        } else {
            None
        }
    })
}

fn find_page(pages_dir: &Path, display_name: &str) -> Option<PathBuf> {
    for entry in fs::read_dir(pages_dir).ok()?.flatten() {
        let page_json = entry.path().join("page.json");
        if page_json.is_file() {
            if let Ok(text) = fs::read_to_string(&page_json) {
                if let Ok(v) = serde_json::from_str::<Value>(&text) {
                    if v["displayName"].as_str() == Some(display_name) {
                        return Some(entry.path());
                    }
                }
            }
        }
    }
    None
}

/// Equivalent to create_visual.sh
pub fn run(base_dir: &str, page_name: &str, visual_type: &str, style_json: &str, visual: &str) {
    if !VALID_TYPES.contains(&visual_type) {
        eprintln!("Error: Invalid visualType '{}'.", visual_type);
        return;
    }

    let base = Path::new(base_dir);
    let report_dir = match find_report_dir(base) {
        Some(d) => d,
        None => {
            eprintln!("No *.Report folder found in {}", base_dir);
            return;
        }
    };

    let pages_dir = report_dir.join("definition/pages");
    let _ = fs::create_dir_all(&pages_dir);

    // Find or create page
    let page_dir = match find_page(&pages_dir, page_name) {
        Some(p) => p,
        None => {
            let page_id = Uuid::new_v4().to_string();
            let pd = pages_dir.join(&page_id);
            let _ = fs::create_dir_all(&pd);
            let page_json = json!({
                "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/page/2.0.0/schema.json",
                "name": page_id,
                "displayName": page_name,
                "displayOption": "FitToPage",
                "height": 720,
                "width": 1280
            });
            let _ = fs::write(pd.join("page.json"), serde_json::to_string_pretty(&page_json).unwrap());
            pd
        }
    };

    let visual_id = Uuid::new_v4().to_string();
    let visual_dir = page_dir.join("visuals").join(&visual_id);
    let _ = fs::create_dir_all(&visual_dir);

    let style: Value = serde_json::from_str(if style_json.is_empty() {
        DEFAULT_STYLE
    } else {
        style_json
    })
    .unwrap_or_else(|_| serde_json::from_str(DEFAULT_STYLE).unwrap());

    let visual_content = if CUSTOM_BODY_TYPES.contains(&visual_type) && !visual.is_empty() {
        let vis: Value = serde_json::from_str(visual)
            .unwrap_or_else(|_| json!({"visualType": visual_type}));
        json!({
            "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/visualContainer/2.4.0/schema.json",
            "name": visual_id,
            "position": style,
            "visual": vis
        })
    } else {
        json!({
            "$schema": "https://developer.microsoft.com/json-schemas/fabric/item/report/definition/visualContainer/2.4.0/schema.json",
            "name": visual_id,
            "position": style,
            "visual": { "visualType": visual_type }
        })
    };

    let out_path = visual_dir.join("visual.json");
    let _ = fs::write(&out_path, serde_json::to_string_pretty(&visual_content).unwrap());

    println!("Created visual: {} (Visual ID: {})", out_path.display(), visual_id);
    println!("Page      : {}", page_name);
    println!("VisualType: {}", visual_type);
    println!("Style     : {}", style);
}
