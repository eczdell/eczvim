use serde_json::Value;

use super::utils::as_slice;

/// Report Variables — equivalent to reportVariables.sh
pub fn parse_variables(v: &Value) {
    println!("\n==================== Report Variables =====================");

    let raw = &v["report"]["reportVariables"]["reportVariable"];
    let vars = as_slice(raw);

    if vars.is_empty() {
        println!("No report variables found");
        return;
    }

    for var in vars {
        let name = var["+@name"].as_str().unwrap_or("N/A");
        let type_ = var["+@type"].as_str().unwrap_or("N/A");
        let expr = var["reportExpression"].as_str().unwrap_or("N/A");

        // Values: variableValues.variableValue → normalize → map "+@value"
        let values_str = {
            let raw_vals = &var["variableValues"]["variableValue"];
            let vals = as_slice(raw_vals);
            if vals.is_empty() {
                String::new()
            } else {
                vals.iter()
                    .filter_map(|vv| vv["+@value"].as_str())
                    .collect::<Vec<_>>()
                    .join(", ")
            }
        };

        println!("--------------------------------------");
        println!("Name        : {}", name);
        println!("Type        : {}", type_);
        println!("Expression  : {}", expr);
        if !values_str.is_empty() {
            println!("Values      : {}", values_str);
        }
    }
}
