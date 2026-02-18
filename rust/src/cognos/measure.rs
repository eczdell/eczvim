use serde_json::Value;
use uuid::Uuid;

/// Extract the first alphanumeric+underscore token starting at `after` within `expr`.
fn capture_col(expr: &str, after: &str) -> Option<String> {
    let start = expr.find(after)? + after.len();
    let col: String = expr[start..]
        .chars()
        .take_while(|c| c.is_alphanumeric() || *c == '_')
        .collect();
    if col.is_empty() { None } else { Some(col) }
}

fn strip_whitespace(s: &str) -> String {
    s.chars().filter(|c| !c.is_whitespace()).collect()
}

fn safe_name(label: &str) -> String {
    label.replace('.', "_")
}

#[derive(Debug)]
enum DaxKind {
    DistinctCount,
    Sum,
    Average,
    Count,
    Manual,
}

fn classify(expr: &str) -> (DaxKind, Option<String>) {
    if expr.contains("count(distinct") {
        let col = capture_col(expr, "distinct");
        (DaxKind::DistinctCount, col)
    } else if expr.starts_with("total(") {
        let col = capture_col(expr, "total(");
        (DaxKind::Sum, col)
    } else if expr.starts_with("average(") {
        let col = capture_col(expr, "average(");
        (DaxKind::Average, col)
    } else if expr.starts_with("COUNT(") {
        let col = capture_col(expr, "COUNT(");
        (DaxKind::Count, col)
    } else {
        (DaxKind::Manual, None)
    }
}

fn build_dax(kind: &DaxKind, col: &Option<String>, table: &str, measure: &str) -> String {
    match (kind, col) {
        (DaxKind::DistinctCount, Some(c)) => {
            format!("{} = DISTINCTCOUNT({}[{}])", measure, table, c)
        }
        (DaxKind::Sum, Some(c)) => format!("{} = SUM({}[{}])", measure, table, c),
        (DaxKind::Average, Some(c)) => format!("{} = AVERAGE({}[{}])", measure, table, c),
        (DaxKind::Count, Some(c)) => format!("{} = COUNT({}[{}])", measure, table, c),
        _ => String::new(),
    }
}

fn build_tmdl(kind: &DaxKind, col: &Option<String>, table: &str, measure: &str, expr: &str) -> String {
    let uuid = Uuid::new_v4().to_string();
    match (kind, col) {
        (DaxKind::DistinctCount, Some(c)) => format!(
            "measure {} = DISTINCTCOUNT({}[{}])\n\tformatString: 0\n\tlineageTag: {}",
            measure, table, c, uuid
        ),
        (DaxKind::Sum, Some(c)) => format!(
            "measure {} = SUM({}[{}])\n\tformatString: 0\n\tlineageTag: {}",
            measure, table, c, uuid
        ),
        (DaxKind::Average, Some(c)) => format!(
            "measure {} = AVERAGE({}[{}])\n\tformatString: 0\n\tlineageTag: {}",
            measure, table, c, uuid
        ),
        (DaxKind::Count, Some(c)) => format!(
            "measure {} = COUNT({}[{}])\n\tformatString: 0\n\tlineageTag: {}",
            measure, table, c, uuid
        ),
        _ => format!("/* Manual DAX needed: {} */", expr),
    }
}

/// Measure Extraction from Cognos module JSON — equivalent to measures.sh
pub fn parse_measures(v: &Value) {
    println!("\n==================== Measures ======================");

    let sources = match v["features"]["DataSources"].as_array() {
        Some(a) => a,
        None => {
            println!("No DataSources found");
            return;
        }
    };

    // Collect all measures grouped by table
    let mut table_groups: std::collections::BTreeMap<String, Vec<Value>> =
        std::collections::BTreeMap::new();

    for source in sources {
        let subjects = match source["shaping"]["moserJSON"]["querySubject"].as_array() {
            Some(a) => a,
            None => continue,
        };

        for qs in subjects {
            let table_raw = qs["identifier"].as_str().unwrap_or("unknown");
            let table = table_raw.trim_end_matches("_csv").to_string();

            let items = match qs["item"].as_array() {
                Some(a) => a,
                None => continue,
            };

            for item in items {
                let label = match item["queryItem"]["label"].as_str() {
                    Some(l) => l,
                    None => continue,
                };

                let raw_expr = item["queryItem"]["expression"].as_str().unwrap_or("");
                let expr = strip_whitespace(raw_expr);
                let measure = safe_name(label);

                let (kind, col) = classify(&expr);
                let dax = build_dax(&kind, &col, &table, &measure);
                let tmdl = build_tmdl(&kind, &col, &table, &measure, &expr);

                let entry = serde_json::json!({
                    "table": table,
                    "measure_name": measure,
                    "expression": expr,
                    "dax_expression": dax,
                    "measure_definition": tmdl
                });

                table_groups.entry(table.clone()).or_default().push(entry);
            }
        }
    }

    if table_groups.is_empty() {
        println!("No measures found");
        return;
    }

    for (table, measures) in &table_groups {
        println!("--------------------------------------");
        println!("Table: {}", table);
        for m in measures {
            println!("  Measure    : {}", m["measure_name"].as_str().unwrap_or(""));
            println!("  Expression : {}", m["expression"].as_str().unwrap_or(""));
            println!("  DAX        : {}", m["dax_expression"].as_str().unwrap_or(""));
            println!("  TMDL       :");
            for line in m["measure_definition"].as_str().unwrap_or("").lines() {
                println!("    {}", line);
            }
            println!();
        }
    }
}
