// ==================== ALERT SYSTEM ====================

// Generate alert data notifications
function getAlerts() {
    const alerts = [];
    const now = new Date();
    
    ipState.patents.forEach(patent => {
        if (!patent.filingDate) return;
        
        // Continuation deadline (12 months for provisional)
        if (patent.type === 'provisional' && patent.status === 'filed') {
            const contDate = addMonths(patent.filingDate, 12);
            const daysUntil = getDaysUntil(contDate);
            
            if (daysUntil <= 90) {
                alerts.push({
                    id: `${patent.id}-continuation`,
                    patentId: patent.id,
                    title: patent.title,
                    type: 'continuation',
                    urgency: daysUntil <= 30 ? 'critical' : daysUntil <= 60 ? 'warning' : 'info',
                    daysRemaining: daysUntil,
                    date: contDate,
                    message: `Continuation due in ${daysUntil} days`,
                    action: 'File continuation application'
                });
            }
        }
        
        // Maintenance fees (for granted utility patents)
        if (patent.type === 'utility' && patent.status === 'granted' && patent.grantDate) {
            ipState.settings.maintenanceFeeSchedule.forEach((years, idx) => {
                const feeDate = addMonths(patent.grantDate, years * 12);
                const daysUntil = getDaysUntil(feeDate);
                
                if (daysUntil > 0 && daysUntil <= 90) {
                    alerts.push({
                        id: `${patent.id}-maintenance-${idx}`,
                        patentId: patent.id,
                        title: patent.title,
                        type: 'maintenance',
                        urgency: daysUntil <= 30 ? 'critical' : daysUntil <= 60 ? 'warning' : 'info',
                        daysRemaining: daysUntil,
                        date: feeDate,
                        message: `Maintenance fee ${idx + 1} (${years} years) due in ${daysUntil} days`,
                        action: 'Pay maintenance fee',
                        estimatedCost: [2000, 3760, 7850][idx]
                    });
                }
            });
        }
    });
    
    return alerts.sort((a, b) => a.daysRemaining - b.daysRemaining);
}

// Format alert for display
function formatAlert(alert) {
    const urgencyColors = {
        critical: '#ef4444',
        warning: '#f59e0b',
        info: '#3b82f6'
    };
    
    return {
        ...alert,
        color: urgencyColors[alert.urgency]
    };
}

// Get alert summary for dashboard
function getAlertSummary() {
    const alerts = getAlerts();
    return {
        total: alerts.length,
        critical: alerts.filter(a => a.urgency === 'critical').length,
        warning: alerts.filter(a => a.urgency === 'warning').length,
        info: alerts.filter(a => a.urgency === 'info').length,
        nextAlert: alerts[0] || null
    };
}

// Check if any alerts need immediate attention
function hasUrgentAlerts() {
    const alerts = getAlerts();
    return alerts.some(a => a.urgency === 'critical' || a.urgency === 'warning');
}

// Generate email-ready alert report
function generateAlertReport() {
    const alerts = getAlerts();
    const summary = getAlertSummary();
    
    let report = `IP PORTFOLIO ALERT REPORT
Generated: ${new Date().toLocaleDateString()}

SUMMARY
=======
Total Alerts: ${summary.total}
Critical: ${summary.critical}
Warning: ${summary.warning}
Info: ${summary.info}

`;
    
    if (alerts.length === 0) {
        report += 'No upcoming deadlines in the next 90 days.';
    } else {
        report += 'UPCOMING DEADLINES\n';
        report += '==================\n\n';
        
        alerts.forEach(alert => {
            report += `[${alert.urgency.toUpperCase()}] ${alert.title}\n`;
            report += `  ${alert.message}\n`;
            if (alert.estimatedCost) {
                report += `  Estimated Cost: $${alert.estimatedCost.toLocaleString()}\n`;
            }
            report += `  Action: ${alert.action}\n`;
            report += '\n';
        });
    }
    
    return report;
}
