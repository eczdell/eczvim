use serde_json::Value;

fn extract_pages<'a>(layout: &'a Value, page_type: &str) -> Vec<&'a Value> {
    let pages_obj = &layout[page_type];
    if pages_obj.is_null() {
        return vec![];
    }
    let page = &pages_obj["page"];
    match page {
        Value::Array(arr) => arr.iter().collect(),
        Value::Object(_) => vec![page],
        _ => vec![],
    }
}

/// Report Summary — equivalent to pages.sh §1
pub fn parse_info(v: &Value) {
    println!("\n==================== Report Summary ======================");

    let report_name = v["report"]["reportName"].as_str().unwrap_or("N/A");
    println!("Report Name: {}", report_name);

    let layout = &v["report"]["layouts"]["layout"];

    let report_pages = extract_pages(layout, "reportPages");
    let prompt_pages = extract_pages(layout, "promptPages");

    let report_names: Vec<&str> = report_pages
        .iter()
        .filter_map(|p| p["+@name"].as_str())
        .collect();

    let prompt_names: Vec<&str> = prompt_pages
        .iter()
        .filter_map(|p| p["+@name"].as_str())
        .collect();

    let report_names_str = if report_names.is_empty() {
        "N/A".to_string()
    } else {
        report_names.join(", ")
    };

    let prompt_names_str = if prompt_names.is_empty() {
        "N/A".to_string()
    } else {
        prompt_names.join(", ")
    };

    println!("\n{:<15} {:<7} {}", "Type", "Count", "Names");
    println!(
        "{:<15} {:<7} {}",
        "Report Pages",
        report_pages.len(),
        report_names_str
    );
    println!(
        "{:<15} {:<7} {}",
        "Prompt Pages",
        prompt_pages.len(),
        prompt_names_str
    );
}
