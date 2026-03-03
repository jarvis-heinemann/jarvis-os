// Mission Control Application Logic

// State Management
let state = {
    flagship: null,
    ideas: [],
    projects: [],
    tasks: [],
    currentIdea: null,
    energy: [],
    repos: [],
    domains: [],
    agents: [],
    activeSeed: null,
    todayTask: null,
    completed: []
};

// Load state from localStorage
function loadState() {
    const saved = localStorage.getItem('missionControlState');
    if (saved) {
        state = JSON.parse(saved);
        renderAll();
    }
}

// Save state to localStorage
function saveState() {
    localStorage.setItem('missionControlState', JSON.stringify(state));
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    console.log('🚀 Mission Control initializing...');

    // Load data from localStorage OR data.json
    loadState();

    // If no data, try loading from data.json
    if (!state.domains || state.domains.length === 0) {
        console.log('⚠️ No domains in localStorage, loading from data.json...');
        fetch('data.json')
            .then(r => r.json())
            .then(data => {
                state = data;
                saveState();
                console.log('✅ Loaded', data.domains?.length, 'domains from data.json');
                renderAll();
            })
            .catch(e => console.error('❌ Error loading data.json:', e));
    }

    setupNavigation();
    setupFlagshipSelection();
    setupEnergyTracker();
});

// Navigation
function setupNavigation() {
    const navItems = document.querySelectorAll('.nav-item');
    
    navItems.forEach(item => {
        item.addEventListener('click', () => {
            // Update active nav
            navItems.forEach(i => i.classList.remove('active'));
            item.classList.add('active');
            
            // Show corresponding panel
            const panelId = item.dataset.panel;
            document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
            document.getElementById(`${panelId}-panel`).classList.add('active');
        });
    });
}

// Flagship Selection
function setupFlagshipSelection() {
    const buttons = document.querySelectorAll('.flagship-btn');
    
    buttons.forEach(btn => {
        btn.addEventListener('click', () => {
            state.flagship = btn.dataset.flagship;
            saveState();
            renderFlagship();
            
            // Highlight selected
            buttons.forEach(b => b.classList.remove('selected'));
            btn.classList.add('selected');
        });
    });
    
    renderFlagship();
}

function renderFlagship() {
    const nameEl = document.getElementById('flagship-name');
    const contentEl = document.getElementById('flagship-content');
    
    if (state.flagship) {
        nameEl.textContent = state.flagship;
        contentEl.innerHTML = `
            <div class="flagship-selected">
                <h3 style="color: var(--accent); margin-bottom: 12px;">${state.flagship}</h3>
                <p style="font-size: 13px; color: var(--text-secondary);">
                    This is your gravitational center. All other projects orbit this flagship.
                </p>
                <button class="btn-small" onclick="clearFlagship()" style="margin-top: 12px;">Change Flagship</button>
            </div>
        `;
    } else {
        nameEl.textContent = 'Not Selected';
    }
}

function clearFlagship() {
    state.flagship = null;
    saveState();
    document.querySelectorAll('.flagship-btn').forEach(b => b.classList.remove('selected'));
    document.getElementById('flagship-content').innerHTML = `
        <p class="placeholder">Choose your gravitational center</p>
        <div class="flagship-options" id="flagship-options">
            <button class="flagship-btn" data-flagship="ClaimHaus">ClaimHaus (Tokenized Debt)</button>
            <button class="flagship-btn" data-flagship="Mining Marketplace">Tokenized Mining Marketplace</button>
            <button class="flagship-btn" data-flagship="AI Agent Platform">AI Agent Operations Platform</button>
            <button class="flagship-btn" data-flagship="Marina Platform">Marina Management Platform</button>
            <button class="flagship-btn" data-flagship="Courier Platform">Courier/Logistics Automation</button>
        </div>
    `;
    setupFlagshipSelection();
    renderFlagship();
}

// Idea Capture
function captureIdea() {
    const input = document.getElementById('idea-input');
    const text = input.value.trim();
    
    if (!text) return;
    
    state.currentIdea = {
        text: text,
        timestamp: Date.now(),
        scores: {}
    };
    
    // Show scoring form
    document.getElementById('idea-score-form').style.display = 'block';
    input.value = '';
}

