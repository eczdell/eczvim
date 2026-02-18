use std::fs;
use std::io;
use std::path::Path;

fn copy_dir_all(src: &Path, dst: &Path) -> io::Result<()> {
    fs::create_dir_all(dst)?;
    for entry in fs::read_dir(src)? {
        let entry = entry?;
        let dst_entry = dst.join(entry.file_name());
        if entry.file_type()?.is_dir() {
            copy_dir_all(&entry.path(), &dst_entry)?;
        } else {
            fs::copy(entry.path(), &dst_entry)?;
        }
    }
    Ok(())
}

fn replace_in_dir(dir: &Path, from: &str, to: &str) -> io::Result<()> {
    for entry in fs::read_dir(dir)? {
        let path = entry?.path();
        if path.is_dir() {
            replace_in_dir(&path, from, to)?;
        } else if let Ok(text) = fs::read_to_string(&path) {
            if text.contains(from) {
                fs::write(&path, text.replace(from, to))?;
            }
        }
    }
    Ok(())
}

fn check_remaining(dir: &Path, needle: &str, found: &mut bool) {
    let Ok(rd) = fs::read_dir(dir) else { return };
    for entry in rd.flatten() {
        let path = entry.path();
        if path.is_dir() {
            check_remaining(&path, needle, found);
        } else if let Ok(text) = fs::read_to_string(&path) {
            if text.contains(needle) {
                println!("  Remaining ref: {}", path.display());
                *found = true;
            }
        }
    }
}

/// Equivalent to create_report.sh
pub fn run(project_name: &str) {
    let base_path = Path::new("/tmp/projects");
    let template_path = Path::new("project");
    let dest_path = base_path.join(project_name);

    // ── mkdir -p "$BASE_PATH" ────────────────────────────────────────────────
    if let Err(e) = fs::create_dir_all(base_path) {
        eprintln!("Error creating output dir: {}", e);
        return;
    }

    // ── Guard: destination must not already exist ────────────────────────────
    if dest_path.exists() {
        eprintln!(
            "Error: Destination folder '{}' already exists.",
            dest_path.display()
        );
        return;
    }

    // ── cp -r "$TEMPLATE_PATH" "$DEST_PATH" ──────────────────────────────────
    if let Err(e) = copy_dir_all(template_path, &dest_path) {
        eprintln!("Error copying template: {}", e);
        return;
    }

    // ── Rename sample.Report ─────────────────────────────────────────────────
    let report_src = dest_path.join("sample.Report");
    if report_src.exists() {
        if let Err(e) = fs::rename(&report_src, dest_path.join(format!("{}.Report", project_name))) {
            eprintln!("Rename error (Report): {}", e);
        }
    }

    // ── Rename sample.SemanticModel ──────────────────────────────────────────
    let model_src = dest_path.join("sample.SemanticModel");
    if model_src.exists() {
        if let Err(e) = fs::rename(&model_src, dest_path.join(format!("{}.SemanticModel", project_name))) {
            eprintln!("Rename error (SemanticModel): {}", e);
        }
    }

    // ── Rename sample.pbip ───────────────────────────────────────────────────
    let pbip_src = dest_path.join("sample.pbip");
    if pbip_src.exists() {
        if let Err(e) = fs::rename(&pbip_src, dest_path.join(format!("{}.pbip", project_name))) {
            eprintln!("Rename error (.pbip): {}", e);
        }
    }

    // ── sed -i "s/sample/$PROJECT_NAME/g" — update all internal references ───
    println!("Updating internal references 'sample' → '{}'...", project_name);
    if let Err(e) = replace_in_dir(&dest_path, "sample", project_name) {
        eprintln!("Replace error: {}", e);
    }

    // ── grep -R "sample" — verify no references remain ──────────────────────
    let mut found = false;
    check_remaining(&dest_path, "sample", &mut found);
    if found {
        println!("Warning: some 'sample' references remain.");
    } else {
        println!("No leftover references found.");
    }

    // ── Confirm ──────────────────────────────────────────────────────────────
    println!(
        "PBIP project '{}' created successfully at '{}'",
        project_name,
        dest_path.display()
    );
    println!(
        "Open this folder in Power BI Desktop:\n   {}/{}.pbip",
        dest_path.display(),
        project_name
    );
}
