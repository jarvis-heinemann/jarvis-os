// Mission Control - Shell Factory Operating System
// Phase 1-6 Tracking + Brand Pipeline + IP Portfolio

// ==================== SHELL FACTORY STATE ====================

let shellFactoryState = {
  currentPhase: 1,
  phaseExitCriteria: {
    1: { surfaceArea: false, credibility: false, capture: false, unification: false, decision: false },
    2: { mvpComplete: false, paidPilots: 0, realDeployments: false },
    3: { multiTenant: false, compliance: false, annualContracts: 0 },
    4: { scaleChannel: false, expansionMotion: false },
    5: { unifiedPlatform: false, verticalModules: 0 },
    6: { certificationRevenue: false, licensingRevenue: false }
  },
  
  // Core Engine Spec (never changes)
  coreEngine: {
    controlPlane: { status: 'spec', description: 'Policy locks, allow/deny/confirm, roles' },
    evidencePlane: { status: 'spec', description: 'Signed packets, redaction, audit exports' },
    acceptancePlane: { status: 'spec', description: 'DAT templates, tests, gates' },
    offlinePlane: { status: 'spec', description: 'Offline-first, sync, replay' },
    slaPlane: { status: 'spec', description: 'Uptime, swap pools, response windows' },
    ledgerPlane: { status: 'spec', description: 'Decision trace, justification, replay' }
  },
  
  // Monaco Clone - GTM Engine for All Shells
  gtmEngine: {
    enabled: true,
    
    // TAM Builder
    tamBuilder: {
      status: 'building',
      shells: [
        { 
          name: 'Ignis', 
          tam: [], 
          targetBuyers: ['Fire Chiefs', 'Safety Directors', 'Emergency Managers'],
          signals: ['budget increases', 'new equipment RFPs', 'leadership changes'],
          totalAddressable: 0,
          scored: 0
        },
        { 
          name: 'ClaimHaus', 
          tam: [], 
          targetBuyers: ['Debt Buyers', 'Portfolio Managers', 'Collections Directors'],
          signals: ['portfolio purchases', 'distressed debt activity', 'compliance needs'],
          totalAddressable: 0,
          scored: 0
        },
        { 
          name: 'Saybrook', 
          tam: [], 
          targetBuyers: ['CFOs', 'Finance Directors', 'Procurement Officers'],
          signals: ['cost reduction initiatives', 'vendor reviews', 'budget pressures'],
          totalAddressable: 0,
          scored: 0
        },
        { 
          name: 'HeinemannCapital', 
          tam: [], 
          targetBuyers: ['Family Offices', 'Allocators', 'RIAs'],
          signals: ['fund searches', 'allocation changes', 'real estate focus'],
          totalAddressable: 0,
          scored: 0
        },
        { 
          name: 'GraphNative', 
          tam: [], 
          targetBuyers: ['CTOs', 'VP Engineering', 'Platform Architects'],
          signals: ['AI governance needs', 'agent deployments', 'compliance requirements'],
          totalAddressable: 0,
          scored: 0
        }
      ]
    },
    
    // Outbound Engine
    outboundEngine: {
      status: 'building',
      sequences: [],
      emailsSent: 0,
      meetingsBooked: 0,
      replies: 0,
      
      // Email Provider Integration
      providers: {
        hunter: { status: 'not-connected', cost: '$49/mo' },
        smartlead: { status: 'not-connected', cost: '$80/mo' }
      },
      
      // Sequence Templates (AI-Generated)
      templates: [
        {
          name: 'Pilot Introduction',
          steps: [
            { day: 0, type: 'email', purpose: 'Introduction + pilot offer' },
            { day: 3, type: 'email', purpose: 'Case study + urgency' },
            { day: 7, type: 'email', purpose: 'Different angle + social proof' },
            { day: 14, type: 'email', purpose: 'Break-up email' }
          ]
        },
        {
          name: 'Investor Introduction',
          steps: [
            { day: 0, type: 'email', purpose: 'Fund overview + track record' },
            { day: 5, type: 'email', purpose: 'Portfolio update + metrics' },
            { day: 12, type: 'email', purpose: 'Market thesis + opportunity' },
            { day: 21, type: 'email', purpose: 'Call to action' }
          ]
        }
      ]
    },
    
    // CRM & Pipeline
    crm: {
      status: 'building',
      contacts: [],
      companies: [],
      opportunities: [],
      pipeline: {
        awareness: [],
        interest: [],
        consideration: [],
        intent: [],
        evaluation: [],
        purchase: []
      },
      
      // Interaction Logging
      interactions: {
        emails: [],
        calls: [],
        meetings: [],
        notes: []
      }
    },
    
    // CRO Copilot
    croCopilot: {
      status: 'building',
      methodology: 'SPIN Selling + Challenger Sale + MEDDIC',
      recommendations: [
        'Contact 5 new prospects per shell per day',
        'Follow up on all meetings within 24 hours',
        'Send case study after first call',
        'Ask for introduction to decision maker',
        'Create urgency with limited pilot spots'
      ],
      nextActions: []
    },
    
    // Data Providers (Monaco's Built-in Data)
    dataProviders: {
      serper: { cost: '$100/50K searches', status: 'ready' },
      apollo: { cost: '$99/mo', status: 'ready', purpose: 'fallback enrichment' },
      piloterr: { cost: '$49/mo', status: 'ready', purpose: 'LinkedIn data' }
    },
    
    // Automation Agents
    agents: [
      {
        name: 'Prospector Agent',
        role: 'Build TAM, identify buyers, enrich contacts',
        status: 'building',
        runsDaily: true
      },
      {
        name: 'Outreach Agent',
        role: 'Generate sequences, send emails, follow up',
        status: 'building',
        runsDaily: true
      },
      {
        name: 'CRM Agent',
        role: 'Log interactions, update pipeline, clean data',
        status: 'building',
        runsRealtime: true
      },
      {
        name: 'CRO Agent',
        role: 'Analyze pipeline, recommend next actions',
        status: 'building',
        runsDaily: true
      }
    ]
  },
  
  // 20x Company Strategy (From Slide)
  twentyXStrategy: {
    approach: 'hybrid', // teammate, source-of-truth, custom-agents, hybrid
    automations: [
      { function: 'code', automation: 'partial', tools: ['Claude', 'Cursor'] },
      { function: 'support', automation: 'none', tools: [] },
      { function: 'marketing', automation: 'partial', tools: ['Layers'] },
      { function: 'sales', automation: 'none', tools: [] },
      { function: 'hiring', automation: 'none', tools: [] },
      { function: 'QA', automation: 'partial', tools: ['Code Factory'] }
    ],
    shellApproach: [
      { shell: 'ClaimHaus', approach: 'ai-teammate', leverage: '20x' },
      { shell: 'Saybrook', approach: 'source-of-truth', leverage: '20x' },
      { shell: 'Ignis', approach: 'custom-agents', leverage: '20x' },
      { shell: 'HeinemannCapital', approach: 'ai-teammate', leverage: '20x' },
      { shell: 'GraphNative', approach: 'hybrid', leverage: '20x' },
    ]
  },
  
  // Workflow Orchestration Rules (From Tweet)
  workflowRules: {
    planMode: {
      trigger: 'non-trivial task (3+ steps)',
      behavior: 'Write plan to tasks/todo.md'
    },
    subagentStrategy: {
      trigger: 'complex problems',
      behavior: 'Use subagents liberally'
    },
    selfImprovement: {
      trigger: 'user correction',
      behavior: 'Update tasks/lessons.md'
    },
    verification: {
      trigger: 'task completion',
      behavior: 'Prove it works before marking done'
    },
    elegance: {
      trigger: 'non-trivial changes',
      behavior: 'Ask: "Is there a more elegant way?"'
    },
    autonomousBugs: {
      trigger: 'bug report',
      behavior: 'Just fix it, no hand-holding'
    }
  },
  
  // POD Cashflow Engine (NEW - From Article)
  podEngine: {
    enabled: true,
    platforms: ['Printful', 'Printify', 'Gelato'],
    channels: ['Shopify', 'Etsy', 'Amazon', 'TikTok Shop'],
    products: [],
    designs: 0,
    monthlyRevenue: 0,
    targetRevenue: 50000, // $50K/month from article
    strategies: [
      { name: 'SEO & Search Traffic', status: 'not-started' },
      { name: 'AI-Assisted Design', status: 'not-started' },
      { name: 'Social Media Storytelling', status: 'not-started' },
      { name: 'Micro-Creator Partnerships', status: 'not-started' },
      { name: 'Email/SMS Segmentation', status: 'not-started' },
      { name: 'Limited Drops & Scarcity', status: 'not-started' },
      { name: 'User-Generated Content', status: 'not-started' },
      { name: 'Personalization', status: 'not-started' },
      { name: 'Sustainability Branding', status: 'not-started' },
      { name: 'Multi-Channel Distribution', status: 'not-started' },
      { name: 'Analytics & Optimization', status: 'not-started' },
      { name: 'Shoppable Content', status: 'not-started' },
      { name: 'AI Credibility Building', status: 'not-started' },
      { name: 'Community Nurturing', status: 'not-started' },
      { name: 'AR/VR Try-Ons', status: 'not-started' }
    ],
    shellMerchandise: [
      // Each shell can have branded merch
      { shell: 'Ignis', products: ['hoodies', 'tees', 'caps'], revenue: 0 },
      { shell: 'Cygnus', products: ['hoodies', 'tees', 'caps'], revenue: 0 },
      { shell: 'ClaimHaus', products: ['hoodies', 'tees', 'mugs'], revenue: 0 },
      { shell: 'HeinemannCapital', products: ['polos', 'jackets'], revenue: 0 },
      { shell: 'GraphNative', products: ['hoodies', 'tees', 'laptop-cases'], revenue: 0 },
    ]
  },
  
  // Distribution Layer (MISSING - NOW ADDING)
  distribution: {
    enabled: true,
    channels: ['seo', 'social', 'email', 'content', 'ads'],
    automationLevel: 'partial', // manual, partial, full
    contentPipeline: [],
    performanceMetrics: {}
  },
  
  // Skill Packaging
  skills: [
    { name: 'Governance Audit', shell: 'GraphNative', invocations: 0, revenue: 0 },
    { name: 'Decision Trace', shell: 'GraphNative', invocations: 0, revenue: 0 },
    { name: 'Policy Gate', shell: 'GraphNative', invocations: 0, revenue: 0 },
    { name: 'Evidence Packet', shell: 'GraphNative', invocations: 0, revenue: 0 },
    { name: 'CI Governance', shell: 'CI/CD', invocations: 0, revenue: 0 },
    { name: 'Savings Audit', shell: 'Saybrook', invocations: 0, revenue: 0 },
  ],
  
  // Content Pipeline
  contentPipeline: {
    blog: { scheduled: 0, published: 0, drafts: 0 },
    social: { scheduled: 0, published: 0, drafts: 0 },
    email: { scheduled: 0, sent: 0, drafts: 0 },
    seo: { optimized: 0, pending: 0 }
  },
  
  // Brand Pipeline
  brands: [
    // Robotics Wedges
    { name: 'Ignis', domain: 'ignisrobotics.com', vertical: 'robotics', subVertical: 'fire-rescue', status: 'shell', artifacts: 3, capture: true },
    { name: 'Cygnus', domain: 'cygnusrobotics.com', vertical: 'robotics', subVertical: 'security-governance', status: 'shell', artifacts: 4, capture: true },
    { name: 'EON', domain: 'eonrobotics.com', vertical: 'robotics', subVertical: 'security-patrol', status: 'shell', artifacts: 3, capture: true },
    { name: 'Stratos', domain: 'stratosrobotics.com', vertical: 'robotics', subVertical: 'aerial-drones', status: 'shell', artifacts: 4, capture: true },
    { name: 'XELOS', domain: 'xelosrobotics.com', vertical: 'robotics', subVertical: 'industrial-ops', status: 'shell', artifacts: 3, capture: true },
    
    // Finance/Market Wedges
    { name: 'Vectrx', domain: 'vectrx.com', vertical: 'finance', subVertical: 'ats-pre-ipo', status: 'shell', artifacts: 2, capture: true },
    { name: 'Cointique', domain: 'cointique.com', vertical: 'finance', subVertical: 'metals-exchange', status: 'shell', artifacts: 2, capture: true },
    { name: 'Minebloq', domain: 'minebloq.com', vertical: 'finance', subVertical: 'tokenized-mining', status: 'shell', artifacts: 3, capture: true },
    { name: 'ClaimHaus', domain: 'claimhaus.com', vertical: 'finance', subVertical: 'distressed-debt', status: 'prototype', artifacts: 4, capture: true },
    
    // Capital/Services Wedges
    { name: 'HeinemannCapital', domain: 'heinemanncapital.com', vertical: 'capital', subVertical: 'income-fund', status: 'operating', artifacts: 3, capture: true },
    { name: 'Saybrook', domain: 'saybrooksolutions.com', vertical: 'services', subVertical: 'procurement-savings', status: 'operating', artifacts: 4, capture: true },
    { name: 'GALT', domain: 'galtllc.com', vertical: 'holdco', subVertical: 'ip-investment', status: 'operating', artifacts: 0, capture: false },
    
    // Platform Wedges
    { name: 'GraphNative', domain: 'graphnative.ai', vertical: 'platform', subVertical: 'graph-ai', status: 'shell', artifacts: 2, capture: true },
    { name: 'MCP Dashboard', domain: 'mcpdashboard.com', vertical: 'platform', subVertical: 'mcp-tools', status: 'shell', artifacts: 3, capture: true },
    { name: 'Novella', domain: 'novellaos.com', vertical: 'platform', subVertical: 'platform-builder', status: 'shell', artifacts: 3, capture: true },
    
    // NEW: CI/CD Governance (Code Factory Pattern)
    { name: 'CI Governance', domain: 'cicdgovernance.com', vertical: 'devtools', subVertical: 'ci-cd-governance', status: 'shell', artifacts: 4, capture: true },
  ],
  
  // IP Portfolio
  patents: [
    { id: 'P1', title: 'Decision Trace Capture & Replay', family: 'trace', status: 'provisional', filed: '2024-Q1' },
    { id: 'P2', title: 'Constraint-Governed Interception', family: 'interception', status: 'provisional', filed: '2024-Q1' },
    { id: 'P3', title: 'Simulation-Based Authorization', family: 'simulation', status: 'provisional', filed: '2024-Q1' },
    { id: 'P4', title: 'Trajectory-Based Inference', family: 'inference', status: 'provisional', filed: '2024-Q1' },
    { id: 'P5', title: 'Hardware-Bound Authorization', family: 'domain', status: 'provisional', filed: '2024-Q1' },
    // ... more patents
  ],
  
  // Artifact Library
  artifacts: [
    { type: 'Pilot Checklist', template: true, brands: ['all'], version: 'v2.4' },
    { type: 'DAT Template', template: true, brands: ['all'], version: 'v2.4' },
    { type: 'Evidence Packet Spec', template: true, brands: ['all'], version: 'v2.4' },
    { type: 'SLA Sheet', template: true, brands: ['robotics', 'platform'], version: 'v2.3' },
    { type: 'Procurement One-Pager', template: true, brands: ['all'], version: 'v2.3' },
    { type: 'Technical Brief', template: true, brands: ['all'], version: 'v2.4' },
    { type: 'Investor Guide', template: true, brands: ['capital'], version: 'v2.2' },
  ],
  
  // Category Claims Library
  categoryClaims: [
    'X with governance',
    'X with proof',
    'Not demos; production operations',
    'Policy-locked missions',
    'Audit-ready exports',
    'Evidence packets',
    'Acceptance testing (DAT)',
    'Offline-first',
    'Swap pool SLAs',
    'Programmatic compliance'
  ],
  
  // UI Primitives
  uiPrimitives: [
    'Allow / Deny / Confirm',
    'Policy Hash: Verified',
    'Evidence Packet: Signed',
    'Offline: Running',
    'Acceptance: Pass/Fail',
    'Packet IDs: timestamped',
    'Zones: restricted/active',
    'Corridor: governed',
    'Swap Pool: SLA-backed'
  ]
};

