use serde_json::{json, Value};
use std::fs;
use std::path::{Path, PathBuf};

/// Recursively find a page.json whose displayName matches `title`.
fn find_page_by_title(pages_dir: &Path, title: &str) -> Option<String> {
    for entry in fs::read_dir(pages_dir).ok()?.flatten() {
        let page_json = entry.path().join("page.json");
        if page_json.is_file() {
            if let Ok(text) = fs::read_to_string(&page_json) {
                if let Ok(v) = serde_json::from_str::<Value>(&text) {
                    if v["displayName"].as_str() == Some(title) {
                        // Return the folder name (== page ID)
                        return entry.file_name().to_str().map(|s| s.to_string());
                    }
                }
            }
        }
    }
    None
}

/// Equivalent to ordering.sh — resolves page order and updates pages.json
pub fn run(base_path: &str, cognos_json: &str) {
    // Read Cognos JSON
    let content = match fs::read_to_string(cognos_json) {
        Ok(c) => c,
        Err(e) => {
            eprintln!("Error reading '{}': {}", cognos_json, e);
            return;
        }
    };
    let v: Value = match serde_json::from_str(&content) {
        Ok(v) => v,
        Err(e) => {
            eprintln!("JSON parse error: {}", e);
            return;
        }
    };

    let report_name = v["name"].as_str().unwrap_or("unknown");
    let pages_dir = PathBuf::from(base_path)
        .join(report_name)
        .join(format!("{}.Report", report_name))
        .join("definition/pages");

    let pages_metadata = pages_dir.join("pages.json");

    println!("Pages dir      : {}", pages_dir.display());
    println!("Pages metadata : {}", pages_metadata.display());

    // Build ordered page ID list from layout.items
    let mut page_order: Vec<String> = Vec::new();
    if let Some(items) = v["layout"]["items"].as_object() {
        let mut sorted_items: Vec<(&String, &Value)> = items.iter().collect();
        // Sort by key (numeric order)
        sorted_items.sort_by_key(|(k, _)| k.parse::<usize>().unwrap_or(usize::MAX));

        for (_, item) in sorted_items {
            let title = item["title"]["translationTable"]["Default"]
                .as_str()
                .unwrap_or("")
                .replace('\n', "");

            if title.is_empty() {
                continue;
            }
            println!("Resolving page title: [{}]", title);

            match find_page_by_title(&pages_dir, &title) {
                Some(page_id) => {
                    println!("  → page ID: {}", page_id);
                    page_order.push(page_id);
                }
                None => eprintln!("  → No match found for '{}'", title),
            }
        }
    }

    println!("\nPAGE_ORDER = {:?}", page_order);

    // Resolve active page
    let selected_tab_id = v["layout"]["selectedTabId"].as_str().unwrap_or("");
    let active_title = v["layout"]["items"]
        .as_object()
        .and_then(|items| {
            items.values().find(|item| {
                item["id"].as_str() == Some(selected_tab_id)
            })
        })
        .and_then(|item| item["title"]["translationTable"]["Default"].as_str())
        .unwrap_or("");

    let active_page_id = find_page_by_title(&pages_dir, active_title).unwrap_or_default();
    println!("Selected tab title : {}", active_title);
    println!("Active page id     : {}", active_page_id);

    // Read current pages.json
    let current: Value = fs::read_to_string(&pages_metadata)
        .ok()
        .and_then(|t| serde_json::from_str(&t).ok())
        .unwrap_or(json!({}));

    println!(
        "\nBefore: pageOrder={:?}, activePageName={:?}",
        current["pageOrder"], current["activePageName"]
    );

    // Update pages.json
    let mut updated = current.clone();
    updated["pageOrder"] = json!(page_order);
    updated["activePageName"] = json!(active_page_id);

    match fs::write(&pages_metadata, serde_json::to_string_pretty(&updated).unwrap()) {
        Ok(_) => println!("Updated: {}", pages_metadata.display()),
        Err(e) => eprintln!("Error writing pages.json: {}", e),
    }

    // Find abandoned pages (on disk but not in page_order)
    println!("\nAbandoned pages:");
    let mut abandoned = false;
    if let Ok(entries) = fs::read_dir(&pages_dir) {
        for entry in entries.flatten() {
            let name = entry.file_name().to_string_lossy().to_string();
            if name == "pages.json" {
                continue;
            }
            if entry.path().is_dir() && !page_order.contains(&name) {
                println!("  {}", name);
                // Remove abandoned page directory
                if let Err(e) = fs::remove_dir_all(entry.path()) {
                    eprintln!("  Error removing '{}': {}", entry.path().display(), e);
                } else {
                    println!("  Removed: {}", entry.path().display());
                }
                abandoned = true;
            }
        }
    }
    if !abandoned {
        println!("  None");
    }
}
