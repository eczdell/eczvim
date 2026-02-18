use serde_json::Value;
use std::fs;
use std::path::Path;
use uuid::Uuid;

use crate::cognos::utils::{is_wsl, to_wsl_path};

// ---------------------------------------------------------------------------
// Cognos highlevelDatatype → Power BI dataType
// ---------------------------------------------------------------------------
fn map_dtype(highlevel: &str) -> &'static str {
    match highlevel {
        "integer"            => "Int64",
        "string"             => "String",
        "number" | "double"  => "Double",
        "decimal"            => "Decimal",
        "date" | "datetime"  => "DateTime",
        "boolean"            => "Boolean",
        "binary"             => "Binary",
        "variant"            => "Variant",
        _                    => "Unknown",
    }
}

// ---------------------------------------------------------------------------
// Power BI dataType → M type expression
// ---------------------------------------------------------------------------
fn map_m_dtype(pbi_type: &str) -> &'static str {
    match pbi_type {
        "Int64"             => "Int64.Type",
        "Double" | "Decimal" => "type number",
        "String"            => "type text",
        "DateTime"          => "type datetime",
        "Boolean"           => "type logical",
        _                   => "type any",
    }
}

// ---------------------------------------------------------------------------
// Cognos regularAggregate + datatypeCategory → Power BI summarizeBy
// ---------------------------------------------------------------------------
fn map_summarize(aggregate: &str, category: &str) -> &'static str {
    match category {
        "number" => match aggregate {
            "count" | "countDistinct"   => "Count",
            "sum"   | "total"           => "Sum",
            "average"                   => "Average",
            "minimum"                   => "Minimum",
            "maximum"                   => "Maximum",
            _                           => "None",
        },
        "string" => match aggregate {
            "count" | "countDistinct"   => "Count",
            _                           => "None",
        },
        "datetime" => match aggregate {
            "count" | "countDistinct"   => "Count",
            "earliest" | "minimum"      => "Earliest",
            "latest"   | "maximum"      => "Latest",
            _                           => "None",
        },
        _ => "None",
    }
}