// ==================== PHASE TRACKING ====================

function getCurrentPhase() {
  return shellFactoryState.currentPhase;
}

function getPhaseExitCriteria(phase) {
  return shellFactoryState.phaseExitCriteria[phase];
}

function checkPhase1Exit() {
  const criteria = shellFactoryState.phaseExitCriteria[1];
  const brands = shellFactoryState.brands;
  
  // Surface Area: 8-30 brand shells live
  criteria.surfaceArea = brands.length >= 8 && brands.length <= 30;
  
  // Credibility: All have artifacts
  criteria.credibility = brands.every(b => b.artifacts >= 3);
  
  // Capture: All route to capture
  criteria.capture = brands.every(b => b.capture);
  
  // Unification: All share architecture
  criteria.unification = true; // By design
  
  // Decision: Can name top 1-2 wedges
  const operating = brands.filter(b => b.status === 'operating' || b.status === 'prototype');
  criteria.decision = operating.length >= 1;
  
  // Check if all criteria met
  return Object.values(criteria).every(v => v === true);
}

function renderPhaseTracker() {
  const container = document.getElementById('phase-tracker');
  if (!container) return;
  
  const phase = getCurrentPhase();
  const criteria = getPhaseExitCriteria(phase);
  
  const phaseNames = {
    1: 'Narrative + Surface Area + Capture',
    2: 'Design Partner + Prototype',
    3: 'Productization + Compliance',
    4: 'Scale Distribution',
    5: 'Consolidation',
    6: 'Moat + Monetization Flywheel'
  };
  
  let criteriaHTML = '';
  if (criteria) {
    criteriaHTML = Object.entries(criteria).map(([key, value]) => `
      <div class="criterion ${value ? 'met' : 'unmet'}">
        <span class="check">${value ? '✅' : '⬜'}</span>
        <span class="label">${key}</span>
      </div>
    `).join('');
  }
  
  container.innerHTML = `
    <div class="phase-header">
      <h3>Phase ${phase}: ${phaseNames[phase]}</h3>
      <button class="btn-small" onclick="checkPhaseCompletion()">Check Completion</button>
    </div>
    <div class="phase-criteria">
      ${criteriaHTML}
    </div>
  `;
}

