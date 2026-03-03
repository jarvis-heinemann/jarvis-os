// Mission Control - Debug Mode
// Add to app.js to help diagnose blank page

console.log('🚀 Mission Control loading...');

// Check if DOM loaded
document.addEventListener('DOMContentLoaded', () => {
    console.log('✅ DOM loaded');

    // Check localStorage
    try {
        const saved = localStorage.getItem('missionControlState');
        console.log('📦 LocalStorage:', saved ? 'has data' : 'empty');
        if (saved) {
            const data = JSON.parse(saved);
            console.log('📊 Data keys:', Object.keys(data));
        }
    } catch (e) {
        console.error('❌ LocalStorage error:', e);
    }

    // Check if functions exist
    console.log('🔍 Functions check:');
    console.log('  - renderAll:', typeof renderAll);
    console.log('  - setupNavigation:', typeof setupNavigation);
    console.log('  - loadState:', typeof loadState);
});

// Global error handler
window.onerror = (msg, url, lineNo, columnNo, error) => {
    console.error('💥 Global error:', msg, 'at', lineNo, ':', columnNo);
    alert('Error: ' + msg + '\nCheck console for details');
    return false;
};
