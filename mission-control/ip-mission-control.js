// IP Mission Control - Patent Portfolio Manager
// Tracks provisionals, continuations, deadlines, and documentation

// ==================== DATA MODEL ====================

let ipState = {
    patents: [],
    deadlines: [],
    documents: [],
    costs: [], // Cost tracking
    settings: {
        defaultJurisdiction: 'US',
        maintenanceFeeSchedule: [3.5, 7.5, 11.5], // Years after grant
        entityMultipliers: {
            large: 1.0,
            small: 0.5,
            micro: 0.25
        },
        usptoFees: {
            // USPTO fees (2026, micro entity - 25%)
            provisional: 65,
            provisionalLarge: 325,
            utilityBasic: 70,
            utilitySearch: 154,
            utilityExam: 176,
            utilityIssue: 258,
            design: 60,
            designLarge: 300,
            // Maintenance fees (2026)
            maintenance1: 430,    // 3.5 years - micro
            maintenance1Large: 2150,
            maintenance2: 808,    // 7.5 years - micro
            maintenance2Large: 4040,
            maintenance3: 1656,   // 11.5 years - micro
            maintenance3Large: 8280,
            // Other (2026)
            extensionOfTime: 47,
            rce: 300,             // 1st RCE - micro
            rceLarge: 1500,
            rceSecond: 572,       // 2nd RCE - micro
            rceSecondLarge: 2860,
            appeal: 181
        },
        attorneyRates: {
            provisional: 2500,    // Average cost
            utility: 8000,        // Full utility application
            continuation: 4000,
            response: 2500,       // Office action response
            appeal: 10000
        }
    },
    // Sorting
    sortBy: 'updatedAt',
    sortOrder: 'desc'
};

// Sorting functions
function setSortBy(field) {
    if (ipState.sortBy === field) {
        ipState.sortOrder = ipState.sortOrder === 'asc' ? 'desc' : 'asc';
    } else {
        ipState.sortBy = field;
        ipState.sortOrder = 'desc';
    }
    saveIPData();
    renderPatentList();
}

function getSortedPatents(patents) {
    return [...patents].sort((a, b) => {
        let aVal = a[ipState.sortBy];
        let bVal = b[ipState.sortBy];
        
        // Handle dates
        if (ipState.sortBy === 'filingDate' || ipState.sortBy === 'createdAt' || ipState.sortBy === 'updatedAt') {
            aVal = aVal ? new Date(aVal) : new Date(0);
            bVal = bVal ? new Date(bVal) : new Date(0);
        }
        
        // Handle priority (high > medium > low > none)
        const priorityOrder = { 'high': 3, 'medium': 2, 'low': 1, 'none': 0 };
        if (ipState.sortBy === 'priority') {
            aVal = priorityOrder[a.priority] || 0;
            bVal = priorityOrder[b.priority] || 0;
        }
        
        if (aVal < bVal) return ipState.sortOrder === 'asc' ? -1 : 1;
        if (aVal > bVal) return ipState.sortOrder === 'asc' ? 1 : -1;
        return 0;
    });
}

// Load data from localStorage
function loadIPData() {
    const saved = localStorage.getItem('ip-mission-control');
    if (saved) {
        ipState = JSON.parse(saved);
    }
    renderDashboard();
}

// Save data to localStorage
function saveIPData() {
    localStorage.setItem('ip-mission-control', JSON.stringify(ipState));
}

// ==================== PATENT MANAGEMENT ====================

function addPatent(event) {
    event.preventDefault();
    const form = event.target;
    const formData = new FormData(form);

    const patent = {
        id: Date.now().toString(),
        title: formData.get('title'),
        type: formData.get('type'),
        entityType: formData.get('entityType') || 'micro',
        filingDate: formData.get('filingDate'),
        applicationNumber: formData.get('applicationNumber') || null,
        status: formData.get('status'),
        description: formData.get('description') || '',
        inventors: formData.get('inventors') ? formData.get('inventors').split(',').map(i => i.trim()) : [],
        category: formData.get('category') || '',
        priority: formData.get('priority') || 'none',
        notes: formData.get('notes') || '',
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
    };

    // Handle cost tracking
    const filingFee = parseFloat(formData.get('filingFee')) || 0;
    const attorneyFees = parseFloat(formData.get('attorneyFees')) || 0;
    const drawingCosts = parseFloat(formData.get('drawingCosts')) || 0;
    const otherCosts = parseFloat(formData.get('otherCosts')) || 0;

    if (filingFee > 0) addCost(patent.id, 'filing', filingFee, 'Filing fee', patent.filingDate);
    if (attorneyFees > 0) addCost(patent.id, 'attorney', attorneyFees, 'Attorney fees', patent.filingDate);
    if (drawingCosts > 0) addCost(patent.id, 'drawing', drawingCosts, 'Drawing costs', patent.filingDate);
    if (otherCosts > 0) addCost(patent.id, 'other', otherCosts, 'Other costs', patent.filingDate);

    // Calculate deadlines based on type
    if (patent.type === 'provisional') {
        // Provisionals must convert within 12 months
        patent.deadlines = [{
            id: Date.now().toString(),
            type: 'continuation-due',
            date: addMonths(patent.filingDate, 12),
            label: 'Continuation Due (12-month deadline)',
            status: 'pending'
        }];
    }

    ipState.patents.push(patent);
    ipState.deadlines.push(...patent.deadlines || []);

    saveIPData();
    closeModal('add-patent-modal');
    form.reset();
    renderDashboard();
    showNotification('Patent added successfully!');
}

function updatePatent(patentId, updates) {
    const index = ipState.patents.findIndex(p => p.id === patentId);
    if (index !== -1) {
        ipState.patents[index] = {
            ...ipState.patents[index],
            ...updates,
            updatedAt: new Date().toISOString()
        };
        saveIPData();
        renderDashboard();
    }
}

function deletePatent(patentId) {
    if (confirm('Are you sure you want to delete this patent?')) {
        ipState.patents = ipState.patents.filter(p => p.id !== patentId);
        saveIPData();
        renderDashboard();
        showNotification('Patent deleted');
    }
}

// ==================== CONTINUATION PIPELINE ====================