function checkPhaseCompletion() {
  if (shellFactoryState.currentPhase === 1) {
    const complete = checkPhase1Exit();
    if (complete) {
      alert('✅ Phase 1 Complete! Ready for Phase 2.');
    } else {
      alert('⚠️ Phase 1 criteria not yet met. See dashboard for details.');
    }
  }
  renderPhaseTracker();
}

// ==================== BRAND PIPELINE ====================

function renderBrandPipeline() {
  const container = document.getElementById('brand-pipeline');
  if (!container) return;
  
  const byStatus = {
    operating: shellFactoryState.brands.filter(b => b.status === 'operating'),
    prototype: shellFactoryState.brands.filter(b => b.status === 'prototype'),
    shell: shellFactoryState.brands.filter(b => b.status === 'shell')
  };
  
  const statusColors = {
    operating: '#00ff88',
    prototype: '#ffcc00',
    shell: '#666'
  };
  
  container.innerHTML = `
    <div class="brand-stats">
      <div class="brand-stat">
        <span class="count">${shellFactoryState.brands.length}</span>
        <span class="label">Total Brands</span>
      </div>
      <div class="brand-stat">
        <span class="count">${byStatus.operating.length}</span>
        <span class="label">Operating</span>
      </div>
      <div class="brand-stat">
        <span class="count">${byStatus.prototype.length}</span>
        <span class="label">Prototype</span>
      </div>
      <div class="brand-stat">
        <span class="count">${byStatus.shell.length}</span>
        <span class="label">Shells</span>
      </div>
    </div>
    
    <div class="brand-sections">
      ${Object.entries(byStatus).map(([status, brands]) => `
        <div class="brand-section">
          <h4 style="color: ${statusColors[status]}">${status.toUpperCase()} (${brands.length})</h4>
          <div class="brand-grid">
            ${brands.map(b => `
              <div class="brand-card" onclick="showBrandDetails('${b.name}')">
                <div class="brand-name">${b.name}</div>
                <div class="brand-vertical">${b.vertical} / ${b.subVertical}</div>
                <div class="brand-meta">
                  <span>📦 ${b.artifacts}</span>
                  <span>${b.capture ? '✅ Capture' : '❌ No Capture'}</span>
                </div>
              </div>
            `).join('')}
          </div>
        </div>
      `).join('')}
    </div>
  `;
}

