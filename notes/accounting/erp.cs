/******************************************
Nepal ERP-style Accounting + HR System
IFRS-compatible Chart of Accounts, Sample Data, Dashboard, Day Book
******************************************/

function seedERPSystem() {
  deleteAllSheets();
  setupConfigurationSheets();
  createNavigationTOC();
  styleNavigationButtons();
}

/********************
DELETE ALL SHEETS SAFELY
********************/
function deleteAllSheets() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheets = ss.getSheets();
  
  if (sheets.length === 0) ss.insertSheet("TempSheet");
  
  const keepSheet = ss.getSheets()[0];
  sheets.forEach(sheet => {
    if (sheet.getName() !== keepSheet.getName()) ss.deleteSheet(sheet);
  });

  keepSheet.setName("Dashboard");
  keepSheet.clear();
  keepSheet.getRange("A1").setValue("New Dashboard").setFontWeight("bold").setFontSize(16);
}

/********************
SETUP CONFIGURATION SHEETS & SEED DATA
********************/
function setupConfigurationSheets() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const dashboard = ss.getSheetByName("Dashboard");
  dashboard.clear();

  // --- Chart of Accounts (IFRS style) ---
  let coa = ss.insertSheet("ChartOfAccounts");
  coa.getRange("A1:D1").setValues([["Account Code","Account Name","Type","VAT Applicable"]]);
  const coaData = [
    ["1001","Cash and Cash Equivalents","Asset","No"],
    ["1002","Financial Assets","Asset","No"],
    ["1003","Trade Receivables","Asset","No"],
    ["1004","Inventories","Asset","No"],
    ["1005","Property, Plant & Equipment","Asset","No"],
    ["1006","Intangible Assets","Asset","No"],
    ["1007","Right of Use Assets","Asset","No"],
    ["2001","Trade Payables","Liability","No"],
    ["2002","Borrowings","Liability","No"],
    ["2003","Lease Liabilities","Liability","No"],
    ["2004","Deferred Tax Liabilities","Liability","No"],
    ["3001","Share Capital","Equity","No"],
    ["3002","Retained Earnings","Equity","No"],
    ["3003","Other Equity Items","Equity","No"],
    ["4001","Sales Revenue","Revenue","Yes"],
    ["4002","Service Revenue","Revenue","Yes"],
    ["5001","Cost of Sales","Expense","Yes"],
    ["5002","Operating Expenses","Expense","No"],
    ["5003","Depreciation / Amortization","Expense","No"],
    ["5004","Finance Cost","Expense","No"]
  ];
  coa.getRange(2,1,coaData.length,coaData[0].length).setValues(coaData);
  coa.getRange("A1:D1").setBackground("#1f4e78").setFontColor("white");

  // --- VAT Settings ---
  let vat = ss.insertSheet("VAT_Settings");
  vat.getRange("A1:B2").setValues([["VAT_Rate","13%"],["Effective","Yes"]]);
  vat.getRange("A1:B1").setBackground("#FF9800").setFontColor("white");

  // --- Employees ---
  let emp = ss.insertSheet("Employees");
  emp.getRange("A1:F1").setValues([["Employee ID","Name","Department","Salary Type","Salary Rate","Status"]]);
  const empData = [
    ["E001","Sabin Silwal","Accounting","Monthly",40000,"Active"],
    ["E002","Sita Lama","HR","Monthly",35000,"Active"],
    ["E003","Ram Thapa","IT","Daily",1500,"Active"],
    ["E004","Gita Rai","Sales","Monthly",30000,"Inactive"],
    ["E005","Kiran Shrestha","Support","Hourly",250,"Active"]
  ];
  emp.getRange(2,1,empData.length,empData[0].length).setValues(empData);
  emp.getRange("A1:F1").setBackground("#4CAF50").setFontColor("white");

  // --- Attendance ---
  let att = ss.insertSheet("Attendance");
  att.getRange("A1:F1").setValues([["Date","Employee ID","Name","Status","Hours Worked","Remarks"]]);
  const attData = [
    [new Date("2026-03-01"),"E001","Sabin Silwal","Present",8,""],
    [new Date("2026-03-01"),"E002","Sita Lama","Present",8,""],
    [new Date("2026-03-01"),"E003","Ram Thapa","Present",8,""],
    [new Date("2026-03-01"),"E005","Kiran Shrestha","Present",5,""]
  ];
  att.getRange(2,1,attData.length,attData[0].length).setValues(attData);
  att.getRange("A1:F1").setBackground("#FF5722").setFontColor("white");

  // --- Salary ---
  let sal = ss.insertSheet("Salary");
  sal.getRange("A1:H1").setValues([["Employee ID","Name","Gross Salary","Deductions","Net Salary","Posted","Month","Remarks"]]);
  sal.getRange("A1:H1").setBackground("#9C27B0").setFontColor("white");

  // --- Vouchers ---
  let v = ss.insertSheet("Vouchers");
  v.getRange("A1:I1").setValues([["Date","Voucher No","Type","Debit Account","Credit Account","Amount","VAT","Description","Posted"]]);
  v.getRange("A1:I1").setBackground("#2E7D32").setFontColor("white");
  const voucherData = [
    [new Date("2026-03-01"),"V001","Sales","Cash and Cash Equivalents","Sales Revenue",5000,650,"Product Sale",""],
    [new Date("2026-03-02"),"V002","Purchase","Cost of Sales","Cash and Cash Equivalents",2000,260,"Inventory Purchase",""],
    [new Date("2026-03-03"),"V003","Expense","Operating Expenses","Cash and Cash Equivalents",1000,0,"Office Rent",""],
    [new Date("2026-03-04"),"V004","Sales","Cash and Cash Equivalents","Service Revenue",3000,390,"Consulting",""]
  ];
  v.getRange(2,1,voucherData.length,voucherData[0].length).setValues(voucherData);
  let voucherRule = SpreadsheetApp.newDataValidation().requireValueInList(
    ["Sales","Purchase","Receipt","Payment","Journal","Contra","Credit Note","Debit Note"]
  ).build();
  v.getRange("C2:C200").setDataValidation(voucherRule);

  // --- Journal ---
  let j = ss.insertSheet("Journal");
  j.getRange("A1:G1").setValues([["Date","Account","Debit","Credit","Voucher No","Description","VAT"]]);
  j.getRange("A1:G1").setBackground("#1565C0").setFontColor("white");

  // --- Ledger ---
  let l = ss.insertSheet("Ledger");
  l.getRange("A1:F1").setValues([["Account","Debit Total","Credit Total","Balance","Type","VAT"]]);
  l.getRange("A1:F1").setBackground("#6A1B9A").setFontColor("white");
  l.getRange("A2").setFormula('=FILTER(ChartOfAccounts!B2:B,ChartOfAccounts!B2:B<>"")');
  l.getRange("B2").setFormula('=SUMIF(Journal!B:B,A2,Journal!C:C)');
  l.getRange("C2").setFormula('=SUMIF(Journal!B:B,A2,Journal!D:D)');
  l.getRange("D2").setFormula('=B2-C2');
  l.getRange("E2").setFormula('=VLOOKUP(A2,ChartOfAccounts!B:C,2,false)');
  l.getRange("F2").setFormula('=SUMIF(Journal!B:B,A2,Journal!G:G)');

  // --- Trial Balance ---
  let tb = ss.insertSheet("TrialBalance");
  tb.getRange("A1:D1").setValues([["Account","Debit","Credit","VAT"]]);
  tb.getRange("A1:D1").setBackground("#37474F").setFontColor("white");
  tb.getRange("A2").setFormula('=Ledger!A2');
  tb.getRange("B2").setFormula('=IF(Ledger!D2>0,Ledger!D2,"")');
  tb.getRange("C2").setFormula('=IF(Ledger!D2<0,-Ledger!D2,"")');
  tb.getRange("D2").setFormula('=Ledger!F2');

  // --- Profit & Loss ---
  let pl = ss.insertSheet("ProfitLoss");
  pl.getRange("A1:C1").setValues([["Type","Account","Amount"]]);
  pl.getRange("A1:C1").setBackground("#FF5722").setFontColor("white");

  // --- Balance Sheet ---
  let bs = ss.insertSheet("BalanceSheet");
  bs.getRange("A1:C1").setValues([["Type","Account","Amount"]]);
  bs.getRange("A1:C1").setBackground("#3F51B5").setFontColor("white");

  // --- Day Book ---
  let db = ss.insertSheet("DayBook");
  db.getRange("A1:I1").setValues([["Date","Voucher No","Type","Debit Account","Credit Account","Amount","VAT","Description","Posted"]]);
  db.getRange("A1:I1").setBackground("#009688").setFontColor("white");

  // --- Dashboard formulas ---
  dashboard.getRange("A1").setValue("ACCOUNTING DASHBOARD").setFontWeight("bold").setFontSize(18);
  dashboard.getRange("A3").setValue("Active Employees");
  dashboard.getRange("A4").setValue("Total Sales");
  dashboard.getRange("A5").setValue("Total Expenses");
  dashboard.getRange("A6").setValue("Cash Balance");
  dashboard.getRange("A7").setValue("Total VAT Payable");

  dashboard.getRange("B3").setFormula('=COUNTIF(Employees!F2:F,"Active")');
  dashboard.getRange("B4").setFormula('=SUMIF(Journal!B:B,"Sales Revenue",Journal!D:D)+SUMIF(Journal!B:B,"Service Revenue",Journal!D:D)');
  dashboard.getRange("B5").setFormula('=SUMIF(Journal!E:E,"<>Sales Revenue",Journal!D:D)');
  dashboard.getRange("B6").setFormula('=SUMIF(Journal!B:B,"Cash and Cash Equivalents",Journal!C:C)-SUMIF(Journal!B:B,"Cash and Cash Equivalents",Journal!D:D)');
  dashboard.getRange("B7").setFormula('=SUMIF(Journal!B:B,"Deferred Tax Liabilities",Journal!D:D)');
}