function generateContinuation(provisionalId) {
    const provisional = ipState.patents.find(p => p.id === provisionalId);
    if (!provisional) {
        alert('Provisional not found');
        return;
    }

    if (provisional.type !== 'provisional') {
        alert('Can only generate continuations from provisionals');
        return;
    }

    const continuation = {
        id: Date.now().toString(),
        title: provisional.title + ' - Continuation',
        type: 'continuation',
        parentProvisionalId: provisionalId,
        filingDate: null, // To be filed
        priorityDate: provisional.filingDate, // Claims priority from provisional
        applicationNumber: null,
        status: 'draft',
        description: provisional.description,
        inventors: [...provisional.inventors],
        category: provisional.category,
        claims: provisional.claims || [],
        drawings: provisional.drawings || [],
        specification: provisional.specification || '',
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
    };

    // Calculate deadline (12 months from provisional filing)
    continuation.deadline = addMonths(provisional.filingDate, 12);

    ipState.patents.push(continuation);

    // Add deadline
    ipState.deadlines.push({
        id: Date.now().toString() + '-deadline',
        type: 'continuation-file',
        date: continuation.deadline,
        label: `File Continuation: ${continuation.title}`,
        patentId: continuation.id,
        status: 'pending'
    });

    saveIPData();
    renderDashboard();
    showNotification(`Continuation created for: ${provisional.title}`);
}

// ==================== COST MANAGEMENT ====================

function addCost(patentId, category, amount, description, date) {
    const cost = {
        id: Date.now().toString(),
        patentId: patentId,
        category: category, // 'filing', 'attorney', 'maintenance', 'drawing', 'search', 'office-action', 'other'
        amount: parseFloat(amount),
        description: description,
        date: date || new Date().toISOString().split('T')[0],
        createdAt: new Date().toISOString()
    };

    ipState.costs.push(cost);
    saveIPData();
    return cost;
}

function getPatentCosts(patentId) {
    return ipState.costs.filter(c => c.patentId === patentId);
}

function getTotalPatentCost(patentId) {
    return getPatentCosts(patentId).reduce((sum, c) => sum + c.amount, 0);
}

function getTotalPortfolioCost() {
    return ipState.costs.reduce((sum, c) => sum + c.amount, 0);
}

function getCostsByCategory() {
    const categories = {};
    ipState.costs.forEach(c => {
        if (!categories[c.category]) categories[c.category] = 0;
        categories[c.category] += c.amount;
    });
    return categories;
}

function getUpcomingCosts(days = 365) {
    const now = new Date();
    const futureDate = new Date();
    futureDate.setDate(futureDate.getDate() + days);

    return ipState.deadlines
        .filter(d => {
            const deadlineDate = new Date(d.date);
            return deadlineDate >= now && deadlineDate <= futureDate && d.type === 'maintenance-fee';
        })
        .map(d => ({
            deadline: d,
            estimatedCost: d.feeAmount || ipState.settings.usptoFees.maintenance1
        }));
}

function estimateProvisionalCosts() {
    const fees = ipState.settings.usptoFees;
    const attorney = ipState.settings.attorneyRates;
    return {
        uspto: fees.provisional,
        attorney: attorney.provisional,
        total: fees.provisional + attorney.provisional,
        breakdown: [
            { item: 'USPTO Filing Fee', amount: fees.provisional },
            { item: 'Attorney Fees', amount: attorney.provisional },
            { item: 'Drawings (est.)', amount: 500 }
        ]
    };
}

function estimateUtilityCosts() {
    const fees = ipState.settings.usptoFees;
    const attorney = ipState.settings.attorneyRates;
    return {
        uspto: fees.utilityBasic + fees.utilitySearch + fees.utilityExam + fees.utilityIssue,
        attorney: attorney.utility,
        total: fees.utilityBasic + fees.utilitySearch + fees.utilityExam + fees.utilityIssue + attorney.utility,
        breakdown: [
            { item: 'Basic Filing Fee', amount: fees.utilityBasic },
            { item: 'Search Fee', amount: fees.utilitySearch },
            { item: 'Examination Fee', amount: fees.utilityExam },
            { item: 'Issue Fee', amount: fees.utilityIssue },
            { item: 'Attorney Fees', amount: attorney.utility }
        ]
    };
}

function estimateTotalMaintenanceCosts(patentId) {
    const patent = ipState.patents.find(p => p.id === patentId);
    if (!patent || patent.type !== 'utility' || patent.status !== 'granted') return 0;

    return ipState.settings.usptoFees.maintenance1 +
           ipState.settings.usptoFees.maintenance2 +
           ipState.settings.usteoFees.maintenance3;
}

// ==================== ENTITY-BASED COST CALCULATIONS ====================

// Get entity multiplier
function getEntityMultiplier(entityType) {
    return ipState.settings.entityMultipliers[entityType] || 1.0;
}

// Calculate USPTO fee based on entity type
function getUSPTOFee(feeType, entityType = 'large') {
    const multiplier = getEntityMultiplier(entityType);
    const fees = ipState.settings.usptoFees;
    return (fees[feeType] || 0) * multiplier;
}

// Get estimated cost for a patent based on its entity type
function getEstimatedCost(patent) {
    const entity = patent.entityType || 'micro';
    const mult = getEntityMultiplier(entity);
    const fees = ipState.settings.usptoFees;
    const attorney = ipState.settings.attorneyRates;
    
    let cost = { uspto: 0, attorney: 0, total: 0 };
    
    if (patent.type === 'provisional') {
        cost.uspto = fees.provisional * mult;
        cost.attorney = attorney.provisional * mult;
    } else if (patent.type === 'utility' || patent.type === 'continuation') {
        cost.uspto = (fees.utilityBasic + fees.utilitySearch + fees.utilityExam + fees.utilityIssue) * mult;
        cost.attorney = (patent.type === 'continuation' ? attorney.continuation : attorney.utility) * mult;
    } else if (patent.type === 'design') {
        cost.uspto = fees.design * mult;
        cost.attorney = attorney.provisional * mult;
    }
    
    cost.total = cost.uspto + cost.attorney;
    return cost;
}

function getPortfolioCostSummary() {
    const total = getTotalPortfolioCost();
    const byCategory = getCostsByCategory();
    const provisionals = ipState.patents.filter(p => p.type === 'provisional');
    const utilities = ipState.patents.filter(p => p.type === 'utility' || p.type === 'continuation');
    const granted = ipState.patents.filter(p => p.status === 'granted');

    // Estimate future costs
    const pendingMaintenance = getUpcomingCosts(365).reduce((sum, c) => sum + c.estimatedCost, 0);
    const pendingContinuations = provisionals.filter(p => p.status === 'filed').length * ipState.settings.attorneyRates.continuation;

    return {
        spent: total,
        byCategory: byCategory,
        projections: {
            nextYearMaintenance: pendingMaintenance,
            pendingContinuations: pendingContinuations,
            totalProjected: pendingMaintenance + pendingContinuations
        },
        average: {
            perProvisional: provisionals.length > 0 ? total / provisionals.length : 0,
            perUtility: utilities.length > 0 ? total / utilities.length : 0
        },
        counts: {
            provisionals: provisionals.length,
            utilities: utilities.length,
            granted: granted.length
        }
    };
}