// ---------------------------------------------------------------------------
// Public entry point
// ---------------------------------------------------------------------------
pub fn run(json_path: &str, report_name: &str) {
    let content = match fs::read_to_string(json_path) {
        Ok(c) => c,
        Err(e) => {
            eprintln!("Error reading '{}': {}", json_path, e);
            return;
        }
    };
    let v: Value = match serde_json::from_str(&content) {
        Ok(v) => v,
        Err(e) => {
            eprintln!("JSON parse error in '{}': {}", json_path, e);
            return;
        }
    };

    println!("-------- Processing Module --------");
    println!("Module JSON : {}", json_path);
    println!("Report Name : {}", report_name);

    let project_dir = Path::new("/tmp/projects").join(report_name);

    // ── 1. Bootstrap full project from template if it doesn't exist yet ──────
    if !project_dir.exists() {
        super::create_report::run(report_name);
    }

    let output_dir = project_dir
        .join(format!("{}.SemanticModel", report_name))
        .join("definition/tables");

    if let Err(e) = fs::create_dir_all(&output_dir) {
        eprintln!("Error creating output dir: {}", e);
        return;
    }

    let tables = match v["querySubject"].as_array() {
        Some(a) => a,
        None => {
            eprintln!("No querySubject array found in '{}'", json_path);
            return;
        }
    };

    let mut table_names: Vec<String> = Vec::new();

    for table in tables {
        let raw_name = table["label"].as_str().unwrap_or("unknown");
        let table_name = raw_name.replace(' ', "_");
        table_names.push(table_name.clone());
        let out_file = output_dir.join(format!("{}.tmdl", table_name));

        // Collect visible columns
        let cols: Vec<&Value> = match table["item"].as_array() {
            Some(items) => items
                .iter()
                .filter_map(|item| {
                    let qi = &item["queryItem"];
                    if qi.is_null() { return None; }
                    if qi["hidden"].as_bool() == Some(true) { return None; }
                    Some(qi)
                })
                .collect(),
            None => vec![],
        };

        let col_count = cols.len();
        let mut out = String::new();

        // ── Table header ─────────────────────────────────────────────────────
        out.push_str(&format!("table {}\n", table_name));
        out.push_str(&format!("\tlineageTag: {}\n\n", Uuid::new_v4()));

        // ── Columns ──────────────────────────────────────────────────────────
        let mut m_types: Vec<String> = Vec::new();

        for col in &cols {
            let col_name  = col["identifier"].as_str().unwrap_or("unknown");
            let highlevel = col["highlevelDatatype"].as_str().unwrap_or("");
            let category  = col["datatypeCategory"].as_str().unwrap_or("");
            let aggregate = col["regularAggregate"].as_str().unwrap_or("");

            let pbi_type  = map_dtype(highlevel);
            let summarize = map_summarize(aggregate, category);
            let m_type    = map_m_dtype(pbi_type);

            out.push_str(&format!("\tcolumn {}\n", col_name));
            out.push_str(&format!("\t\tdataType: {}\n", pbi_type));
            if pbi_type == "DateTime" {
                out.push_str("\t\tformatString: Long Date\n");
            }
            out.push_str(&format!("\t\tlineageTag: {}\n", Uuid::new_v4()));
            out.push_str(&format!("\t\tsummarizeBy: {}\n", summarize));
            out.push_str("\n\t\tannotation SummarizationSetBy = Automatic\n\n");

            m_types.push(format!("\t\t\t\t\t\t{{\"{}\", {}}}", col_name, m_type));
        }

        // ── Partition (M expression) ──────────────────────────────────────────
        let abs_path = format!("/home/sabin/cognos/data/{}", table_name);
        let pb_csv = if is_wsl() {
            to_wsl_path(&abs_path)
        } else {
            abs_path
        };
        let m_joined = {
            let last = m_types.len().saturating_sub(1);
            m_types
                .iter()
                .enumerate()
                .map(|(i, s)| if i == last { s.clone() } else { format!("{},", s) })
                .collect::<Vec<_>>()
                .join("\n")
        };

        out.push_str(&format!("\tpartition {} = m\n", table_name));
        out.push_str("\t\tmode: import\n");
        out.push_str("\t\tsource =\n");
        out.push_str("\t\t\tlet\n");
        out.push_str(&format!(
            "\t\t\t\tSource =\n\
             \t\t\t\t\tCsv.Document(\n\
             \t\t\t\t\t\tFile.Contents(\"{}\"),\n\
             \t\t\t\t\t\t[Delimiter=\",\", Columns={}, Encoding=1252, QuoteStyle=QuoteStyle.None]\n\
             \t\t\t\t\t),\n\n",
            pb_csv, col_count
        ));
        out.push_str(
            "\t\t\t\t#\"Promoted Headers\" =\n\
             \t\t\t\t\tTable.PromoteHeaders(\n\
             \t\t\t\t\t\tSource,\n\
             \t\t\t\t\t\t[PromoteAllScalars=true]\n\
             \t\t\t\t\t),\n\n",
        );
        out.push_str(&format!(
            "\t\t\t\t#\"Changed Type\" =\n\
             \t\t\t\t\tTable.TransformColumnTypes(\n\
             \t\t\t\t\t\t#\"Promoted Headers\",\n\
             \t\t\t\t\t\t{{\n\
             {}\n\
             \t\t\t\t\t\t}}\n\
             \t\t\t\t\t)\n",
            m_joined
        ));
        out.push_str("\t\t\tin\n");
        out.push_str("\t\t\t\t#\"Changed Type\"\n\n");
        out.push_str("\tannotation PBI_ResultType = Table\n");

        // ── Print + write ─────────────────────────────────────────────────────
        print!("{}", out);

        match fs::write(&out_file, &out) {
            Ok(_) => println!("✔ TMDL written to {}", out_file.display()),
            Err(e) => eprintln!("  Error writing '{}': {}", out_file.display(), e),
        }
    }

    // ── Extract and generate Relationships ────────────────────────────────────
    if let Some(rels) = v["relationship"].as_array() {
        println!("-------- Processing Relationships --------");
        let model_file = output_dir.parent().unwrap().join("model.tmdl");
        let mut rels_out = String::new();

        for (i, rel) in rels.iter().enumerate() {
            let left_table  = rel["left"]["ref"].as_str().unwrap_or("unknown").replace(' ', "_");
            let right_table = rel["right"]["ref"].as_str().unwrap_or("unknown").replace(' ', "_");

            if let Some(links) = rel["link"].as_array() {
                if let Some(link) = links.first() {
                    let from_col = link["leftRef"].as_str().unwrap_or("unknown");
                    let to_col   = link["rightRef"].as_str().unwrap_or("unknown");

                    let rel_id = format!("rel_{}", i); 
                    rels_out.push_str(&format!("\nrelationship {}\n", rel_id));
                    rels_out.push_str(&format!("\tfromColumn: {}.{}\n", left_table, from_col));
                    rels_out.push_str(&format!("\ttoColumn: {}.{}\n", right_table, to_col));
                }
            }
        }

        if !rels_out.is_empty() {
            if let Ok(mut content) = fs::read_to_string(&model_file) {
                if !content.contains("relationship rel_0") {
                    content.push_str(&rels_out);
                    let _ = fs::write(&model_file, content);
                    println!("✔ Relationships appended to model.tmdl");
                }
            }
        }
    }

    // ── Update model.tmdl with ref table entries ──────────────────────────────
    let model_file = output_dir.parent().unwrap().join("model.tmdl");
    if let Ok(mut content) = fs::read_to_string(&model_file) {
        let mut lines: Vec<String> = content.lines().map(|s| s.to_string()).collect();
        let mut changed = false;

        for table_name in &table_names {
            let ref_line = format!("ref table {}", table_name);
            if !lines.iter().any(|l| l.trim() == ref_line) {
                lines.push(ref_line);
                changed = true;
            }
        }

        if changed {
            content = lines.join("\n") + "\n";
            let _ = fs::write(&model_file, content);
            println!("✔ Updated model.tmdl with table references");
        }
    }
}