/********************
POST VOUCHERS AUTOMATION
********************/
function postVouchers() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let v = ss.getSheetByName("Vouchers");
  let j = ss.getSheetByName("Journal");
  let db = ss.getSheetByName("DayBook");
  let data = v.getRange("A2:I"+v.getLastRow()).getValues();

  data.forEach((r,i)=>{
    if(r[0] && r[8] != "YES"){
      let date=r[0], vno=r[1], type=r[2], debit=r[3], credit=r[4], amount=r[5], vat=r[6], desc=r[7];

      // Post to Journal
      j.appendRow([date,debit,amount,"",vno,desc,vat]);
      j.appendRow([date,credit,"",amount,vno,desc,0]);

      // Post to Day Book
      db.appendRow([date,vno,type,debit,credit,amount,vat,desc,"YES"]);

      // Mark voucher as posted
      v.getRange(i+2,9).setValue("YES");
    }
  });
}

/********************
SALARY CALCULATION & POSTING
********************/
function postSalaries(month) {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let emp = ss.getSheetByName("Employees");
  let att = ss.getSheetByName("Attendance");
  let sal = ss.getSheetByName("Salary");
  let j = ss.getSheetByName("Journal");

  let empData = emp.getRange("A2:F"+emp.getLastRow()).getValues();

  empData.forEach((e)=>{
    let empID=e[0], name=e[1], type=e[3], rate=e[4], status=e[5];
    if(status=="Active"){
      let gross=0;
      if(type=="Monthly") gross = rate;
      else if(type=="Daily" || type=="Hourly"){
        let attData = att.getRange("A2:F"+att.getLastRow()).getValues();
        attData.forEach(a=>{
          if(a[1]==empID && Utilities.formatDate(a[0],Session.getScriptTimeZone(),"MM-yyyy")==month){
            if(type=="Daily") gross += rate;
            if(type=="Hourly") gross += a[4]*rate;
          }
        });
      }
      let deductions = 0;
      let net = gross - deductions;
      sal.appendRow([empID,name,gross,deductions,net,"",month,""]);
      j.appendRow([new Date(), "5003 – Depreciation / Amortization", gross,"", "SAL_"+empID, "Salary Posting",0]);
      j.appendRow([new Date(), "1001 – Cash and Cash Equivalents", "",gross,"SAL_"+empID,"Salary Payment",0]);
    }
  });
}