function showBrandDetails(brandName) {
  const brand = shellFactoryState.brands.find(b => b.name === brandName);
  if (!brand) return;
  
  alert(`
Brand: ${brand.name}
Domain: ${brand.domain}
Vertical: ${brand.vertical}
Sub-Vertical: ${brand.subVertical}
Status: ${brand.status}
Artifacts: ${brand.artifacts}
Capture: ${brand.capture}
  `.trim());
}

// ==================== IP PORTFOLIO ====================

function renderIPPortfolio() {
  const container = document.getElementById('ip-portfolio');
  if (!container) return;
  
  const byFamily = {};
  shellFactoryState.patents.forEach(p => {
    if (!byFamily[p.family]) byFamily[p.family] = [];
    byFamily[p.family].push(p);
  });
  
  container.innerHTML = `
    <div class="ip-stats">
      <div class="ip-stat">
        <span class="count">${shellFactoryState.patents.length}</span>
        <span class="label">Patents</span>
      </div>
      <div class="ip-stat">
        <span class="count">${Object.keys(byFamily).length}</span>
        <span class="label">Families</span>
      </div>
    </div>
    
    <div class="ip-families">
      ${Object.entries(byFamily).map(([family, patents]) => `
        <div class="ip-family">
          <h4>${family.toUpperCase()} (${patents.length})</h4>
          ${patents.map(p => `
            <div class="patent-item">
              <span class="patent-id">${p.id}</span>
              <span class="patent-title">${p.title}</span>
              <span class="patent-status">${p.status}</span>
            </div>
          `).join('')}
        </div>
      `).join('')}
    </div>
  `;
}

// ==================== CORE ENGINE SPEC ====================

function renderCoreEngine() {
  const container = document.getElementById('core-engine');
  if (!container) return;
  
  const statusColors = {
    spec: '#ffcc00',
    prototype: '#00d4ff',
    production: '#00ff88'
  };
  
  container.innerHTML = `
    <div class="engine-planes">
      ${Object.entries(shellFactoryState.coreEngine).map(([plane, data]) => `
        <div class="engine-plane">
          <div class="plane-header">
            <h4>${plane.replace('Plane', ' Plane')}</h4>
            <span class="plane-status" style="color: ${statusColors[data.status]}">${data.status}</span>
          </div>
          <p class="plane-desc">${data.description}</p>
        </div>
      `).join('')}
    </div>
  `;
}

// ==================== ARTIFACT LIBRARY ====================

function renderArtifactLibrary() {
  const container = document.getElementById('artifact-library');
  if (!container) return;
  
  container.innerHTML = `
    <div class="artifact-list">
      ${shellFactoryState.artifacts.map(a => `
        <div class="artifact-item">
          <div class="artifact-name">${a.type}</div>
          <div class="artifact-meta">
            <span>v${a.version}</span>
            <span>${a.brands.includes('all') ? 'All Brands' : a.brands.join(', ')}</span>
          </div>
        </div>
      `).join('')}
    </div>
  `;
}

// ==================== CATEGORY CLAIMS ====================

function renderCategoryClaims() {
  const container = document.getElementById('category-claims');
  if (!container) return;
  
  container.innerHTML = `
    <div class="claims-list">
      ${shellFactoryState.categoryClaims.map(claim => `
        <div class="claim-item">"${claim}"</div>
      `).join('')}
    </div>
  `;
}

// ==================== UI PRIMITIVES ====================

function renderUIPrimitives() {
  const container = document.getElementById('ui-primitives');
  if (!container) return;
  
  container.innerHTML = `
    <div class="primitives-grid">
      ${shellFactoryState.uiPrimitives.map(p => `
        <div class="primitive-tag">${p}</div>
      `).join('')}
    </div>
  `;
}

// ==================== UI PRIMITIVES ====================

function renderUIPrimitives() {
  const container = document.getElementById('ui-primitives');
  if (!container) return;
  
  container.innerHTML = `
    <div class="primitives-grid">
      ${shellFactoryState.uiPrimitives.map(p => `
        <div class="primitive-tag">${p}</div>
      `).join('')}
    </div>
  `;
}

// ==================== GTM ENGINE (Monaco Clone) ====================

