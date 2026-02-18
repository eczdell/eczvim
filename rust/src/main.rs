use std::env;
use std::fs;

use serde_json::Value;

mod cognos;
mod platforms;

fn print_usage(bin: &str) {
    eprintln!(
        "Usage:
  {bin} parse         <json-file> [...]    Parse Cognos report JSON (all parsers)
  {bin} measures      <module-json>        Extract DAX measures from module JSON
  {bin} layout        <cognos-json>        Map Cognos layout visuals → Power BI
  {bin} create-report <project-name>       Create a PBIP project from template
  {bin} create-visual <base-dir> <page> <visual-type> [<style-json>] [<visual>]
  {bin} tmdl          <csv-file> [<project>] Generate TMDL from a CSV file
  {bin} module        <module-json> <project> Generate TMDL from a Cognos Data Module
  {bin} ordering      <base-path> <cognos-json>  Resolve and update page order"
    );
}

fn load_json(path: &str) -> Option<Value> {
    let content = match fs::read_to_string(path) {
        Ok(c) => c,
        Err(e) => {
            eprintln!("Error reading '{}': {}", path, e);
            return None;
        }
    };
    match serde_json::from_str(&content) {
        Ok(v) => Some(v),
        Err(e) => {
            eprintln!("JSON parse error in '{}': {}", path, e);
            None
        }
    }
}

fn run_report_parsers(v: &Value) {
    cognos::info::parse_info(v);
    cognos::relationship::parse_relationships(v);

    let controls = cognos::visual::extract_viz_controls(v);
    cognos::visual::print_viz_controls(&controls);
    platforms::powerbi::visual_gen::generate_list_visuals(v);

    cognos::query::parse_queries(v);
    cognos::crosstab::parse_crosstabs(v);
    cognos::parameter::parse_parameters(v);
    cognos::variable::parse_variables(v);
    cognos::datastore::parse_datastores(v);
    cognos::style::parse_styles(v);
    cognos::text_css::parse_text_css(v);
}

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() < 2 {
        print_usage(&args[0]);
        std::process::exit(1);
    }

    match args[1].as_str() {
        // ── Report JSON parsers ─────────────────────────────────────────────
        "parse" => {
            if args.len() < 3 {
                eprintln!("Usage: {} parse <json-file> [...]", args[0]);
                std::process::exit(1);
            }
            for file in &args[2..] {
                println!("\n============================================================");
                println!("Processing: {}", file);
                println!("============================================================");
                if let Some(v) = load_json(file) {
                    run_report_parsers(&v);
                }
            }
        }

        // ── Module JSON → DAX measures ──────────────────────────────────────
        "measures" => {
            if args.len() < 3 {
                eprintln!("Usage: {} measures <module-json>", args[0]);
                std::process::exit(1);
            }
            if let Some(v) = load_json(&args[2]) {
                cognos::measure::parse_measures(&v);
            }
        }

        // ── Cognos layout JSON → Power BI visual map ────────────────────────
        "layout" => {
            if args.len() < 3 {
                eprintln!("Usage: {} layout <cognos-json>", args[0]);
                std::process::exit(1);
            }
            if let Some(v) = load_json(&args[2]) {
                cognos::layout::parse_layout(&v);
            }
        }

        // ── Create PBIP project from template ───────────────────────────────
        "create-report" => {
            if args.len() < 3 {
                eprintln!("Usage: {} create-report <project-name>", args[0]);
                std::process::exit(1);
            }
            platforms::powerbi::create_report::run(&args[2]);
        }

        // ── Create a visual inside a PBIP project ───────────────────────────
        "create-visual" => {
            if args.len() < 5 {
                eprintln!(
                    "Usage: {} create-visual <base-dir> <page> <visual-type> [<style-json>] [<visual>]",
                    args[0]
                );
                std::process::exit(1);
            }
            let base_dir = &args[2];
            let page = &args[3];
            let vtype = &args[4];
            let style = args.get(5).map(|s| s.as_str()).unwrap_or("");
            let visual = args.get(6).map(|s| s.as_str()).unwrap_or("");
            platforms::powerbi::create_visual::run(base_dir, page, vtype, style, visual);
        }

        // ── Cognos Module JSON → TMDL ────────────────────────────────────────
        "module" => {
            if args.len() < 4 {
                eprintln!("Usage: {} module <module-json> <project>", args[0]);
                std::process::exit(1);
            }
            platforms::powerbi::tmdl_from_module::run(&args[2], &args[3]);
        }

        // ── Resolve page order and update pages.json ─────────────────────────
        "ordering" => {
            if args.len() < 4 {
                eprintln!("Usage: {} ordering <base-path> <cognos-json>", args[0]);
                std::process::exit(1);
            }
            platforms::powerbi::ordering::run(&args[2], &args[3]);
        }

        // ── Backward-compat: bare file path → parse ──────────────────────────
        _ => {
            for file in &args[1..] {
                println!("\n============================================================");
                println!("Processing: {}", file);
                println!("============================================================");
                if let Some(v) = load_json(file) {
                    run_report_parsers(&v);
                }
            }
        }
    }
}
