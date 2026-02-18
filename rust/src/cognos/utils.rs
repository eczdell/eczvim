use serde_json::Value;
use std::fs;

/// Detect if we are running under WSL.
pub fn is_wsl() -> bool {
    fs::read_to_string("/proc/version")
        .map(|v| v.to_lowercase().contains("microsoft"))
        .unwrap_or(false)
}

/// Convert an absolute Linux path to a WSL UNC path for Power BI (Windows).
pub fn to_wsl_path(path: &str) -> String {
    let stripped = path.trim_start_matches('/');
    let win = stripped.replace('/', "\\");
    format!("\\\\wsl.localhost\\Ubuntu\\{}", win)
}

/// Recursively collect all objects that contain `key`.
pub fn collect_with_key<'a>(v: &'a Value, key: &str, results: &mut Vec<&'a Value>) {
    match v {
        Value::Object(map) => {
            if map.contains_key(key) {
                results.push(v);
            }
            for val in map.values() {
                collect_with_key(val, key, results);
            }
        }
        Value::Array(arr) => {
            for val in arr {
                collect_with_key(val, key, results);
            }
        }
        _ => {}
    }
}

/// Normalise a JSON value to `Vec<&Value>`: arrays stay as-is, objects/scalars get wrapped.
pub fn as_slice(v: &Value) -> Vec<&Value> {
    match v {
        Value::Array(arr) => arr.iter().collect(),
        Value::Null => vec![],
        _ => vec![v],
    }
}

/// Sanitise a string so it is a legal directory name on both Windows and Linux.
/// Windows forbids: \ / : * ? " < > |   and names ending with . or space.
pub fn sanitise_name(name: &str) -> String {
    let cleaned: String = name
        .chars()
        .map(|c| match c {
            '\\' | '/' | ':' | '*' | '?' | '"' | '<' | '>' | '|' => '_',
            c => c,
        })
        .collect();
    // Strip trailing dots/spaces (illegal on Windows)
    cleaned.trim_end_matches(['.', ' ']).to_string()
}