function renderGTMEngine() {
  const container = document.getElementById('gtm-engine');
  if (!container) return;
  
  const gtm = shellFactoryState.gtmEngine;
  const tam = gtm.tamBuilder;
  const outbound = gtm.outboundEngine;
  const crm = gtm.crm;
  
  container.innerHTML = `
    <div class="gtm-header">
      <h4>🚀 GTM Engine (Monaco Clone)</h4>
      <span class="gtm-status">${gtm.enabled ? 'ENABLED' : 'DISABLED'}</span>
    </div>
    
    <div class="gtm-stats">
      <div class="gtm-stat">
        <span class="count">${outbound.emailsSent}</span>
        <span class="label">Emails Sent</span>
      </div>
      <div class="gtm-stat">
        <span class="count">${outbound.meetingsBooked}</span>
        <span class="label">Meetings Booked</span>
      </div>
      <div class="gtm-stat">
        <span class="count">${outbound.replies}</span>
        <span class="label">Replies</span>
      </div>
      <div class="gtm-stat">
        <span class="count">${crm.opportunities.length}</span>
        <span class="label">Opportunities</span>
      </div>
    </div>
    
    <div class="gtm-sections">
      <!-- TAM Builder -->
      <div class="gtm-section">
        <h5>🎯 TAM Builder</h5>
        ${tam.shells.map(s => `
          <div class="tam-shell">
            <div class="shell-name">${s.name}</div>
            <div class="tam-metrics">
              <span>TAM: ${s.totalAddressable}</span>
              <span>Scored: ${s.scored}</span>
              <span>Buyers: ${s.targetBuyers.slice(0, 2).join(', ')}</span>
            </div>
            <button class="btn-small" onclick="buildTAM('${s.name}')">Build TAM</button>
          </div>
        `).join('')}
      </div>
      
      <!-- Outbound Engine -->
      <div class="gtm-section">
        <h5>📧 Outbound Engine</h5>
        <div class="sequence-templates">
          ${outbound.templates.map(t => `
            <div class="template-item">
              <span class="template-name">${t.name}</span>
              <span class="template-steps">${t.steps.length} steps</span>
              <button class="btn-small" onclick="launchSequence('${t.name}')">Launch</button>
            </div>
          `).join('')}
        </div>
        <button class="btn-primary" onclick="createSequence()">+ Create Sequence</button>
      </div>
      
      <!-- CRM Pipeline -->
      <div class="gtm-section">
        <h5>📊 CRM Pipeline</h5>
        <div class="pipeline-stages">
          ${Object.entries(crm.pipeline).map(([stage, items]) => `
            <div class="pipeline-stage">
              <div class="stage-name">${stage.toUpperCase()}</div>
              <div class="stage-count">${items.length}</div>
            </div>
          `).join('')}
        </div>
        <button class="btn-small" onclick="viewPipeline()">View Pipeline</button>
      </div>
      
      <!-- CRO Copilot -->
      <div class="gtm-section">
        <h5>🎯 CRO Copilot</h5>
        <div class="cro-recommendations">
          ${gtm.croCopilot.recommendations.slice(0, 3).map(r => `
            <div class="rec-item">• ${r}</div>
          `).join('')}
        </div>
        <button class="btn-small" onclick="getCROAdvice()">Get Advice</button>
      </div>
      
      <!-- Agents -->
      <div class="gtm-section">
        <h5>🤖 GTM Agents</h5>
        ${gtm.agents.map(a => `
          <div class="agent-item ${a.status}">
            <span class="agent-name">${a.name}</span>
            <span class="agent-role">${a.role}</span>
            <span class="agent-status">${a.status}</span>
          </div>
        `).join('')}
        <button class="btn-small" onclick="deployAgents()">Deploy Agents</button>
      </div>
      
      <!-- Data Providers -->
      <div class="gtm-section">
        <h5>📡 Data Providers</h5>
        ${Object.entries(gtm.dataProviders).map(([name, data]) => `
          <div class="provider-item">
            <span class="provider-name">${name}</span>
            <span class="provider-cost">${data.cost}</span>
            <span class="provider-status">${data.status}</span>
          </div>
        `).join('')}
      </div>
    </div>
    
    <div class="gtm-actions">
      <button class="btn-primary" onclick="launchGTM()">🚀 Launch GTM Engine</button>
      <button class="btn-small" onclick="connectProviders()">Connect Providers</button>
      <button class="btn-small" onclick="importContacts()">Import Contacts</button>
    </div>
  `;
}

function buildTAM(shellName) {
  alert(`Building TAM for ${shellName}...\n\nThis would:\n1. Search Serper for target buyers\n2. Enrich with Apollo/Piloterr\n3. Score and rank accounts\n4. Store in CRM`);
}

function launchSequence(templateName) {
  alert(`Launching sequence: ${templateName}\n\nThis would:\n1. Select contacts from TAM\n2. Generate personalized emails with Claude\n3. Queue in outbound engine\n4. Track responses`);
}

function createSequence() {
  alert('Creating new sequence...\n\nThis would open sequence builder with:\n1. Step-by-step wizard\n2. AI-generated email drafts\n3. A/B test options\n4. Timing controls');
}

function viewPipeline() {
  alert('Opening pipeline view...\n\nThis would show:\n1. Kanban board\n2. Drag-and-drop stages\n3. Opportunity details\n4. Next action recommendations');
}

function getCROAdvice() {
  alert('Getting CRO advice...\n\nThis would:\n1. Analyze pipeline health\n2. Identify stuck deals\n3. Recommend next actions\n4. Suggest coaching topics');
}

function deployAgents() {
  alert('Deploying GTM agents...\n\nThis would:\n1. Start Prospector Agent (daily)\n2. Start Outreach Agent (daily)\n3. Start CRM Agent (realtime)\n4. Start CRO Agent (daily)');
}

function launchGTM() {
  alert('🚀 Launching GTM Engine...\n\nThis would:\n1. Build TAM for all shells\n2. Launch outbound sequences\n3. Start CRM tracking\n4. Deploy all agents\n\nTarget: 50+ meetings/month');
}

function connectProviders() {
  alert('Connecting data providers...\n\nThis would:\n1. Connect Serper ($100/50K)\n2. Connect Apollo ($99/mo)\n3. Connect Piloterr ($49/mo)\n\nTotal: ~$250/mo vs Monaco $500-1000+');
}

function importContacts() {
  alert('Importing contacts...\n\nThis would:\n1. Upload CSV\n2. Match with enrichment\n3. Add to TAM\n4. Score and rank');
}

// ==================== 20x COMPANY STRATEGY ====================

function render20xStrategy() {
  const container = document.getElementById('twenty-x-strategy');
  if (!container) return;
  
  const twentyX = shellFactoryState.twentyXStrategy;
  
  container.innerHTML = `
    <div class="twenty-header">
      <h4>📈 20× Company Strategy</h4>
      <span class="approach-badge">${twentyX.approach.toUpperCase()}</span>
    </div>
    
    <div class="automation-grid">
      ${twentyX.automations.map(a => `
        <div class="automation-card ${a.automation}">
          <div class="function-name">${a.function.toUpperCase()}</div>
          <div class="automation-level">
            ${a.automation === 'full' ? '🟢' : a.automation === 'partial' ? '🟡' : '🔴'}
            ${a.automation}
          </div>
          <div class="tools">${a.tools.join(', ') || 'None'}</div>
        </div>
      `).join('')}
    </div>
    
    <div class="shell-approaches">
      <h5>Approach Per Shell</h5>
      ${twentyX.shellApproach.map(s => `
        <div class="approach-item">
          <span class="shell">${s.shell}</span>
          <span class="approach">${s.approach}</span>
          <span class="leverage">${s.leverage}</span>
        </div>
      `).join('')}
    </div>
    
    <div class="three-approaches">
      <div class="approach-explain">
        <strong>1. AI Teammate</strong>
        <p>One agent for everyone (e.g., Giga ML's Atlas)</p>
      </div>
      <div class="approach-explain">
        <strong>2. Source of Truth</strong>
        <p>Unified internal interface (e.g., Legion Health)</p>
      </div>
      <div class="approach-explain">
        <strong>3. Custom Agents</strong>
        <p>Per-employee automation (e.g., Phase Shift)</p>
      </div>
    </div>
  `;
}

