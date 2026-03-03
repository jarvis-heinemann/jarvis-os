// CRM Integration Module for Mission Control
// Syncs contact data from JSON files to dashboard

const CRMIntegration = {
  
  // Load all CRM data
  loadCRMData: async function() {
    try {
      const [contacts, companies, opportunities, interactions] = await Promise.all([
        this.loadJSON('data/contacts.json'),
        this.loadJSON('data/companies.json'),
        this.loadJSON('data/opportunities.json'),
        this.loadJSON('data/interactions.json')
      ]);
      
      return {
        contacts: contacts.contacts || [],
        companies: companies.companies || [],
        opportunities: opportunities.opportunities || [],
        interactions: interactions.interactions || [],
        pipeline: opportunities.pipeline || {},
        stats: interactions.stats || {}
      };
    } catch (error) {
      console.error('Error loading CRM data:', error);
      return {
        contacts: [],
        companies: [],
        opportunities: [],
        interactions: [],
        pipeline: {},
        stats: {}
      };
    }
  },
  
  // Load JSON file
  loadJSON: async function(path) {
    try {
      const response = await fetch(path);
      return await response.json();
    } catch (error) {
      console.error(`Error loading ${path}:`, error);
      return {};
    }
  },
  
  // Render CRM Dashboard
  renderCRMDashboard: function(data) {
    const container = document.getElementById('crm-dashboard');
    if (!container) return;
    
    const totalPipeline = data.opportunities.reduce((sum, opp) => sum + opp.value, 0);
    const weightedPipeline = data.opportunities.reduce((sum, opp) => sum + (opp.value * opp.probability / 100), 0);
    
    container.innerHTML = `
      <div class="crm-header">
        <h3>💼 CRM Dashboard</h3>
        <button class="btn-small" onclick="refreshCRM()">🔄 Refresh</button>
      </div>
      
      <div class="crm-stats">
        <div class="crm-stat">
          <span class="count">${data.contacts.length}</span>
          <span class="label">Contacts</span>
        </div>
        <div class="crm-stat">
          <span class="count">${data.companies.length}</span>
          <span class="label">Companies</span>
        </div>
        <div class="crm-stat">
          <span class="count">${data.opportunities.length}</span>
          <span class="label">Opportunities</span>
        </div>
        <div class="crm-stat">
          <span class="count">$${(totalPipeline / 1000).toFixed(0)}K</span>
          <span class="label">Pipeline</span>
        </div>
      </div>
      
      <div class="crm-pipeline">
        <h4>Pipeline by Stage</h4>
        ${this.renderPipelineStages(data.pipeline, data.opportunities)}
      </div>
      
      <div class="crm-contacts">
        <h4>Recent Contacts</h4>
        ${this.renderRecentContacts(data.contacts.slice(0, 5))}
      </div>
      
      <div class="crm-actions">
        <button class="btn-small" onclick="addNewContact()">+ Add Contact</button>
        <button class="btn-small" onclick="exportCRM()">📤 Export</button>
        <button class="btn-small" onclick="viewFullCRM()">View Full CRM</button>
      </div>
    `;
  },
  
  // Render pipeline stages
  renderPipelineStages: function(pipeline, opportunities) {
    const stages = ['awareness', 'interest', 'consideration', 'intent', 'evaluation', 'purchase'];
    const stageColors = {
      'awareness': '#gray',
      'interest': '#blue',
      'consideration': '#yellow',
      'intent': '#orange',
      'evaluation': '#purple',
      'purchase': '#green'
    };
    
    return stages.map(stage => {
      const count = pipeline[stage] ? pipeline[stage].length : 0;
      const opps = opportunities.filter(o => o.stage === stage);
      const value = opps.reduce((sum, o) => sum + o.value, 0);
      
      return `
        <div class="pipeline-stage-item">
          <div class="stage-header">
            <span class="stage-name" style="color: ${stageColors[stage]}">${stage.toUpperCase()}</span>
            <span class="stage-count">${count}</span>
          </div>
          <div class="stage-value">$${(value / 1000).toFixed(0)}K</div>
        </div>
      `;
    }).join('');
  },
  
  // Render recent contacts
  renderRecentContacts: function(contacts) {
    if (contacts.length === 0) {
      return '<p class="empty">No contacts yet</p>';
    }
    
    return contacts.map(c => `
      <div class="contact-item">
        <div class="contact-name">${c.firstName} ${c.lastName}</div>
        <div class="contact-company">${c.company}</div>
        <div class="contact-status">${c.status}</div>
      </div>
    `).join('');
  },
  
  // Add new contact
  addContact: function(contact) {
    // This would normally POST to an API
    // For now, we'll just log it
    console.log('Adding contact:', contact);
    alert('Contact added! (Note: In production, this would save to backend)');
  },
  
  // Export CRM data
  exportCRM: function(data) {
    const csv = this.convertToCSV(data.contacts);
    const blob = new Blob([csv], { type: 'text/csv' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'crm-contacts.csv';
    a.click();
    URL.revokeObjectURL(url);
  },
  
  // Convert to CSV
  convertToCSV: function(contacts) {
    if (contacts.length === 0) return '';
    
    const headers = Object.keys(contacts[0]).join(',');
    const rows = contacts.map(c => Object.values(c).join(',')).join('\n');
    
    return `${headers}\n${rows}`;
  }
};

// Global functions
async function refreshCRM() {
  const data = await CRMIntegration.loadCRMData();
  CRMIntegration.renderCRMDashboard(data);
}

function addNewContact() {
  alert('Add Contact form would open here (in production)');
}

function exportCRM() {
  CRMIntegration.loadCRMData().then(data => {
    CRMIntegration.exportCRM(data);
  });
}

function viewFullCRM() {
  alert('Full CRM view would open here (in production)');
}

// Auto-initialize
document.addEventListener('DOMContentLoaded', async () => {
  const crmContainer = document.getElementById('crm-dashboard');
  if (crmContainer) {
    const data = await CRMIntegration.loadCRMData();
    CRMIntegration.renderCRMDashboard(data);
    console.log('✅ CRM Dashboard loaded');
  }
});

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
  module.exports = CRMIntegration;
}

if (typeof window !== 'undefined') {
  window.CRMIntegration = CRMIntegration;
}