// ==================== DOCUMENT MANAGEMENT ====================

function addDocument(patentId, docType, content) {
    const doc = {
        id: Date.now().toString(),
        patentId: patentId,
        type: docType, // 'claims', 'drawings', 'specification', 'oath', 'assignment'
        content: content,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
    };

    ipState.documents.push(doc);
    saveIPData();
    return doc;
}

function getDocuments(patentId) {
    return ipState.documents.filter(d => d.patentId === patentId);
}

// ==================== USPTO TEMPLATE GENERATOR ====================

function generateUSPTOTemplate(patentId, templateType) {
    const patent = ipState.patents.find(p => p.id === patentId);
    if (!patent) return null;

    const templates = {
        'provisional-cover': generateProvisionalCoverSheet(patent),
        'specification': generateSpecification(patent),
        'claims': generateClaims(patent),
        'oath': generateOath(patent),
        'assignment': generateAssignment(patent)
    };

    return templates[templateType] || null;
}

function generateProvisionalCoverSheet(patent) {
    return `
USPTO PROVISIONAL APPLICATION COVER SHEET
==========================================

Title: ${patent.title}
Inventors: ${patent.inventors.join(', ')}
Filing Date: ${patent.filingDate || '[TO BE FILED]'}

Residence of Inventors:
${patent.inventors.map(i => `${i}: United States`).join('\n')}

Correspondence Address:
[Your Address Here]
[City, State ZIP]

Entity Status: [ ] Large | [ ] Small | [ ] Micro

Application Data:
- Drawing Sheets: [NUMBER]
- Pages of Specification: [NUMBER]
- Pages of Claims: [NUMBER]

Express Mail Label: [IF APPLICABLE]

Enclosed:
[ ] Specification
[ ] Drawings
[ ] Fee Transmittal
[ ] Assignment (optional)

Signature: _________________________
Date: _________________________
    `.trim();
}

function generateSpecification(patent) {
    return `
SPECIFICATION
=============

TITLE: ${patent.title}

CROSS-REFERENCE TO RELATED APPLICATIONS
---------------------------------------
${patent.priorityDate ? `This application claims priority to U.S. Provisional Application No. [PROVISIONAL NUMBER], filed ${patent.priorityDate}.` : 'Not Applicable'}

BACKGROUND OF THE INVENTION
---------------------------
Field of the Invention:
[Describe the technical field]

Description of Related Art:
[Describe prior art and problems solved]

SUMMARY OF THE INVENTION
------------------------
[Describe the invention and its advantages]

BRIEF DESCRIPTION OF THE DRAWINGS
---------------------------------
[Reference each drawing figure]

DETAILED DESCRIPTION OF THE INVENTION
-------------------------------------
[Detailed description of embodiments]

EXAMPLES
--------
[Optional: specific examples]

EQUIVALENTS
-----------
The invention may be embodied in other specific forms without departing from the spirit or essential characteristics thereof.
    `.trim();
}

function generateClaims(patent) {
    return `
CLAIMS
======

What is claimed is:

1. [Independent Claim 1 - Broadest claim]
   A method/composition/apparatus for [FUNCTION], comprising:
   [ELEMENT A];
   [ELEMENT B]; and
   [ELEMENT C].

2. The method/composition/apparatus of claim 1, wherein [DEPENDENT CLAIM FEATURE].

3. The method/composition/apparatus of claim 1, wherein [DEPENDENT CLAIM FEATURE].

[Continue for 10-20 claims with mix of independent and dependent claims]
    `.trim();
}

function generateOath(patent) {
    return `
OATH OR DECLARATION
===================

I, ${patent.inventors[0] || '[INVENTOR NAME]'}, declare:

1. I am the original inventor of the invention titled "${patent.title}" described in the attached application.

2. I hereby declare that all statements made herein of my own knowledge are true and that all statements made on information and belief are believed to be true.

3. I acknowledge that any willful false statement made in this declaration is punishable under 18 U.S.C. 1001 by fine or imprisonment of not more than five (5) years, or both.

Signature: _________________________
Date: _________________________
Printed Name: ${patent.inventors[0] || '[INVENTOR NAME]'}
Residence: [ADDRESS], United States
    `.trim();
}

function generateAssignment(patent) {
    return `
PATENT ASSIGNMENT
=================

ASSIGNMENT OF RIGHTS

FOR GOOD AND VALUABLE CONSIDERATION, the receipt of which is hereby acknowledged, ${patent.inventors[0] || '[INVENTOR NAME]'} ("Assignor") hereby assigns to [ASSIGNEE NAME] ("Assignee") all right, title, and interest in:

Invention: ${patent.title}
Application No.: ${patent.applicationNumber || '[PENDING]'}
Filing Date: ${patent.filingDate || '[PENDING]'}

Assignor warrants:
- Assignor is the sole inventor
- Assignor has full right to assign
- The invention is free of encumbrances

ASSIGNOR:
Signature: _________________________
Date: _________________________
Name: ${patent.inventors[0] || '[INVENTOR NAME]'}

ASSIGNEE:
Signature: _________________________
Date: _________________________
Name: [ASSIGNEE NAME]

Notary: _________________________
    `.trim();
}

// ==================== EXPORT FUNCTIONS ====================