// ==================== WORKFLOW ORCHESTRATION ====================

function renderWorkflowRules() {
  const container = document.getElementById('workflow-rules');
  if (!container) return;
  
  const rules = shellFactoryState.workflowRules;
  
  container.innerHTML = `
    <div class="workflow-header">
      <h4>⚙️ Workflow Orchestration Rules</h4>
    </div>
    
    <div class="rules-list">
      <div class="rule-item">
        <div class="rule-name">📋 Plan Mode</div>
        <div class="rule-trigger">Trigger: ${rules.planMode.trigger}</div>
        <div class="rule-behavior">→ ${rules.planMode.behavior}</div>
      </div>
      <div class="rule-item">
        <div class="rule-name">🤖 Subagent Strategy</div>
        <div class="rule-trigger">Trigger: ${rules.subagentStrategy.trigger}</div>
        <div class="rule-behavior">→ ${rules.subagentStrategy.behavior}</div>
      </div>
      <div class="rule-item">
        <div class="rule-name">🔄 Self-Improvement Loop</div>
        <div class="rule-trigger">Trigger: ${rules.selfImprovement.trigger}</div>
        <div class="rule-behavior">→ ${rules.selfImprovement.behavior}</div>
      </div>
      <div class="rule-item">
        <div class="rule-name">✅ Verification Before Done</div>
        <div class="rule-trigger">Trigger: ${rules.verification.trigger}</div>
        <div class="rule-behavior">→ ${rules.verification.behavior}</div>
      </div>
      <div class="rule-item">
        <div class="rule-name">💎 Demand Elegance</div>
        <div class="rule-trigger">Trigger: ${rules.elegance.trigger}</div>
        <div class="rule-behavior">→ ${rules.elegance.behavior}</div>
      </div>
      <div class="rule-item">
        <div class="rule-name">🐛 Autonomous Bug Fixing</div>
        <div class="rule-trigger">Trigger: ${rules.autonomousBugs.trigger}</div>
        <div class="rule-behavior">→ ${rules.autonomousBugs.behavior}</div>
      </div>
    </div>
    
    <div class="principles">
      <h5>Core Principles</h5>
      <ul>
        <li><strong>Simplicity First:</strong> Minimal code, minimal impact</li>
        <li><strong>No Laziness:</strong> Find root causes, no temp fixes</li>
        <li><strong>Minimal Impact:</strong> Only touch what's necessary</li>
      </ul>
    </div>
  `;
}

// ==================== POD CASHFLOW ENGINE ====================

function renderPODEngine() {
  const container = document.getElementById('pod-engine');
  if (!container) return;
  
  const pod = shellFactoryState.podEngine;
  const strategiesComplete = pod.strategies.filter(s => s.status === 'complete').length;
  const totalStrategies = pod.strategies.length;
  const progressPercent = Math.round((strategiesComplete / totalStrategies) * 100);
  
  container.innerHTML = `
    <div class="pod-header">
      <h4>💰 POD Cashflow Engine</h4>
      <span class="pod-status ${pod.enabled ? 'enabled' : 'disabled'}">
        ${pod.enabled ? 'ENABLED' : 'DISABLED'}
      </span>
    </div>
    
    <div class="pod-stats">
      <div class="pod-stat">
        <span class="count">$${pod.monthlyRevenue.toLocaleString()}</span>
        <span class="label">Monthly Revenue</span>
      </div>
      <div class="pod-stat">
        <span class="count">$${pod.targetRevenue.toLocaleString()}</span>
        <span class="label">Target</span>
      </div>
      <div class="pod-stat">
        <span class="count">${pod.designs}</span>
        <span class="label">Designs</span>
      </div>
      <div class="pod-stat">
        <span class="count">${strategiesComplete}/${totalStrategies}</span>
        <span class="label">Strategies</span>
      </div>
    </div>
    
    <div class="pod-progress">
      <div class="progress-bar">
        <div class="progress-fill" style="width: ${progressPercent}%"></div>
      </div>
      <span class="progress-text">${progressPercent}% Complete</span>
    </div>
    
    <div class="pod-strategies">
      <h5>15 Revenue Strategies</h5>
      ${pod.strategies.map(s => `
        <div class="strategy-item ${s.status}">
          <span class="strategy-name">${s.name}</span>
          <span class="strategy-status">${s.status === 'complete' ? '✅' : s.status === 'in-progress' ? '🔄' : '⬜'}</span>
        </div>
      `).join('')}
    </div>
    
    <div class="pod-merch">
      <h5>Shell Merchandise Revenue</h5>
      ${pod.shellMerchandise.map(m => `
        <div class="merch-item">
          <span class="merch-shell">${m.shell}</span>
          <span class="merch-products">${m.products.join(', ')}</span>
          <span class="merch-revenue">$${m.revenue}</span>
        </div>
      `).join('')}
    </div>
    
    <div class="pod-actions">
      <button class="btn-primary" onclick="launchPOD()">🚀 Launch POD Engine</button>
      <button class="btn-small" onclick="generateDesigns()">Generate Designs with AI</button>
      <button class="btn-small" onclick="setupChannels()">Setup Channels</button>
    </div>
  `;
}

function launchPOD() {
  alert('🚀 Launching POD Cashflow Engine...\n\nThis would:\n1. Connect to Printful/Printify\n2. Generate 25-50 AI designs\n3. Create product listings\n4. Setup TikTok Shop + Etsy + Amazon\n5. Launch first limited drop\n\nTarget: $50K/month in 6 months');
}

function generateDesigns() {
  alert('🎨 Generating AI Designs...\n\nThis would:\n1. Analyze shell themes\n2. Generate design prompts\n3. Create 25-50 designs\n4. Auto-mockup on products');
}

function setupChannels() {
  alert('📺 Setting up channels...\n\nThis would:\n1. Connect TikTok Shop\n2. Setup Etsy store\n3. Integrate Amazon\n4. Create Shopify site');
}

// ==================== DISTRIBUTION LAYER ====================

