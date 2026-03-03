// Import patents from CSV format
// Usage: Call importFromCSV(csvString) with CSV data

function importFromCSV(csvString) {
    const lines = csvString.trim().split('\n');
    const headers = lines[0].split(',').map(h => h.trim().toLowerCase());

    const patents = [];

    for (let i = 1; i < lines.length; i++) {
        const values = lines[i].split(',').map(v => v.trim());
        const patent = {};

        headers.forEach((header, idx) => {
            const value = values[idx] || '';

            switch (header) {
                case 'title':
                    patent.title = value;
                    break;
                case 'type':
                    patent.type = value.toLowerCase();
                    break;
                case 'filing date':
                case 'filingdate':
                    patent.filingDate = value;
                    break;
                case 'application number':
                case 'applicationnumber':
                    patent.applicationNumber = value;
                    break;
                case 'status':
                    patent.status = value.toLowerCase();
                    break;
                case 'inventors':
                    patent.inventors = value.split(';').map(i => i.trim());
                    break;
                case 'category':
                    patent.category = value;
                    break;
                case 'priority':
                    patent.priority = value.toLowerCase();
                    break;
                case 'description':
                    patent.description = value;
                    break;
                case 'filing fee':
                case 'filingfee':
                    patent.filingFee = parseFloat(value) || 0;
                    break;
                case 'attorney fees':
                case 'attorneyfees':
                    patent.attorneyFees = parseFloat(value) || 0;
                    break;
                case 'drawing costs':
                case 'drawingcosts':
                    patent.drawingCosts = parseFloat(value) || 0;
                    break;
                case 'other costs':
                case 'othercosts':
                    patent.otherCosts = parseFloat(value) || 0;
                    break;
            }
        });

        if (patent.title) {
            patent.id = Date.now().toString() + '-' + i;
            patent.createdAt = new Date().toISOString();
            patent.updatedAt = new Date().toISOString();
            patents.push(patent);
        }
    }

    // Add to state
    patents.forEach(p => {
        ipState.patents.push(p);

        // Add costs
        if (p.filingFee > 0) addCost(p.id, 'filing', p.filingFee, 'Filing fee', p.filingDate);
        if (p.attorneyFees > 0) addCost(p.id, 'attorney', p.attorneyFees, 'Attorney fees', p.filingDate);
        if (p.drawingCosts > 0) addCost(p.id, 'drawing', p.drawingCosts, 'Drawing costs', p.filingDate);
        if (p.otherCosts > 0) addCost(p.id, 'other', p.otherCosts, 'Other costs', p.filingDate);
    });

    // Recalculate deadlines
    ipState.deadlines = calculateAllDeadlines();

    saveIPData();
    renderDashboard();

    return patents.length;
}

// Example CSV format:
/*
Title,Type,Filing Date,Application Number,Status,Inventors,Category,Priority,Description,Filing Fee,Attorney Fees
My Invention 1,provisional,2025-06-15,63/123456,filed,Gabriel Heinemann,Technology,high,Description here,280,2500
My Invention 2,utility,2024-01-20,17/234567,granted,Gabriel Heinemann;Co-Inventor,Software,medium,Description here,4580,8000
*/

// Bulk import function
function showImportModal() {
    const csv = prompt('Paste CSV data:\n\nFormat: Title,Type,Filing Date,Application Number,Status,Inventors,Category,Priority,Description\n\nInventors separated by semicolons (;)');
    if (csv) {
        const count = importFromCSV(csv);
        alert(`Imported ${count} patents successfully!`);
    }
}

// Quick add for single patent
function quickAddPatent(title, type, filingDate, status) {
    const patent = {
        id: Date.now().toString(),
        title: title,
        type: type || 'provisional',
        filingDate: filingDate || null,
        applicationNumber: null,
        status: status || 'draft',
        description: '',
        inventors: ['Gabriel Heinemann'],
        category: '',
        priority: 'medium',
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
    };

    ipState.patents.push(patent);
    ipState.deadlines = calculateAllDeadlines();
    saveIPData();
    renderDashboard();

    return patent;
}

// Export instructions
function showImportInstructions() {
    alert(`
CSV Import Format
=================

Required columns:
- Title (patent title)
- Type (provisional, continuation, utility, design)

Optional columns:
- Filing Date (YYYY-MM-DD)
- Application Number
- Status (draft, filed, pending, granted, abandoned)
- Inventors (separate multiple with semicolons ;)
- Category
- Priority (low, medium, high)
- Description

Cost columns (optional):
- Filing Fee (USPTO fees)
- Attorney Fees
- Drawing Costs
- Other Costs

Example:
Title,Type,Filing Date,Application Number,Status,Inventors,Filing Fee,Attorney Fees
My Invention,provisional,2025-06-15,63/123456,filed,Gabriel Heinemann,280,2500

Copy your CSV data and use the Import button.
    `.trim());
}
