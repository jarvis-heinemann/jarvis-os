// Mission Control v2 - Enhanced Features

// ==================== GITHUB INTEGRATION ====================

// Scan workspace for git repos (would need backend/server for full implementation)
// For now, we'll manage repo data manually with future API integration

let repoData = [];

function scanForRepos() {
    // In a full implementation, this would scan the filesystem
    // For now, return mock data structure
    return [
        {
            name: 'mission-control',
            path: '~/.openclaw/workspace/mission-control',
            status: 'active',
            lastCommit: Date.now() - 3600000,
            branch: 'main',
            dirty: false
        }
    ];
}

function addRepo() {
    const name = prompt('Repository name:');
    if (!name) return;
    
    const repo = {
        id: Date.now(),
        name: name,
        path: prompt('Path (e.g., ~/projects/my-repo):') || '',
        status: 'active',
        lastCommit: null,
        branch: 'main',
        dirty: false,
        linkedProject: null,
        addedAt: Date.now()
    };
    
    state.repos = state.repos || [];
    state.repos.push(repo);
    saveState();
    renderRepos();
}

function renderRepos() {
    const container = document.getElementById('repos-grid');
    if (!container) return;
    
    state.repos = state.repos || [];
    
    if (state.repos.length === 0) {
        container.innerHTML = '<p style="color: var(--text-muted); text-align: center; padding: 40px; grid-column: 1/-1;">No repos tracked. Click "+ Add Repo" to link a repository.</p>';
        return;
    }
    
    container.innerHTML = state.repos.map(repo => {
        const lastCommitText = repo.lastCommit 
            ? `${Math.floor((Date.now() - repo.lastCommit) / 3600000)}h ago`
            : 'Never';
        
        return `
            <div class="repo-card">
                <h4>${repo.name}</h4>
                <div class="repo-meta">
                    <span class="repo-status ${repo.status}">${repo.status}</span>
                    <span class="repo-branch">📂 ${repo.branch}</span>
                </div>
                <div class="repo-info">
                    <p>Last commit: ${lastCommitText}</p>
                    <p>${repo.path}</p>
                </div>
                <div class="repo-actions">
                    <button class="btn-small" onclick="linkRepoToProject(${repo.id})">Link to Project</button>
                    <button class="btn-small" onclick="removeRepo(${repo.id})">Remove</button>
                </div>
            </div>
        `;
    }).join('');
}

function linkRepoToProject(repoId) {
    const repo = state.repos.find(r => r.id === repoId);
    if (!repo) return;
    
    const projectNames = state.projects.map(p => p.name).join(', ');
    const projectName = prompt(`Link to project (${projectNames}):`);
    
    if (projectName) {
        const project = state.projects.find(p => p.name.toLowerCase() === projectName.toLowerCase());
        if (project) {
            repo.linkedProject = project.id;
            saveState();
            renderRepos();
        } else {
            alert('Project not found');
        }
    }
}

function removeRepo(repoId) {
    if (!confirm('Remove this repo from tracking?')) return;
    state.repos = state.repos.filter(r => r.id !== repoId);
    saveState();
    renderRepos();
}

// ==================== DOMAIN PORTFOLIO ====================

function addDomain() {
    const domain = prompt('Domain name (e.g., example.com):');
    if (!domain) return;
    
    const domainEntry = {
        id: Date.now(),
        domain: domain.toLowerCase(),
        status: prompt('Status (active/parked/for-sale/in-use):') || 'parked',
        project: prompt('Related project (optional):') || '',
        registrar: prompt('Registrar (optional):') || '',
        acquiredDate: Date.now(),
        renewalDate: null,
        price: 0,
        valueEstimate: 0,
        notes: ''
    };
    
    state.domains = state.domains || [];
    state.domains.push(domainEntry);
    saveState();
    renderDomains();
    updateDomainStats();
}

function renderDomains() {
    const container = document.getElementById('domains-list');
    if (!container) return;
    
    state.domains = state.domains || [];
    
    if (state.domains.length === 0) {
        container.innerHTML = '<p style="color: var(--text-muted); text-align: center; padding: 40px;">No domains tracked yet.</p>';
        return;
    }
    
    container.innerHTML = state.domains.map(d => `
        <div class="domain-item status-${d.status}">
            <div class="domain-name">${d.domain}</div>
            <div class="domain-meta">
                <span class="domain-status">${d.status}</span>
                ${d.project ? `<span class="domain-project">${d.project}</span>` : ''}
            </div>
            <button class="btn-small" onclick="editDomain(${d.id})">Edit</button>
        </div>
    `).join('');
}

function editDomain(domainId) {
    const domain = state.domains.find(d => d.id === domainId);
    if (!domain) return;
    
    const notes = prompt('Notes:', domain.notes);
    if (notes !== null) {
        domain.notes = notes;
        saveState();
        renderDomains();
    }
}

function updateDomainStats() {
    state.domains = state.domains || [];
    
    const stats = {
        total: state.domains.length,
        active: state.domains.filter(d => d.status === 'active' || d.status === 'in-use').length,
        parked: state.domains.filter(d => d.status === 'parked').length,
        forSale: state.domains.filter(d => d.status === 'for-sale').length
    };
    
    const statsEl = document.getElementById('domain-stats');
    if (statsEl) {
        statsEl.innerHTML = `
            <div class="stat"><strong>${stats.total}</strong> Total</div>
            <div class="stat"><strong>${stats.active}</strong> Active</div>
            <div class="stat"><strong>${stats.parked}</strong> Parked</div>
            <div class="stat"><strong>${stats.forSale}</strong> For Sale</div>
        `;
    }
}

