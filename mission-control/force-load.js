// Mission Control - Force Load Domains
// Run this in browser console if domains don't appear

async function forceLoadDomains() {
    console.log('🔄 Loading domains from data.json...');

    try {
        // Fetch data.json
        const response = await fetch('data.json');
        const data = await response.json();

        console.log('✅ Data loaded:', data);
        console.log('📊 Domains:', data.domains?.length);
        console.log('📊 Repos:', data.repos?.length);

        // Save to localStorage
        localStorage.setItem('missionControlState', JSON.stringify(data));
        console.log('✅ Saved to localStorage');

        // Reload page
        console.log('🔄 Reloading page...');
        location.reload();

    } catch (error) {
        console.error('❌ Error:', error);
    }
}

// Run it
forceLoadDomains();