function scoreIdea() {
    if (!state.currentIdea) return;
    
    const dimensions = ['impact', 'leverage', 'momentum', 'excitement', 'ease', 'revenue', 'strategic', 'automation'];
    let total = 0;
    
    dimensions.forEach(dim => {
        const input = document.querySelector(`.score-input[data-dim="${dim}"]`);
        const val = parseInt(input.value) || 5;
        state.currentIdea.scores[dim] = val;
        total += val;
        input.value = ''; // Reset for next idea
    });
    
    const avgScore = total / dimensions.length;
    state.currentIdea.score = avgScore.toFixed(1);
    
    // Add to ideas array
    state.ideas.unshift(state.currentIdea);
    state.currentIdea = null;
    
    saveState();
    renderIdeas();
    
    // Hide scoring form
    document.getElementById('idea-score-form').style.display = 'none';
}

function renderIdeas() {
    const container = document.getElementById('ideas-list');
    document.getElementById('ideas-count').textContent = state.ideas.length;
    
    if (state.ideas.length === 0) {
        container.innerHTML = '<p style="color: var(--text-muted); text-align: center; padding: 40px;">No ideas yet. Capture your first idea above.</p>';
        return;
    }
    
    container.innerHTML = state.ideas.map((idea, idx) => {
        const score = parseFloat(idea.score);
        let scoreClass = 'low-score';
        if (score >= 7) scoreClass = 'high-score';
        else if (score >= 5) scoreClass = 'mid-score';
        
        return `
            <div class="idea-item ${scoreClass}">
                <div class="idea-text">
                    <strong>${idea.text}</strong>
                    <div style="font-size: 11px; color: var(--text-muted); margin-top: 4px;">
                        ${new Date(idea.timestamp).toLocaleDateString()}
                    </div>
                </div>
                <div class="idea-score">${idea.score}</div>
            </div>
        `;
    }).join('');
}

// Projects
function addProject() {
    const name = prompt('Project name:');
    if (!name) return;
    
    const project = {
        id: Date.now(),
        name: name,
        status: 'active',
        createdAt: Date.now(),
        coreLoop: '',
        mvu: ''
    };
    
    state.projects.push(project);
    saveState();
    renderProjects();
}

function renderProjects() {
    const container = document.getElementById('projects-grid');
    document.getElementById('active-projects-count').textContent = state.projects.filter(p => p.status === 'active').length;
    
    if (state.projects.length === 0) {
        container.innerHTML = '<p style="color: var(--text-muted); text-align: center; padding: 40px; grid-column: 1/-1;">No projects yet. Click "+ New Project" to add one.</p>';
        return;
    }
    
    container.innerHTML = state.projects.map(project => `
        <div class="project-card">
            <h4>${project.name}</h4>
            <span class="project-status ${project.status}">${project.status}</span>
            <div style="margin-top: 12px; font-size: 13px; color: var(--text-secondary);">
                <p><strong>Core Loop:</strong> ${project.coreLoop || 'Not defined'}</p>
                <p><strong>MVU:</strong> ${project.mvu || 'Not defined'}</p>
            </div>
            <div style="margin-top: 12px;">
                <button class="btn-small" onclick="editProject(${project.id})">Edit</button>
                <button class="btn-small" onclick="toggleProjectStatus(${project.id})">${project.status === 'active' ? 'Pause' : 'Activate'}</button>
            </div>
        </div>
    `).join('');
}

function editProject(id) {
    const project = state.projects.find(p => p.id === id);
    if (!project) return;
    
    const coreLoop = prompt('Core Loop (the repeatable action that powers everything):', project.coreLoop);
    if (coreLoop !== null) project.coreLoop = coreLoop;
    
    const mvu = prompt('MVU (Minimum Viable Universe - smallest functional world):', project.mvu);
    if (mvu !== null) project.mvu = mvu;
    
    saveState();
    renderProjects();
}

function toggleProjectStatus(id) {
    const project = state.projects.find(p => p.id === id);
    if (!project) return;
    
    project.status = project.status === 'active' ? 'paused' : 'active';
    saveState();
    renderProjects();
}

// Delegation
function addDelegatedTask() {
    const text = prompt('Task description:');
    if (!text) return;
    
    const assignee = prompt('Assign to (team member name or "AI"):');
    if (!assignee) return;
    
    const task = {
        id: Date.now(),
        text: text,
        assignee: assignee,
        isAI: assignee.toLowerCase().includes('ai') || assignee.toLowerCase().includes('agent'),
        completed: false,
        createdAt: Date.now()
    };
    
    state.tasks.push(task);
    saveState();
    renderTasks();
}