/********************
NAVIGATION / TOC
********************/
function createNavigationTOC() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let existing = ss.getSheetByName("Navigation");
  if (existing) ss.deleteSheet(existing);

  let toc = ss.insertSheet("Navigation");
  toc.setTabColor("yellow");
  toc.clear();

  toc.getRange("A1").setValue("ERP Navigation").setFontSize(18).setFontWeight("bold");
  toc.getRange("A2").setValue("Click to go to the module:");

  const modules = [
    "Dashboard","ChartOfAccounts","Vouchers","Journal","DayBook","Ledger",
    "TrialBalance","ProfitLoss","BalanceSheet","Employees","Attendance","Salary"
  ];

  for (let i=0;i<modules.length;i++){
    const sheetName = modules[i];
    toc.getRange(i+4,1).setFormula(`=HYPERLINK("#gid="&SHEETID("${sheetName}"), "${sheetName}")`);
  }
}

function SHEETID(sheetName) {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  return ss.getSheetByName(sheetName).getSheetId();
}

function styleNavigationButtons() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const toc = ss.getSheetByName("Navigation");
  const lastRow = toc.getLastRow();
  for (let i=4;i<=lastRow;i++){
    const cell = toc.getRange(i,1);
    cell.setFontColor("white")
        .setBackground("#1f77b4")
        .setFontWeight("bold")
        .setHorizontalAlignment("center")
        .setVerticalAlignment("middle");
  }
}
