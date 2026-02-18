// ---------------------------------------------------------------------------
// IBM Cognos → Power BI visual type mapping (pages.sh map_ibm_to_pbi)
// ---------------------------------------------------------------------------
#[allow(dead_code)]
pub fn map_ibm_to_pbi(t: &str) -> &str {
    match t {
        "clusteredBar" => "clusteredBarChart",
        "stackedBar" => "stackedBarChart",
        "clusteredColumn" => "clusteredColumnChart",
        "stackedColumn" => "stackedColumnChart",
        "pie" => "pieChart",
        "donut" => "donutChart",
        "line" => "lineChart",
        "area" => "areaChart",
        "scatter" => "scatterChart",
        "treemap" => "treemap",
        "table" => "table",
        "matrix" => "matrix",
        _ => t,
    }
}

// ---------------------------------------------------------------------------
// Map a Cognos visId / type string to a Power BI visual type.
// ---------------------------------------------------------------------------
pub fn map_cogvis(cogvis: &str) -> &'static str {
    let s = cogvis.to_lowercase();
    if s.contains("bundlebar") {
        "clusteredBarChart"
    } else if s.contains("bundlecolumn") {
        "clusteredColumnChart"
    } else if s.contains("bundleline") || s.contains("rave2line") {
        "lineChart"
    } else if s.contains("bundlearea") {
        "areaChart"
    } else if s.contains("bundlestackedbar") {
        "stackedBarChart"
    } else if s.contains("bundlestackedcolumn") {
        "stackedColumnChart"
    } else if s.contains("bundlecombo") || s.contains("rave2bundlecomposite") {
        "lineStackedColumnComboChart"
    } else if s.contains("pie") {
        "pieChart"
    } else if s.contains("donut") {
        "donutChart"
    } else if s.contains("card") || s.contains("metric") || s.contains("kpi") {
        "card"
    } else if s.contains("jqgrid") || s.contains("list") || s.contains("table") {
        "table"
    } else if s.contains("crosstab") {
        "matrix"
    } else if s.contains("filter") {
        "slicer"
    } else if s.contains("tiledmap") {
        "map"
    } else if s.contains("treemap") {
        "treemap"
    } else if s.contains("ravescatter") {
        "scatterChart"
    } else if s.contains("summary") {
        "card"
    } else if s.contains("text") {
        "textBox"
    } else {
        "Unknown"
    }
}

// ---------------------------------------------------------------------------
// Map a Cognos slot name to a Power BI field bucket.
// ---------------------------------------------------------------------------
pub fn map_slot(slot: &str) -> &'static str {
    match slot {
        "actual" => "Values",
        "goal" => "Target",
        "sparkline.actual" => "Trend",
        _ => "N/A",
    }
}