function renderTasks() {
    const teamContainer = document.getElementById('team-tasks');
    const agentContainer = document.getElementById('agent-tasks');
    
    const teamTasks = state.tasks.filter(t => !t.isAI);
    const agentTasks = state.tasks.filter(t => t.isAI);
    
    teamContainer.innerHTML = teamTasks.length ? teamTasks.map(t => `
        <div style="padding: 8px; margin-bottom: 8px; background: var(--bg-tertiary); border-radius: 6px;">
            <p style="font-size: 13px;">${t.text}</p>
            <p style="font-size: 11px; color: var(--text-muted);">Assigned to: ${t.assignee}</p>
        </div>
    `).join('') : '<p style="color: var(--text-muted); font-size: 13px;">No team tasks</p>';
    
    agentContainer.innerHTML = agentTasks.length ? agentTasks.map(t => `
        <div style="padding: 8px; margin-bottom: 8px; background: var(--bg-tertiary); border-radius: 6px;">
            <p style="font-size: 13px;">${t.text}</p>
            <p style="font-size: 11px; color: var(--text-muted);">Assigned to: ${t.assignee}</p>
        </div>
    `).join('') : '<p style="color: var(--text-muted); font-size: 13px;">No agent tasks</p>';
}

// Energy Tracker
function setupEnergyTracker() {
    const buttons = document.querySelectorAll('.energy-btn');
    
    buttons.forEach(btn => {
        btn.addEventListener('click', () => {
            buttons.forEach(b => b.classList.remove('selected'));
            btn.classList.add('selected');
            
            const level = parseInt(btn.dataset.level);
            state.energy.push({
                level: level,
                timestamp: Date.now()
            });
            
            // Keep only last 30 days
            const thirtyDaysAgo = Date.now() - (30 * 24 * 60 * 60 * 1000);
            state.energy = state.energy.filter(e => e.timestamp > thirtyDaysAgo);
            
            saveState();
        });
    });
}

// Seed (MVU) Management
function addSeed() {
    const seed = prompt('Active Seed (MVU) - What minimum viable universe are you building?');
    if (!seed) return;
    
    state.activeSeed = {
        text: seed,
        startedAt: Date.now()
    };
    
    saveState();
    renderSeed();
}

function renderSeed() {
    const container = document.getElementById('seed-content');
    
    if (state.activeSeed) {
        const daysActive = Math.floor((Date.now() - state.activeSeed.startedAt) / (24 * 60 * 60 * 1000));
        container.innerHTML = `
            <div>
                <p style="font-size: 15px; margin-bottom: 8px;">${state.activeSeed.text}</p>
                <p style="font-size: 12px; color: var(--text-muted);">Active for ${daysActive} day(s)</p>
                <button class="btn-small" onclick="clearSeed()" style="margin-top: 12px;">Complete/Change</button>
            </div>
        `;
    }
}

function clearSeed() {
    state.activeSeed = null;
    saveState();
    document.getElementById('seed-content').innerHTML = '<p class="placeholder">Minimum Viable Universe in progress</p>';
}

// Today's Task
function setTodayTask() {
    const task = prompt("What's the ONE thing that moves the needle today?");
    if (!task) return;
    
    state.todayTask = {
        text: task,
        date: new Date().toDateString()
    };
    
    saveState();
    renderTodayTask();
}

function renderTodayTask() {
    const container = document.getElementById('today-content');
    
    // Reset if it's a new day
    if (state.todayTask && state.todayTask.date !== new Date().toDateString()) {
        state.todayTask = null;
        saveState();
    }
    
    if (state.todayTask) {
        container.innerHTML = `
            <div>
                <p style="font-size: 16px; font-weight: 600;">${state.todayTask.text}</p>
                <button class="btn-small" onclick="completeTodayTask()" style="margin-top: 12px;">✓ Complete</button>
            </div>
        `;
    }
}

function completeTodayTask() {
    const completed = state.completed || [];
    completed.push({
        ...state.todayTask,
        completedAt: Date.now()
    });
    state.completed = completed;
    state.todayTask = null;
    saveState();
    
    document.getElementById('completed-count').textContent = completed.length;
    document.getElementById('today-content').innerHTML = '<p class="placeholder">What moves the needle today?</p>';
}

// Render All
function renderAll() {
    renderFlagship();
    renderIdeas();
    renderProjects();
    renderTasks();
    renderSeed();
    renderTodayTask();
    
    if (state.completed) {
        document.getElementById('completed-count').textContent = state.completed.length;
    }
}
