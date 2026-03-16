function seedFullAccountingApp() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  if (!ss) return;

  function getOrCreateSheet(name) {
    let sheet = ss.getSheetByName(name);
    if (!sheet) sheet = ss.insertSheet(name);
    sheet.clear();
    return sheet;
  }

  // ------------------------
  // 1️⃣ Ledger Groups
  // ------------------------
  const lgSheet = getOrCreateSheet("Ledger Groups");
  lgSheet.appendRow(["Ledger Group", "Type / Description"]);
  const ledgerGroups = [
    ["Capital Account", "Owner’s capital / equity"],
    ["Reserves & Surplus", "Retained earnings / reserves"],
    ["Secured Loans", "Bank loan with security"],
    ["Unsecured Loans", "Loan without collateral"],
    ["Current Liabilities", "Short-term liabilities / payables"],
    ["Overdraft (OD) Accounts", "Bank OD / short-term borrowing"],
    ["Cash-in-Hand", "Cash available in office / petty cash"],
    ["Bank Accounts", "Bank savings / current accounts"],
    ["Sundry Debtors", "Accounts Receivable (Customers)"],
    ["Sundry Creditors", "Accounts Payable (Suppliers)"],
    ["Fixed Assets", "Land, Building, Machinery, Vehicles"],
    ["Investments", "Long-term investments / shares / bonds"],
    ["Stock-in-Hand", "Inventory, raw material, finished goods"],
    ["Direct Expenses", "COGS, raw materials, freight inwards"],
    ["Indirect Expenses", "Salary, Rent, Utilities, Office Expenses"],
    ["Direct Income", "Sales Revenue / Service Revenue"],
    ["Indirect Income", "Interest Income / Commission / Discounts"]
  ];
  ledgerGroups.forEach(r => lgSheet.appendRow(r));

  // ------------------------
  // 2️⃣ Ledgers
  // ------------------------
  const ledgerSheet = getOrCreateSheet("Ledgers");
  ledgerSheet.appendRow(["Ledger Name", "Group", "Opening Balance", "Type (Dr/Cr)", "Running Balance"]);
  const ledgers = [
    ["Cash", "Cash-in-Hand", 50000, "Dr", 50000],
    ["Bank Account", "Bank Accounts", 100000, "Dr", 100000],
    ["Capital – Owner", "Capital Account", 200000, "Cr", -200000],
    ["Sales Revenue", "Direct Income", 0, "Cr", 0],
    ["Purchase – Supplier", "Direct Expenses", 0, "Dr", 0],
    ["Salary Expense", "Indirect Expenses", 0, "Dr", 0],
    ["Rent Expense", "Indirect Expenses", 0, "Dr", 0],
    ["Sundry Debtors – Customer A", "Sundry Debtors", 0, "Dr", 0],
    ["Sundry Creditors – Supplier X", "Sundry Creditors", 0, "Cr", 0],
    ["Loan from Bank", "Secured Loans", 0, "Cr", 0],
    ["OD – Bank", "Overdraft (OD) Accounts", 0, "Cr", 0]
  ];
  ledgers.forEach(r => ledgerSheet.appendRow(r));

  // ------------------------
  // 3️⃣ Voucher Types
  // ------------------------
  const vtSheet = getOrCreateSheet("Voucher Types");
  vtSheet.appendRow(["Voucher Type", "Description"]);
  const vouchers = [
    ["Payment", "Record payment made (cash/bank)"],
    ["Receipt", "Record money received (cash/bank)"],
    ["Contra", "Cash/Bank transfers"],
    ["Journal", "Non-cash adjustments / accruals"],
    ["Sales", "Credit or cash sales"],
    ["Purchase", "Credit or cash purchases"],
    ["Debit Note", "Purchase returns"],
    ["Credit Note", "Sales returns"],
    ["Stock Journal", "Stock transfers / adjustments"],
    ["Delivery Note", "Goods delivered to customers"],
    ["Receipt Note", "Goods received from suppliers"],
    ["Payroll", "Salary / Wages / Deductions"]
  ];
  vouchers.forEach(r => vtSheet.appendRow(r));

  // ------------------------
  // 4️⃣ Transactions / Vouchers
  // ------------------------
  const vSheet = getOrCreateSheet("Vouchers");
  vSheet.appendRow(["Date", "Voucher Type", "Ledger Debit", "Amount (Dr)", "Ledger Credit", "Amount (Cr)", "Narration"]);

  const sampleVouchers = [
    ["01/01/2026", "Receipt", "Cash", 50000, "Capital – Owner", 50000, "Owner invested cash"],
    ["02/01/2026", "Purchase", "Purchase – Supplier", 20000, "Bank Account", 20000, "Bought raw materials"],
    ["05/01/2026", "Payment", "Salary Expense", 10000, "Bank Account", 10000, "Paid salaries"],
    ["06/01/2026", "Sales", "Sundry Debtors – Customer A", 30000, "Sales Revenue", 30000, "Credit sale to Customer A"],
    ["07/01/2026", "Payment", "Rent Expense", 5000, "Cash", 5000, "Paid office rent"]
  ];
  sampleVouchers.forEach(r => vSheet.appendRow(r));

  // ------------------------
  // 5️⃣ Auto-post vouchers into Ledger running balance
  // ------------------------
  const ledgerData = ledgerSheet.getDataRange().getValues();
  const ledgerMap = {};
  for (let i = 1; i < ledgerData.length; i++) {
    const name = ledgerData[i][0];
    ledgerMap[name] = { row: i + 1, balance: Number(ledgerData[i][4]) }; // row in sheet, running balance
  }

  const voucherData = vSheet.getDataRange().getValues();
  for (let i = 1; i < voucherData.length; i++) {
    const debitLedger = voucherData[i][2];
    const debitAmt = Number(voucherData[i][3]);
    const creditLedger = voucherData[i][4];
    const creditAmt = Number(voucherData[i][5]);

    // Update Debit Ledger
    if (ledgerMap[debitLedger]) {
      ledgerMap[debitLedger].balance += debitAmt;
      ledgerSheet.getRange(ledgerMap[debitLedger].row, 5).setValue(ledgerMap[debitLedger].balance);
    }

    // Update Credit Ledger
    if (ledgerMap[creditLedger]) {
      ledgerMap[creditLedger].balance -= creditAmt; // credit reduces Dr balance
      ledgerSheet.getRange(ledgerMap[creditLedger].row, 5).setValue(ledgerMap[creditLedger].balance);
    }
  }

  // ------------------------
  // 6️⃣ Trial Balance
  // ------------------------
  const tbSheet = getOrCreateSheet("Trial Balance");
  tbSheet.appendRow(["Ledger Name", "Debit", "Credit"]);
  Object.keys(ledgerMap).forEach(name => {
    const bal = ledgerMap[name].balance;
    if (bal > 0) tbSheet.appendRow([name, bal, ""]);
    else if (bal < 0) tbSheet.appendRow([name, "", -bal]);
    else tbSheet.appendRow([name, "", ""]);
  });

  // ------------------------
  // 7️⃣ Balance Sheet & P&L placeholders
  // ------------------------
  const bsSheet = getOrCreateSheet("Balance Sheet");
  bsSheet.appendRow(["Assets", "Amount", "Liabilities & Equity", "Amount"]);
  const plSheet = getOrCreateSheet("Profit & Loss");
  plSheet.appendRow(["Income / Revenue", "Amount", "Expenses", "Amount"]);

  // Completion message
  const infoSheet = getOrCreateSheet("Info");
  infoSheet.appendRow(["✅ Full accounting application seeded successfully!"]);
}
