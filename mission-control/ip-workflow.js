// ==================== PATENT STATUS WORKFLOW ====================

// Define valid status transitions
const STATUS_WORKFLOW = {
    'draft': ['filed'],
    'filed': ['pending', 'abandoned'],
    'pending': ['granted', 'abandoned'],
    'granted': ['maintained', 'lapsed'],
    'maintained': ['maintained', 'lapsed'],
    'abandoned': [],
    'lapsed': []
};

// Get available next status for a patent
function getNextStatuses(currentStatus) {
    return STATUS_WORKFLOW[currentStatus] || [];
}

// Update patent status with validation
function updatePatentStatus(patentId, newStatus) {
    const patent = ipState.patents.find(p => p.id === patentId);
    if (!patent) {
        alert('Patent not found');
        return false;
    }
    
    const allowed = getNextStatuses(patent.status);
    if (!allowed.includes(newStatus)) {
        alert(`Cannot change from "${patent.status}" to "${newStatus}". Valid transitions: ${allowed.join(', ') || 'none'}`);
        return false;
    }
    
    // Update status
    const oldStatus = patent.status;
    patent.status = newStatus;
    patent.updatedAt = new Date().toISOString();
    
    // Handle status-specific actions
    if (newStatus === 'granted' && !patent.grantDate) {
        patent.grantDate = new Date().toISOString().split('T')[0];
        
        // Add maintenance fee deadlines
        ipState.settings.maintenanceFeeSchedule.forEach((years, idx) => {
            ipState.deadlines.push({
                id: `${patent.id}-maint-${idx}`,
                type: 'maintenance-fee',
                date: addMonths(patent.grantDate, years * 12),
                label: `Maintenance Fee ${idx + 1} Due (${years} years)`,
                patentId: patent.id,
                status: 'pending',
                feeAmount: [2000, 3760, 7850][idx]
            });
        });
    }
    
    saveIPData();
    renderDashboard();
    showNotification(`Status changed: ${oldStatus} → ${newStatus}`);
    return true;
}

// Get workflow visualization for a patent
function getPatentWorkflow(patent) {
    const statuses = ['draft', 'filed', 'pending', 'granted', 'maintained'];
    const currentIndex = statuses.indexOf(patent.status);
    
    return statuses.map((status, index) => {
        let state = 'future';
        if (index < currentIndex) state = 'completed';
        if (index === currentIndex) state = 'current';
        
        // Handle non-linear paths
        if (patent.status === 'abandoned' && index >= currentIndex) state = 'abandoned';
        if ((patent.status === 'lapsed' || patent.status === 'maintained') && index > 3) state = index === 4 ? 'current' : 'future';
        
        return { status, state };
    });
}

// Calculate patent age
function getPatentAge(patent) {
    if (!patent.filingDate) return null;
    
    const filing = new Date(patent.filingDate);
    const now = new Date();
    const years = (now - filing) / (365.25 * 24 * 60 * 60 * 1000);
    
    return {
        years: Math.floor(years),
        months: Math.floor((years % 1) * 12),
        days: Math.floor(((years % 1) * 12 % 1) * 30)
    };
}

// Get patent timeline summary
function getPatentTimeline(patent) {
    const timeline = [];
    
    if (patent.filingDate) {
        timeline.push({
            date: patent.filingDate,
            event: 'Application Filed',
            type: 'milestone'
        });
    }
    
    if (patent.priorityDate) {
        timeline.push({
            date: patent.priorityDate,
            event: 'Priority Date Claimed',
            type: 'milestone'
        });
    }
    
    if (patent.grantDate) {
        timeline.push({
            date: patent.grantDate,
            event: 'Patent Granted',
            type: 'milestone'
        });
    }
    
    // Add calculated deadlines
    if (patent.type === 'provisional' && patent.filingDate && patent.status !== 'abandoned') {
        const contDate = addMonths(patent.filingDate, 12);
        timeline.push({
            date: contDate,
            event: 'Continuation Deadline',
            type: 'deadline'
        });
    }
    
    return timeline.sort((a, b) => new Date(a.date) - new Date(b.date));
}