function filterDomains(status) {
    // Toggle filter buttons
    document.querySelectorAll('.domain-filter-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    event.target.classList.add('active');
    
    const container = document.getElementById('domains-list');
    state.domains = state.domains || [];
    
    const filtered = status === 'all' 
        ? state.domains 
        : state.domains.filter(d => d.status === status);
    
    container.innerHTML = filtered.map(d => `
        <div class="domain-item status-${d.status}">
            <div class="domain-name">${d.domain}</div>
            <div class="domain-meta">
                <span class="domain-status">${d.status}</span>
                ${d.project ? `<span class="domain-project">${d.project}</span>` : ''}
            </div>
            <button class="btn-small" onclick="editDomain(${d.id})">Edit</button>
        </div>
    `).join('');
}

// ==================== AGENT REGISTRY ====================

function addAgent() {
    const name = prompt('Agent name:');
    if (!name) return;
    
    const agent = {
        id: Date.now(),
        name: name,
        type: prompt('Type (research/content/ops/monitor/integration):') || 'ops',
        status: prompt('Status (active/inactive/dev):') || 'active',
        project: prompt('Related project (optional):') || '',
        description: '',
        lastRun: null,
        runsCount: 0,
        created: Date.now()
    };
    
    state.agents = state.agents || [];
    state.agents.push(agent);
    saveState();
    renderAgents();
}

function renderAgents() {
    const container = document.getElementById('agents-list');
    if (!container) return;
    
    state.agents = state.agents || [];
    
    if (state.agents.length === 0) {
        container.innerHTML = '<p style="color: var(--text-muted); text-align: center; padding: 40px;">No agents registered yet.</p>';
        return;
    }
    
    container.innerHTML = state.agents.map(a => `
        <div class="agent-card status-${a.status}">
            <div class="agent-header">
                <h4>${a.name}</h4>
                <span class="agent-status ${a.status}">${a.status}</span>
            </div>
            <div class="agent-meta">
                <span class="agent-type">${a.type}</span>
                ${a.project ? `<span class="agent-project">${a.project}</span>` : ''}
            </div>
            <p class="agent-runs">Runs: ${a.runsCount}</p>
        </div>
    `).join('');
}

// ==================== EXPORT/IMPORT ====================

function exportData() {
    const data = JSON.stringify(state, null, 2);
    const blob = new Blob([data], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    
    const a = document.createElement('a');
    a.href = url;
    a.download = `mission-control-backup-${new Date().toISOString().split('T')[0]}.json`;
    a.click();
    
    URL.revokeObjectURL(url);
}

function importData() {
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = '.json';
    
    input.onchange = (e) => {
        const file = e.target.files[0];
        const reader = new FileReader();
        
        reader.onload = (event) => {
            try {
                const imported = JSON.parse(event.target.result);
                if (confirm('This will replace all current data. Continue?')) {
                    state = imported;
                    saveState();
                    renderAll();
                    alert('Data imported successfully!');
                }
            } catch (err) {
                alert('Invalid backup file');
            }
        };
        
        reader.readAsText(file);
    };
    
    input.click();
}

// ==================== SEARCH ====================

function initSearch() {
    const searchInput = document.getElementById('global-search');
    if (!searchInput) return;
    
    searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        if (query.length < 2) return;
        
        // Search ideas
        const ideaResults = state.ideas.filter(i => 
            i.text.toLowerCase().includes(query)
        );
        
        // Search projects
        const projectResults = state.projects.filter(p =>
            p.name.toLowerCase().includes(query)
        );
        
        // Show results
        console.log('Search results:', { ideas: ideaResults, projects: projectResults });
    });
}

// ==================== PRIORITY DECAY ====================

function calculateDecay(timestamp) {
    const age = Date.now() - timestamp;
    const days = age / (1000 * 60 * 60 * 24);
    
    // Decay formula: priority decreases by 5% per day
    const decay = Math.max(0, 1 - (days * 0.05));
    return decay;
}

function getDecayedPriority(item) {
    const baseScore = item.score || 5;
    const decay = calculateDecay(item.timestamp || item.createdAt || Date.now());
    return (baseScore * decay).toFixed(1);
}

// ==================== KEYBOARD SHORTCUTS ====================

document.addEventListener('keydown', (e) => {
    // Cmd/Ctrl + K = Focus search
    if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
        e.preventDefault();
        const searchInput = document.getElementById('global-search');
        if (searchInput) searchInput.focus();
    }
    
    // Cmd/Ctrl + N = New idea
    if ((e.metaKey || e.ctrlKey) && e.key === 'n') {
        e.preventDefault();
        const ideaInput = document.getElementById('idea-input');
        if (ideaInput) ideaInput.focus();
    }
    
    // Cmd/Ctrl + 1-8 = Switch panels
    if ((e.metaKey || e.ctrlKey) && e.key >= '1' && e.key <= '8') {
        e.preventDefault();
        const panels = ['focus', 'ideas', 'projects', 'delegation', 'automation', 'metrics', 'library', 'vision'];
        const panelIndex = parseInt(e.key) - 1;
        const navItem = document.querySelector(`[data-panel="${panels[panelIndex]}"]`);
        if (navItem) navItem.click();
    }
});

// Initialize v2 features on load
document.addEventListener('DOMContentLoaded', () => {
    // Add renderAll call for new features
    const originalRenderAll = window.renderAll;
    window.renderAll = function() {
        if (originalRenderAll) originalRenderAll();
        renderRepos();
        renderDomains();
        renderAgents();
        updateDomainStats();
        initSearch();
    };
    
    // Run initial renders
    setTimeout(() => {
        renderRepos();
        renderDomains();
        renderAgents();
        updateDomainStats();
    }, 100);
});