function renderDistributionLayer() {
  const container = document.getElementById('distribution-layer');
  if (!container) return;
  
  const dist = shellFactoryState.distribution;
  const content = shellFactoryState.contentPipeline;
  
  container.innerHTML = `
    <div class="dist-header">
      <h4>🚀 Distribution Layer</h4>
      <span class="dist-status ${dist.enabled ? 'enabled' : 'disabled'}">
        ${dist.enabled ? 'ENABLED' : 'DISABLED'}
      </span>
    </div>
    
    <div class="dist-channels">
      ${dist.channels.map(ch => `
        <div class="channel-card">
          <div class="channel-name">${ch.toUpperCase()}</div>
          <div class="channel-metric">
            <span class="metric-value">${content[ch]?.published || 0}</span>
            <span class="metric-label">Published</span>
          </div>
          <div class="channel-metric">
            <span class="metric-value">${content[ch]?.scheduled || 0}</span>
            <span class="metric-label">Scheduled</span>
          </div>
        </div>
      `).join('')}
    </div>
    
    <div class="dist-actions">
      <button class="btn-small" onclick="generateContent()">+ Generate Content</button>
      <button class="btn-small" onclick="scheduleDistribution()">📅 Schedule</button>
      <button class="btn-small" onclick="viewAnalytics()">📊 Analytics</button>
    </div>
    
    <div class="dist-automation">
      <label>Automation Level:</label>
      <select onchange="setAutomationLevel(this.value)">
        <option value="manual" ${dist.automationLevel === 'manual' ? 'selected' : ''}>Manual</option>
        <option value="partial" ${dist.automationLevel === 'partial' ? 'selected' : ''}>Partial</option>
        <option value="full" ${dist.automationLevel === 'full' ? 'selected' : ''}>Full Auto</option>
      </select>
    </div>
  `;
}

function generateContent() {
  alert('Generating content for all shells...\n\nThis would:\n1. Analyze each shell\n2. Generate blog posts\n3. Create social content\n4. Draft email sequences');
}

function scheduleDistribution() {
  alert('Opening distribution scheduler...\n\nThis would show:\n1. Content calendar\n2. Channel schedules\n3. Automation rules');
}

function viewAnalytics() {
  alert('Opening analytics...\n\nThis would show:\n1. Traffic by shell\n2. Conversion rates\n3. Content performance');
}

function setAutomationLevel(level) {
  shellFactoryState.distribution.automationLevel = level;
  console.log('Automation level set to:', level);
}

// ==================== SKILL PACKAGING ====================

function renderSkillPackaging() {
  const container = document.getElementById('skill-packaging');
  if (!container) return;
  
  const skills = shellFactoryState.skills;
  const totalInvocations = skills.reduce((sum, s) => sum + s.invocations, 0);
  const totalRevenue = skills.reduce((sum, s) => sum + s.revenue, 0);
  
  container.innerHTML = `
    <div class="skill-stats">
      <div class="skill-stat">
        <span class="count">${skills.length}</span>
        <span class="label">Skills</span>
      </div>
      <div class="skill-stat">
        <span class="count">${totalInvocations.toLocaleString()}</span>
        <span class="label">Invocations</span>
      </div>
      <div class="skill-stat">
        <span class="count">$${totalRevenue.toLocaleString()}</span>
        <span class="label">Revenue</span>
      </div>
    </div>
    
    <div class="skill-list">
      ${skills.map(s => `
        <div class="skill-item">
          <div class="skill-name">${s.name}</div>
          <div class="skill-shell">${s.shell}</div>
          <div class="skill-metrics">
            <span>📞 ${s.invocations}</span>
            <span>💰 $${s.revenue}</span>
          </div>
          <button class="btn-small" onclick="packageSkill('${s.name}')">Package</button>
        </div>
      `).join('')}
    </div>
    
    <div class="skill-info">
      <p><strong>Skill Era Thesis:</strong></p>
      <p>• API Era = Doorway into function</p>
      <p>• Skill Era = Doorway into judgment</p>
      <p>• Scale by invocations, not seats</p>
    </div>
  `;
}

function packageSkill(skillName) {
  alert(`Packaging skill: ${skillName}\n\nThis would:\n1. Create skill definition\n2. Generate documentation\n3. Package for agent invocation\n4. Set pricing per invocation`);
}

// ==================== AFFILIATE ENGINE ====================

function renderAffiliateEngine() {
  const container = document.getElementById('affiliate-engine');
  if (!container || !window.AffiliateEngine) return;

  const engine = window.AffiliateEngine;
  const status = engine.getStatus();

  container.innerHTML = `
    <div class="affiliate-header">
      <h4>💰 Affiliate Marketing Engine</h4>
      <span class="affiliate-status">READY</span>
    </div>

    <div class="affiliate-method">
      <h5>111 Scaling Method</h5>
      <p><strong>10 campaigns × 50 adsets × 1 ad = 500 ads</strong></p>
      <p>BitCap: $${engine.config.scalingMethod.bitCap.daily}/day</p>
      <p>Auto-scale winners: ${engine.config.scalingMethod.bitCap.autoScale ? 'Yes' : 'No'}</p>
    </div>

    <div class="affiliate-stats">
      <div class="affiliate-stat">
        <span class="count">${status.campaigns.ready}</span>
        <span class="label">Campaigns Ready</span>
      </div>
      <div class="affiliate-stat">
        <span class="count">${engine.config.testing.totalTestBudget}</span>
        <span class="label">Test Budget</span>
      </div>
      <div class="affiliate-stat">
        <span class="count">${engine.config.testing.killWindow}</span>
        <span class="label">Day Kill Window</span>
      </div>
      <div class="affiliate-stat">
        <span class="count">${engine.kpis.targets.monthlyProfit}</span>
        <span class="label">Monthly Target</span>
      </div>
    </div>

    <div class="affiliate-campaigns">
      <h5>Active Campaigns</h5>
      ${engine.campaigns.map(c => `
        <div class="campaign-item">
          <div class="campaign-name">${c.name}</div>
          <div class="campaign-details">
            <span>Offer: ${c.offer}</span>
            <span>Payout: $${c.payout}</span>
            <span class="campaign-status ${c.status}">${c.status}</span>
          </div>
        </div>
      `).join('')}
    </div>

    <div class="affiliate-platforms">
      <h5>Platform Stack</h5>
      <div class="platform-item">
        <strong>Primary:</strong> ${engine.config.platforms.primary.name} (${engine.config.platforms.primary.format})
      </div>
      <div class="platform-item">
        <strong>Secondary:</strong> ${engine.config.platforms.secondary.name} (${engine.config.platforms.secondary.format})
      </div>
    </div>

    <div class="affiliate-tools">
      <h5>Spy & Creative Tools</h5>
      <div class="tool-item">
        <span>${engine.config.spyTools.adPlexity.name}</span>
        <span>$${engine.config.spyTools.adPlexity.cost}/mo</span>
      </div>
      <div class="tool-item">
        <span>${engine.config.spyTools.foreplay.name}</span>
        <span>$${engine.config.spyTools.foreplay.cost}/mo</span>
      </div>
      <div class="tool-item">
        <span>N8N Automation</span>
        <span>$${engine.config.adGeneration.automation.costPerMonth}/mo</span>
      </div>
    </div>

    <div class="affiliate-generation">
      <h5>AI Creative Generation</h5>
      <p><strong>Platform:</strong> ${engine.config.adGeneration.platform}</p>
      <p><strong>Cost per image:</strong> $${engine.config.adGeneration.costPerImage}</p>
      <p><strong>Batch size:</strong> ${engine.config.adGeneration.batchSize} prompts</p>
      <p><strong>Total cost per batch:</strong> $${engine.config.adGeneration.batchSize * engine.config.adGeneration.costPerImage}</p>
    </div>

    <div class="affiliate-actions">
      <button class="btn-primary" onclick="launchAffiliateEngine()">🚀 Launch Affiliate Engine</button>
      <button class="btn-small" onclick="generateAffiliateCreatives()">Generate 500 Creatives</button>
      <button class="btn-small" onclick="viewAffiliateMetrics()">View Metrics</button>
    </div>
  `;
}