function exportPatentToPDF(patentId) {
    const patent = ipState.patents.find(p => p.id === patentId);
    if (!patent) return;

    // Generate all templates
    const cover = generateUSPTOTemplate(patentId, 'provisional-cover');
    const spec = generateUSPTOTemplate(patentId, 'specification');
    const claims = generateUSPTOTemplate(patentId, 'claims');
    const oath = generateUSPTOTemplate(patentId, 'oath');

    // Combine into one document
    const fullDoc = `${cover}\n\n${'='.repeat(50)}\n\n${spec}\n\n${'='.repeat(50)}\n\n${claims}\n\n${'='.repeat(50)}\n\n${oath}`;

    // Download as text file (could be enhanced to PDF)
    const blob = new Blob([fullDoc], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${patent.title.replace(/[^a-z0-9]/gi, '_')}_USPTO_Templates.txt`;
    a.click();
    URL.revokeObjectURL(url);
}

// ==================== DEADLINE CALCULATIONS ====================

function addMonths(dateStr, months) {
    const date = new Date(dateStr);
    date.setMonth(date.getMonth() + months);
    return date.toISOString().split('T')[0];
}

function calculateAllDeadlines() {
    const deadlines = [];

    ipState.patents.forEach(patent => {
        // Provisional: 12-month continuation deadline
        if (patent.type === 'provisional' && patent.filingDate) {
            deadlines.push({
                id: `${patent.id}-cont`,
                date: addMonths(patent.filingDate, 12),
                type: 'continuation-due',
                label: `Continuation Due: ${patent.title}`,
                patentId: patent.id,
                status: 'pending'
            });
        }

        // Utility patent: Maintenance fees (3.5, 7.5, 11.5 years)
        if (patent.type === 'utility' && patent.status === 'granted' && patent.grantDate) {
            ipState.settings.maintenanceFeeSchedule.forEach((year, idx) => {
                deadlines.push({
                    id: `${patent.id}-maint-${idx}`,
                    date: addMonths(patent.grantDate, year * 12),
                    type: 'maintenance-fee',
                    label: `Maintenance Fee ${idx + 1} Due (${year}y): ${patent.title}`,
                    patentId: patent.id,
                    status: 'pending',
                    feeAmount: [2000, 3760, 7850][idx] // Approximate USPTO fees (large entity)
                });
            });
        }

        // Office action response (3 months from office action date)
        if (patent.officeActionDate && patent.status === 'pending') {
            deadlines.push({
                id: `${patent.id}-oa`,
                date: addMonths(patent.officeActionDate, 3),
                type: 'office-action',
                label: `Office Action Response Due: ${patent.title}`,
                patentId: patent.id,
                status: 'pending'
            });
        }
    });

    return deadlines;
}

function getUpcomingDeadlines(days = 90) {
    const now = new Date();
    const futureDate = new Date();
    futureDate.setDate(futureDate.getDate() + days);

    return ipState.deadlines
        .filter(d => {
            const deadlineDate = new Date(d.date);
            return deadlineDate >= now && deadlineDate <= futureDate;
        })
        .sort((a, b) => new Date(a.date) - new Date(b.date));
}

function getDaysUntil(dateStr) {
    const date = new Date(dateStr);
    const now = new Date();
    const diff = Math.ceil((date - now) / (1000 * 60 * 60 * 24));
    return diff;
}

// ==================== RENDERING ====================

function renderDashboard() {
    renderStats();
    renderDeadlines();
    renderAlerts();
    renderPatentList();
    renderProvisionals();
    renderContinuations();
    renderCostAnalytics();
    renderWorkflow();
    renderCharts();
    renderSearchBar();
    renderQuickAddButtons();
}

function renderCostAnalytics() {
    const summary = getPortfolioCostSummary();

    // Update main stats
    document.getElementById('total-invested').textContent = '$' + summary.spent.toLocaleString();
    document.getElementById('avg-cost').textContent = '$' + Math.round(summary.average.perProvisional || 0).toLocaleString();
    document.getElementById('projected-costs').textContent = '$' + summary.projections.totalProjected.toLocaleString();

    // Estimate portfolio value (rough estimate: 3-5x investment for granted patents)
    const grantedValue = summary.counts.granted * 50000; // $50k per granted patent
    const pendingValue = (summary.counts.provisionals + summary.counts.utilities) * 15000; // $15k per pending
    document.getElementById('portfolio-value').textContent = '$' + (grantedValue + pendingValue).toLocaleString();

    // Render costs by category
    const categoryContainer = document.getElementById('costs-by-category');
    const categories = summary.byCategory;

    if (Object.keys(categories).length === 0) {
        categoryContainer.innerHTML = '<div class="timeline-item"><div class="timeline-content"><div class="timeline-event">No costs recorded yet</div></div></div>';
    } else {
        const categoryLabels = {
            'filing': 'Filing Fees',
            'attorney': 'Attorney Fees',
            'maintenance': 'Maintenance Fees',
            'drawing': 'Drawings',
            'search': 'Search/Analysis',
            'office-action': 'Office Actions',
            'other': 'Other'
        };

        categoryContainer.innerHTML = Object.entries(categories)
            .sort((a, b) => b[1] - a[1])
            .map(([cat, amount]) => `
                <div class="timeline-item">
                    <div class="timeline-content" style="display: flex; justify-content: space-between;">
                        <div class="timeline-event">${categoryLabels[cat] || cat}</div>
                        <div style="font-weight: bold;">$${amount.toLocaleString()}</div>
                    </div>
                </div>
            `).join('');
    }

    // Render upcoming costs
    const upcomingContainer = document.getElementById('upcoming-costs');
    const upcoming = getUpcomingCosts(365);

    if (upcoming.length === 0) {
        upcomingContainer.innerHTML = '<div class="timeline-item"><div class="timeline-content"><div class="timeline-event">No upcoming costs</div></div></div>';
    } else {
        upcomingContainer.innerHTML = upcoming.slice(0, 5).map(c => `
            <div class="timeline-item">
                <div class="timeline-date">${formatDate(c.deadline.date)}</div>
                <div class="timeline-content" style="display: flex; justify-content: space-between;">
                    <div class="timeline-event">${c.deadline.label}</div>
                    <div style="color: var(--accent-red); font-weight: bold;">$${c.estimatedCost.toLocaleString()}</div>
                </div>
            </div>
        `).join('');
    }
}

function renderStats() {
    const total = ipState.patents.length;
    const provisionals = ipState.patents.filter(p => p.type === 'provisional').length;
    const continuations = ipState.patents.filter(p => p.type === 'continuation' && p.status === 'pending').length;
    const granted = ipState.patents.filter(p => p.status === 'granted').length;
    const highPriority = ipState.patents.filter(p => p.priority === 'high').length;

    document.getElementById('total-patents').textContent = total;
    document.getElementById('provisionals-count').textContent = provisionals;
    document.getElementById('continuations-count').textContent = continuations;
    document.getElementById('granted-count').textContent = granted;
    
    // Add high priority count if element exists
    const hpEl = document.getElementById('high-priority-count');
    if (hpEl) hpEl.textContent = highPriority;
}

function renderDeadlines() {
    const container = document.getElementById('deadlines-list');
    const deadlines = getUpcomingDeadlines(90);

    if (deadlines.length === 0) {
        container.innerHTML = '<div class="timeline-item"><div class="timeline-content"><div class="timeline-event">No upcoming deadlines</div></div></div>';
        return;
    }

    container.innerHTML = deadlines.slice(0, 5).map(d => {
        const days = getDaysUntil(d.date);
        const urgencyClass = days <= 30 ? 'deadline-urgent' : days <= 60 ? 'deadline-warning' : '';

        return `
            <div class="timeline-item">
                <div class="timeline-date ${urgencyClass}">${formatDate(d.date)} (${days} days)</div>
                <div class="timeline-content">
                    <div class="timeline-event">${d.label}</div>
                </div>
            </div>
        `;
    }).join('');
}

function renderAlerts() {
    const alertsContainer = document.getElementById('alerts-list');
    if (!alertsContainer) return;
    
    // Try to get alerts from ip-alerts.js if loaded
    let alerts = [];
    if (typeof getAlerts === 'function') {
        alerts = getAlerts();
    }
    
    if (alerts.length === 0) {
        alertsContainer.innerHTML = '<div class="timeline-item"><div class="timeline-content"><div class="timeline-event" style="color: var(--accent-green);">✓ No urgent deadlines in next 90 days</div></div></div>';
        return;
    }

    alertsContainer.innerHTML = alerts.slice(0, 5).map(a => {
        const color = a.urgency === 'critical' ? 'var(--accent-red)' : a.urgency === 'warning' ? 'var(--accent-yellow)' : 'var(--accent-blue)';
        
        return `
            <div class="timeline-item">
                <div class="timeline-date" style="color: ${color}; font-weight: bold;">${a.daysRemaining}d</div>
                <div class="timeline-content">
                    <div class="timeline-event">${a.title}</div>
                    <div class="timeline-desc">${a.message}</div>
                </div>
            </div>
        `;
    }).join('');
}

function renderPatentList() {
    const container = document.getElementById('patent-list');
    let patents = filterPatents(ipState.patents);
    patents = getSortedPatents(patents);

    if (patents.length === 0) {
        container.innerHTML = '<p style="color: var(--text-secondary);">No patents yet. Click "Add Patent" to get started.</p>';
        return;
    }

    const priorityLabels = { 'high': '🔴', 'medium': '🟡', 'low': '🔵', 'none': '⚪' };

    container.innerHTML = patents.slice(0, 50).map(p => {
        const totalCost = getTotalPatentCost(p.id);
        const priorityLabel = priorityLabels[p.priority] || '⚪';

        return `
            <div class="patent-card" onclick="viewPatentDetail('${p.id}')" style="cursor: pointer;">
                <div class="patent-info">
                    <div class="patent-title">${priorityLabel} ${p.title}</div>
                    <div class="patent-meta">
                        <span>Filed: ${p.filingDate ? formatDate(p.filingDate) : 'Not filed'}</span>
                        <span>Type: ${p.type}</span>
                        ${p.applicationNumber ? `<span>${p.applicationNumber}</span>` : ''}
                        ${totalCost > 0 ? `<span style="color: var(--accent-yellow);">Cost: $${totalCost.toLocaleString()}</span>` : ''}
                    </div>
                </div>
                <div style="display: flex; align-items: center; gap: 8px;">
                    <select class="form-input" style="width: auto; padding: 4px 8px; font-size: 12px;" onchange="quickUpdateStatus('${p.id}', this.value); event.stopPropagation();">
                        <option value="draft" ${p.status === 'draft' ? 'selected' : ''}>Draft</option>
                        <option value="filed" ${p.status === 'filed' ? 'selected' : ''}>Filed</option>
                        <option value="pending" ${p.status === 'pending' ? 'selected' : ''}>Pending</option>
                        <option value="granted" ${p.status === 'granted' ? 'selected' : ''}>Granted</option>
                        <option value="abandoned" ${p.status === 'abandoned' ? 'selected' : ''}>Abandoned</option>
                    </select>
                    <span class="patent-status status-${p.status}">${p.status}</span>
                    <button class="btn btn-secondary" style="padding: 4px 8px; font-size: 12px;" onclick="event.stopPropagation(); deletePatent('${p.id}')" title="Delete">🗑️</button>
                </div>
            </div>
        `;
    }).join('');
}

function viewPatentDetail(id) {
    window.location.href = 'ip-patent-detail.html?id=' + id;
}

function quickUpdateStatus(patentId, newStatus) {
    const patent = ipState.patents.find(p => p.id === patentId);
    if (!patent) return;
    
    patent.status = newStatus;
    if (newStatus === 'granted' && !patent.grantDate) {
        patent.grantDate = new Date().toISOString().split('T')[0];
    }
    patent.updatedAt = new Date().toISOString();
    saveIPData();
    renderPatentList();
    showNotification(`Status updated to ${newStatus}`);
}

function deletePatent(patentId) {
    if (!confirm('Are you sure you want to delete this patent?')) return;
    
    ipState.patents = ipState.patents.filter(p => p.id !== patentId);
    ipState.deadlines = ipState.deadlines.filter(d => d.patentId !== patentId);
    saveIPData();
    renderDashboard();
    showNotification('Patent deleted');
}

function renderProvisionals() {
    const container = document.getElementById('provisionals-list');
    const provisionals = ipState.patents.filter(p => p.type === 'provisional');

    if (provisionals.length === 0) {
        container.innerHTML = '<p style="color: var(--text-secondary);">No provisional applications yet.</p>';
        return;
    }

    container.innerHTML = provisionals.map(p => {
        const daysUntil = p.filingDate ? getDaysUntil(addMonths(p.filingDate, 12)) : null;
        const deadlineClass = daysUntil !== null && daysUntil <= 30 ? 'deadline-urgent' : '';
        const hasContinuation = ipState.patents.some(cont => cont.parentProvisionalId === p.id);

        return `
            <div class="patent-card">
                <div class="patent-info">
                    <div class="patent-title">${p.title}</div>
                    <div class="patent-meta">
                        <span>Filed: ${p.filingDate ? formatDate(p.filingDate) : 'Not filed'}</span>
                        ${daysUntil !== null ? `<span class="${deadlineClass}">Continuation due in ${daysUntil} days</span>` : ''}
                        ${hasContinuation ? '<span style="color: var(--accent-green);">✓ Continuation created</span>' : ''}
                    </div>
                </div>
                <div style="display: flex; gap: 8px;">
                    <span class="patent-status status-provisional">${p.status}</span>
                    ${!hasContinuation && p.status === 'filed' ? `<button class="btn btn-primary" onclick="generateContinuation('${p.id}')" style="font-size: 12px;">Create Continuation</button>` : ''}
                    <button class="btn btn-secondary" onclick="viewPatent('${p.id}')" style="font-size: 12px;">View</button>
                </div>
            </div>
        `;
    }).join('');
}

function renderContinuations() {
    const container = document.getElementById('continuations-list');
    const continuations = ipState.patents.filter(p => p.type === 'continuation' || p.type === 'utility');

    if (continuations.length === 0) {
        container.innerHTML = '<p style="color: var(--text-secondary);">No continuations or utility patents yet.</p>';
        return;
    }

    container.innerHTML = continuations.map(p => `
        <div class="patent-card">
            <div class="patent-info">
                <div class="patent-title">${p.title}</div>
                <div class="patent-meta">
                    <span>Filed: ${p.filingDate ? formatDate(p.filingDate) : 'Not filed'}</span>
                    <span>Type: ${p.type}</span>
                    ${p.applicationNumber ? `<span>${p.applicationNumber}</span>` : ''}
                </div>
            </div>
            <span class="patent-status status-${p.status === 'granted' ? 'granted' : p.status === 'pending' ? 'pending' : 'continuation'}">${p.status}</span>
        </div>
    `).join('');
}

// ==================== UI HELPERS ====================

function formatDate(dateStr) {
    if (!dateStr) return '';
    const date = new Date(dateStr);
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
}

function showNotification(message) {
    // Simple notification - could be enhanced
    alert(message);
}

function showAddPatentModal() {
    document.getElementById('add-patent-modal').classList.add('active');
}

function closeModal(modalId) {
    document.getElementById(modalId).classList.remove('active');
}

// Quick-add templates for common patent types
const patentTemplates = {
    'software': { type: 'utility', category: 'Software', description: 'Software invention covering...' },
    'mobile-app': { type: 'utility', category: 'Mobile App', description: 'Mobile application invention...' },
    'hardware': { type: 'utility', category: 'Hardware', description: 'Electronic hardware device...' },
    'business-method': { type: 'utility', category: 'Business Method', description: 'Business method invention...' },
    'ai-ml': { type: 'utility', category: 'AI/ML', description: 'Artificial intelligence or machine learning invention...' },
    'iot': { type: 'utility', category: 'IoT', description: 'Internet of Things device/system...' },
    'blockchain': { type: 'utility', category: 'Blockchain', description: 'Blockchain-based invention...' },
    'design': { type: 'design', category: 'Industrial Design', description: 'Ornamental design for...' },
    'provisional-quick': { type: 'provisional', category: 'General', description: 'Provisional application for...' }
};

function quickAddPatent(templateKey) {
    const template = patentTemplates[templateKey];
    if (!template) return;
    
    const patent = {
        id: Date.now().toString(),
        title: template.description.replace('...', '').replace('invention', 'invention - ' + new Date().toLocaleDateString()),
        type: template.type,
        entityType: 'micro',
        filingDate: null,
        applicationNumber: null,
        status: 'draft',
        description: template.description,
        inventors: [],
        category: template.category,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
    };
    
    ipState.patents.push(patent);
    saveIPData();
    renderDashboard();
    showNotification(`Added ${template.category} patent template`);
}

function renderQuickAddButtons() {
    const container = document.getElementById('quick-add-buttons');
    if (!container) return;
    
    container.innerHTML = `
        <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 16px;">
            <button class="btn btn-secondary" onclick="quickAddPatent('software')" title="Software Patent">💻 Software</button>
            <button class="btn btn-secondary" onclick="quickAddPatent('mobile-app')" title="Mobile App">📱 Mobile App</button>
            <button class="btn btn-secondary" onclick="quickAddPatent('hardware')" title="Hardware">⚡ Hardware</button>
            <button class="btn btn-secondary" onclick="quickAddPatent('business-method')" title="Business Method">📊 Business Method</button>
            <button class="btn btn-secondary" onclick="quickAddPatent('ai-ml')" title="AI/ML">🤖 AI/ML</button>
            <button class="btn btn-secondary" onclick="quickAddPatent('iot')" title="IoT">🌐 IoT</button>
            <button class="btn btn-secondary" onclick="quickAddPatent('blockchain')" title="Blockchain">🔗 Blockchain</button>
            <button class="btn btn-secondary" onclick="quickAddPatent('design')" title="Design Patent">🎨 Design</button>
            <button class="btn btn-secondary" onclick="quickAddPatent('provisional-quick')" title="Quick Provisional">📝 Provisional</button>
        </div>
    `;
}

function viewPatent(patentId) {
    const patent = ipState.patents.find(p => p.id === patentId);
    if (patent) {
        alert(`Patent Details:\n\nTitle: ${patent.title}\nType: ${patent.type}\nStatus: ${patent.status}\nFiled: ${patent.filingDate || 'Not filed'}\n\n${patent.description || ''}`);
    }
}

function exportPortfolio() {
    const data = JSON.stringify(ipState, null, 2);
    const blob = new Blob([data], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `ip-portfolio-${new Date().toISOString().split('T')[0]}.json`;
    a.click();
    URL.revokeObjectURL(url);
}

function exportPortfolioJSON() {
    exportPortfolio();
}

// ==================== SEARCH & FILTER ====================

let ipSearchState = {
    query: '',
    typeFilter: 'all',
    statusFilter: 'all',
    categoryFilter: 'all',
    priorityFilter: 'all'
};

function filterPatents(patents) {
    let filtered = [...patents];
    
    if (ipSearchState.query) {
        const q = ipSearchState.query.toLowerCase();
        filtered = filtered.filter(p => 
            (p.title && p.title.toLowerCase().includes(q)) ||
            (p.description && p.description.toLowerCase().includes(q)) ||
            (p.category && p.category.toLowerCase().includes(q)) ||
            (p.inventors && p.inventors.some(i => i.toLowerCase().includes(q))) ||
            (p.applicationNumber && p.applicationNumber.toLowerCase().includes(q))
        );
    }
    
    if (ipSearchState.typeFilter !== 'all') {
        filtered = filtered.filter(p => p.type === ipSearchState.typeFilter);
    }
    
    if (ipSearchState.statusFilter !== 'all') {
        filtered = filtered.filter(p => p.status === ipSearchState.statusFilter);
    }
    
    if (ipSearchState.categoryFilter !== 'all') {
        filtered = filtered.filter(p => p.category === ipSearchState.categoryFilter);
    }
    
    if (ipSearchState.priorityFilter !== 'all') {
        filtered = filtered.filter(p => p.priority === ipSearchState.priorityFilter);
    }
    
    return filtered;
}

function getUniqueCategories() {
    const cats = new Set();
    ipState.patents.forEach(p => { if (p.category) cats.add(p.category); });
    return Array.from(cats).sort();
}

function renderSearchBar() {
    const container = document.getElementById('search-filters');
    if (!container) return;
    
    const categories = getUniqueCategories();
    
    container.innerHTML = `
        <div style="display: flex; gap: 12px; flex-wrap: wrap; align-items: center;">
            <input type="text" class="form-input" style="flex: 1; min-width: 200px;" placeholder="Search patents..." value="${ipSearchState.query}" onkeyup="handleSearchInput(this.value)">
            <select class="form-input" style="width: auto;" onchange="handleTypeFilter(this.value)">
                <option value="all" ${ipSearchState.typeFilter === 'all' ? 'selected' : ''}>All Types</option>
                <option value="provisional" ${ipSearchState.typeFilter === 'provisional' ? 'selected' : ''}>Provisional</option>
                <option value="utility" ${ipSearchState.typeFilter === 'utility' ? 'selected' : ''}>Utility</option>
                <option value="continuation" ${ipSearchState.typeFilter === 'continuation' ? 'selected' : ''}>Continuation</option>
                <option value="design" ${ipSearchState.typeFilter === 'design' ? 'selected' : ''}>Design</option>
            </select>
            <select class="form-input" style="width: auto;" onchange="handleStatusFilter(this.value)">
                <option value="all" ${ipSearchState.statusFilter === 'all' ? 'selected' : ''}>All Status</option>
                <option value="draft" ${ipSearchState.statusFilter === 'draft' ? 'selected' : ''}>Draft</option>
                <option value="filed" ${ipSearchState.statusFilter === 'filed' ? 'selected' : ''}>Filed</option>
                <option value="pending" ${ipSearchState.statusFilter === 'pending' ? 'selected' : ''}>Pending</option>
                <option value="granted" ${ipSearchState.statusFilter === 'granted' ? 'selected' : ''}>Granted</option>
                <option value="abandoned" ${ipSearchState.statusFilter === 'abandoned' ? 'selected' : ''}>Abandoned</option>
            </select>
            <select class="form-input" style="width: auto;" onchange="handlePriorityFilter(this.value)">
                <option value="all" ${ipSearchState.priorityFilter === 'all' ? 'selected' : ''}>All Priority</option>
                <option value="high" ${ipSearchState.priorityFilter === 'high' ? 'selected' : ''}>🔴 High</option>
                <option value="medium" ${ipSearchState.priorityFilter === 'medium' ? 'selected' : ''}>🟡 Medium</option>
                <option value="low" ${ipSearchState.priorityFilter === 'low' ? 'selected' : ''}>🔵 Low</option>
                <option value="none" ${ipSearchState.priorityFilter === 'none' ? 'selected' : ''}>⚪ None</option>
            </select>
            ${categories.length > 0 ? `<select class="form-input" style="width: auto;" onchange="handleCategoryFilter(this.value)"><option value="all">All Categories</option>${categories.map(c => `<option value="${c}">${c}</option>`).join('')}</select>` : ''}
            ${(ipSearchState.query || ipSearchState.typeFilter !== 'all' || ipSearchState.statusFilter !== 'all' || ipSearchState.categoryFilter !== 'all' || ipSearchState.priorityFilter !== 'all') ? `<button class="btn btn-secondary" onclick="clearSearchFilters()">✕ Clear</button>` : ''}
        </div>
        <div style="margin-top: 8px; font-size: 13px; color: var(--text-secondary);">Showing ${filterPatents(ipState.patents).length} of ${ipState.patents.length} patents</div>
    `;
}

function handleSearchInput(value) { ipSearchState.query = value; renderSearchBar(); renderPatentList(); }
function handleTypeFilter(value) { ipSearchState.typeFilter = value; renderSearchBar(); renderPatentList(); }
function handleStatusFilter(value) { ipSearchState.statusFilter = value; renderSearchBar(); renderPatentList(); }
function handleCategoryFilter(value) { ipSearchState.categoryFilter = value; renderSearchBar(); renderPatentList(); }
function handlePriorityFilter(value) { ipSearchState.priorityFilter = value; renderSearchBar(); renderPatentList(); }
function clearSearchFilters() { ipSearchState = { query: '', typeFilter: 'all', statusFilter: 'all', categoryFilter: 'all', priorityFilter: 'all' }; renderSearchBar(); renderPatentList(); }

// ==================== NAVIGATION ====================

document.querySelectorAll('.nav-item').forEach(item => {
    item.addEventListener('click', function() {
        // Remove active class from all items
        document.querySelectorAll('.nav-item').forEach(i => i.classList.remove('active'));
        document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));

        // Add active class to clicked item
        this.classList.add('active');

        // Show corresponding panel
        const panelId = this.dataset.panel + '-panel';
        document.getElementById(panelId).classList.add('active');
    });
});

// ==================== WORKFLOW PANEL ====================

function renderWorkflow() {
    const counts = {
        draft: ipState.patents.filter(p => p.status === 'draft').length,
        filed: ipState.patents.filter(p => p.status === 'filed').length,
        pending: ipState.patents.filter(p => p.status === 'pending').length,
        granted: ipState.patents.filter(p => p.status === 'granted' || p.status === 'maintained').length
    };
    
    const el = id => document.getElementById(id);
    if (el('workflow-draft')) el('workflow-draft').textContent = counts.draft;
    if (el('workflow-filed')) el('workflow-filed').textContent = counts.filed;
    if (el('workflow-pending')) el('workflow-pending').textContent = counts.pending;
    if (el('workflow-granted')) el('workflow-granted').textContent = counts.granted;
    
    const container = el('workflow-patent-list');
    if (!container) return;
    
    if (ipState.patents.length === 0) {
        container.innerHTML = '<p style="color: var(--text-secondary);">No patents yet.</p>';
        return;
    }
    
    const grouped = {};
    ipState.patents.forEach(p => {
        if (!grouped[p.status]) grouped[p.status] = [];
        grouped[p.status].push(p);
    });
    
    container.innerHTML = Object.entries(grouped).map(([status, patents]) => `
        <div style="margin-bottom: 24px;">
            <h4 style="text-transform: uppercase; color: var(--text-secondary); margin-bottom: 12px;">${status} (${patents.length})</h4>
            ${patents.map(p => `
                <div class="patent-card">
                    <div class="patent-info">
                        <div class="patent-title">${p.title}</div>
                        <div class="patent-meta">
                            <span>Type: ${p.type}</span>
                            <span>Filed: ${p.filingDate || 'N/A'}</span>
                        </div>
                    </div>
                    <select class="form-input" style="width: auto;" onchange="updatePatentStatus('${p.id}', this.value)">
                        <option value="draft" ${p.status === 'draft' ? 'selected' : ''}>Draft</option>
                        <option value="filed" ${p.status === 'filed' ? 'selected' : ''}>Filed</option>
                        <option value="pending" ${p.status === 'pending' ? 'selected' : ''}>Pending</option>
                        <option value="granted" ${p.status === 'granted' ? 'selected' : ''}>Granted</option>
                        <option value="abandoned" ${p.status === 'abandoned' ? 'selected' : ''}>Abandoned</option>
                    </select>
                </div>
            `).join('')}
        </div>
    `).join('');
}

function updatePatentStatus(patentId, newStatus) {
    const patent = ipState.patents.find(p => p.id === patentId);
    if (!patent) return;
    
    const valid = {
        'draft': ['filed'], 'filed': ['pending', 'abandoned'],
        'pending': ['granted', 'abandoned'], 'granted': ['maintained', 'lapsed']
    };
    
    if (!valid[patent.status]?.includes(newStatus) && newStatus !== patent.status) {
        alert(`Cannot transition from ${patent.status} to ${newStatus}`);
        renderWorkflow();
        return;
    }
    
    patent.status = newStatus;
    if (newStatus === 'granted' && !patent.grantDate) {
        patent.grantDate = new Date().toISOString().split('T')[0];
    }
    saveIPData();
    renderDashboard();
    showNotification(`Status: ${patent.status}`);
}

// ==================== CHARTS & VISUALIZATIONS ====================

function renderCharts() {
    renderStatusChart();
    renderCostChart();
    renderTimelineChart();
}

function renderStatusChart() {
    const container = document.getElementById('status-chart');
    if (!container) return;
    
    const counts = {
        'draft': ipState.patents.filter(p => p.status === 'draft').length,
        'filed': ipState.patents.filter(p => p.status === 'filed').length,
        'pending': ipState.patents.filter(p => p.status === 'pending').length,
        'granted': ipState.patents.filter(p => p.status === 'granted' || p.status === 'maintained').length,
        'abandoned': ipState.patents.filter(p => p.status === 'abandoned').length
    };
    
    const total = Object.values(counts).reduce((a, b) => a + b, 0);
    if (total === 0) {
        container.innerHTML = '<p style="color: var(--text-secondary);">No patents to chart</p>';
        return;
    }
    
    const colors = {
        'draft': '#6b7280',
        'filed': '#3b82f6',
        'pending': '#f59e0b',
        'granted': '#10b981',
        'abandoned': '#ef4444'
    };
    
    container.innerHTML = `
        <div style="display: flex; gap: 8px; height: 200px; align-items: flex-end;">
            ${Object.entries(counts).map(([status, count]) => {
                const pct = total > 0 ? (count / total * 100) : 0;
                return `
                    <div style="flex: 1; display: flex; flex-direction: column; align-items: center; height: 100%;">
                        <div style="flex: 1; display: flex; align-items: flex-end; width: 100%;">
                            <div style="width: 100%; background: ${colors[status]}; border-radius: 4px 4px 0 0; height: ${pct}%; min-height: ${count > 0 ? '20px' : '0'}; transition: height 0.3s;"></div>
                        </div>
                        <div style="font-size: 11px; color: var(--text-secondary); margin-top: 8px; text-transform: uppercase;">${status}</div>
                        <div style="font-size: 14px; font-weight: bold;">${count}</div>
                    </div>
                `;
            }).join('')}
        </div>
    `;
}

function renderCostChart() {
    const container = document.getElementById('cost-chart');
    if (!container) return;
    
    const summary = getPortfolioCostSummary();
    const categories = summary.byCategory;
    
    if (Object.keys(categories).length === 0) {
        container.innerHTML = '<p style="color: var(--text-secondary);">No costs recorded</p>';
        return;
    }
    
    const maxAmount = Math.max(...Object.values(categories));
    const colors = ['#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#ec4899', '#6b7280'];
    
    container.innerHTML = `
        <div style="display: flex; flex-direction: column; gap: 12px;">
            ${Object.entries(categories).sort((a, b) => b[1] - a[1]).map(([cat, amount], i) => {
                const pct = maxAmount > 0 ? (amount / maxAmount * 100) : 0;
                const labels = { 'filing': 'Filing Fees', 'attorney': 'Attorney', 'maintenance': 'Maintenance', 'drawing': 'Drawings', 'search': 'Search', 'office-action': 'Office Actions', 'other': 'Other' };
                return `
                    <div>
                        <div style="display: flex; justify-content: space-between; font-size: 13px; margin-bottom: 4px;">
                            <span>${labels[cat] || cat}</span>
                            <span style="font-weight: bold;">$${amount.toLocaleString()}</span>
                        </div>
                        <div style="background: var(--bg-secondary); height: 24px; border-radius: 4px; overflow: hidden;">
                            <div style="background: ${colors[i % colors.length]}; height: 100%; width: ${pct}%; border-radius: 4px;"></div>
                        </div>
                    </div>
                `;
            }).join('')}
        </div>
    `;
}

function renderTimelineChart() {
    const container = document.getElementById('timeline-chart');
    if (!container) return;
    
    const filed = ipState.patents.filter(p => p.filingDate).sort((a, b) => new Date(a.filingDate) - new Date(b.filingDate));
    
    if (filed.length === 0) {
        container.innerHTML = '<p style="color: var(--text-secondary);">No filing dates recorded</p>';
        return;
    }
    
    const months = {};
    filed.forEach(p => {
        const month = p.filingDate.substring(0, 7); // YYYY-MM
        months[month] = (months[month] || 0) + 1;
    });
    
    const sortedMonths = Object.keys(months).sort().slice(-12); // Last 12 months
    const maxCount = Math.max(...Object.values(months));
    
    container.innerHTML = `
        <div style="display: flex; gap: 4px; height: 150px; align-items: flex-end;">
            ${sortedMonths.map(month => {
                const count = months[month];
                const pct = maxCount > 0 ? (count / maxCount * 100) : 0;
                return `
                    <div style="flex: 1; display: flex; flex-direction: column; align-items: center; height: 100%;">
                        <div style="flex: 1; display: flex; align-items: flex-end; width: 100%;">
                            <div style="width: 100%; background: var(--accent-blue); border-radius: 4px 4px 0 0; height: ${pct}%; min-height: ${count > 0 ? '16px' : '0'};"></div>
                        </div>
                        <div style="font-size: 10px; color: var(--text-secondary); margin-top: 4px; transform: rotate(-45deg); white-space: nowrap;">${month}</div>
                    </div>
                `;
            }).join('')}
        </div>
    `;
}

// ==================== INITIALIZATION ====================

document.addEventListener('DOMContentLoaded', () => {
    loadIPData();
});