function launchAffiliateEngine() {
  alert('🚀 Launching Affiliate Engine...\n\nThis would:\n1. Set up N8N automation on Digital Ocean\n2. Connect OpenArt.AI for creative generation\n3. Configure Facebook/TikTok ad accounts\n4. Deploy 5 campaigns with 111 Method\n5. Start $600 test phase\n\nTarget: $10K/month profit');
}

function generateAffiliateCreatives() {
  alert('🎨 Generating 500 ad creatives...\n\nThis would:\n1. Generate 500 prompts (hooks × emotions)\n2. Export to Google Sheets\n3. Submit batch to OpenArt.AI\n4. Ready by morning (8-hour generation)\n5. Cost: $40 ($0.08 × 500)');
}

function viewAffiliateMetrics() {
  alert('📊 Opening affiliate metrics...\n\nThis would show:\n1. Daily spend/revenue/profit\n2. Campaign performance\n3. Creative ROI rankings\n4. Scaling recommendations');
}

// ==================== INITIALIZE ====================

document.addEventListener('DOMContentLoaded', () => {
  renderPhaseTracker();
  renderBrandPipeline();
  renderIPPortfolio();
  renderCoreEngine();
  renderArtifactLibrary();
  renderCategoryClaims();
  renderUIPrimitives();
  renderGTMEngine();
  render20xStrategy();
  renderWorkflowRules();
  renderPODEngine();
  renderDistributionLayer();
  renderSkillPackaging();
  renderAffiliateEngine();
  renderNextActions();
});

// Export functions
window.checkPhaseCompletion = checkPhaseCompletion;
window.showBrandDetails = showBrandDetails;

// ==================== NEXT ACTIONS PANEL ====================

function renderNextActions() {
  const container = document.getElementById('next-actions');
  if (!container) return;

  container.innerHTML = `
    <div class="next-actions-header">
      <h4>🎯 Next Actions</h4>
      <span class="actions-date">Updated: ${new Date().toLocaleDateString()}</span>
    </div>

    <div class="actions-priority">
      <h5>🔥 Priority 1: ClaimHaus Launch</h5>
      <div class="action-item">
        <input type="checkbox" id="action-1" />
        <label for="action-1">Set up Smartlead email automation ($80/mo)</label>
      </div>
      <div class="action-item">
        <input type="checkbox" id="action-2" />
        <label for="action-2">Upload 10 target accounts to CRM</label>
      </div>
      <div class="action-item">
        <input type="checkbox" id="action-3" />
        <label for="action-3">Deploy ClaimHaus landing page (claimhaus.com)</label>
      </div>
      <div class="action-item">
        <input type="checkbox" id="action-4" />
        <label for="action-4">Launch email sequence to 10 accounts</label>
      </div>
      <div class="action-item">
        <input type="checkbox" id="action-5" />
        <label for="action-5">Book 3 pilot meetings</label>
      </div>
    </div>

    <div class="actions-weekly">
      <h5>📅 This Week (Feb 18-24)</h5>
      <div class="action-item">
        <input type="checkbox" id="action-6" />
        <label for="action-6">Contact 10 accounts (email sequence)</label>
      </div>
      <div class="action-item">
        <input type="checkbox" id="action-7" />
        <label for="action-7">Create demo deck</label>
      </div>
      <div class="action-item">
        <input type="checkbox" id="action-8" />
        <label for="action-8">Run 1 pilot demo</label>
      </div>
      <div class="action-item">
        <input type="checkbox" id="action-9" />
        <label for="action-9">Close 1 pilot customer ($5K)</label>
      </div>
    </div>

    <div class="actions-metrics">
      <h5>📊 Week 1 Targets</h5>
      <div class="metric-row">
        <span>Open Rate:</span>
        <span class="metric-target">>30%</span>
      </div>
      <div class="metric-row">
        <span>Reply Rate:</span>
        <span class="metric-target">>10%</span>
      </div>
      <div class="metric-row">
        <span>Meetings:</span>
        <span class="metric-target">3</span>
      </div>
      <div class="metric-row">
        <span>Revenue:</span>
        <span class="metric-target">$5,000</span>
      </div>
    </div>

    <div class="actions-tools">
      <h5>🛠️ Tools Needed</h5>
      <div class="tool-row">
        <span class="tool-status pending">⬜</span>
        <span>Smartlead</span>
        <span class="tool-cost">$80/mo</span>
      </div>
      <div class="tool-row">
        <span class="tool-status pending">⬜</span>
        <span>Hunter.io</span>
        <span class="tool-cost">$49/mo</span>
      </div>
      <div class="tool-row">
        <span class="tool-status done">✅</span>
        <span>Mission Control</span>
        <span class="tool-cost">Free</span>
      </div>
      <div class="tool-row">
        <span class="tool-status done">✅</span>
        <span>GTM Launchpad</span>
        <span class="tool-cost">Built</span>
      </div>
      <div class="tool-row">
        <span class="tool-status done">✅</span>
        <span>Affiliate Engine</span>
        <span class="tool-cost">Built</span>
      </div>
    </div>

    <div class="actions-links">
      <a href="claimhaus-launch-kit.md" class="action-link">📋 View ClaimHaus Launch Kit</a>
      <a href="ACTION-PLAN.md" class="action-link">📅 View Full Action Plan</a>
      <a href="outbound-templates.md" class="action-link">📧 View Email Templates</a>
    </div>
  `;
}
