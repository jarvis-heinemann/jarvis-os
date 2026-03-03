// Obsidian Sync - Google Drive Integration
// Syncs Mission Control data to/from Obsidian vaults stored in Google Drive

class ObsidianSync {
  constructor(config = {}) {
    this.vaultPath = config.vaultPath || '~/Google Drive/Obsidian/Mission Control';
    this.syncEnabled = config.syncEnabled !== false;
    this.lastSync = null;
  }

  // ========== INITIALIZATION ==========

  async init() {
    // Check if vault exists
    const vaultExists = await this.checkVaultExists();
    if (!vaultExists) {
      await this.createVaultStructure();
    }
    
    console.log('✅ Obsidian Sync initialized');
    return this;
  }

  async checkVaultExists() {
    // In browser, we'll use File System Access API or prompt user
    // For now, return true and handle dynamically
    return true;
  }

  async createVaultStructure() {
    // Create vault folder structure
    const folders = [
      'Projects',
      'Ideas',
      'Domains',
      'Agents',
      'Tasks',
      'Daily Notes',
      'Templates'
    ];
    
    console.log('📁 Creating vault structure:', folders);
    return folders;
  }

  // ========== EXPORT TO OBSIDIAN ==========

  async exportToObsidian(data) {
    if (!this.syncEnabled) return;

    try {
      // Export each entity type as markdown
      await this.exportProjects(data.projects);
      await this.exportIdeas(data.ideas);
      await this.exportDomains(data.domains);
      await this.exportAgents(data.agents);
      await this.exportTasks(data.tasks);
      await this.exportUserState(data.userState);
      await this.exportDailyNote(data);

      this.lastSync = Date.now();
      console.log('✅ Synced to Obsidian:', new Date().toISOString());
      
      return { success: true, lastSync: this.lastSync };
    } catch (error) {
      console.error('❌ Obsidian sync failed:', error);
      return { success: false, error: error.message };
    }
  }

  async exportProjects(projects) {
    const content = projects.map(p => this.projectToMarkdown(p)).join('\n---\n\n');
    await this.writeFile('Projects/Projects Overview.md', content);
    
    // Export individual projects
    for (const project of projects) {
      await this.writeFile(
        `Projects/${project.name}.md`,
        this.projectToMarkdown(project)
      );
    }
  }

  projectToMarkdown(project) {
    return `# ${project.name}

**Status:** ${project.status}
**Priority:** ${project.priority}/10
**Flagship:** ${project.flagship ? '🚩 Yes' : 'No'}

${project.description ? `## Description\n\n${project.description}\n` : ''}

## Core Loop

${project.coreLoop || '_Not defined yet_'}

## MVU (Minimum Viable Universe)

${project.mvu || '_Not defined yet_'}

## Metadata

- **Created:** ${new Date(project.createdAt).toLocaleDateString()}
- **Updated:** ${new Date(project.updatedAt).toLocaleDateString()}
- **ID:** ${project._id}

---
`;
  }

  async exportIdeas(ideas) {
    const sortedIdeas = ideas.sort((a, b) => b.score - a.score);
    
    const content = `# Ideas Vault

**Total Ideas:** ${ideas.length}

## 🟢 High Priority (7.0+)

${sortedIdeas.filter(i => i.score >= 7).map(i => this.ideaToListItem(i)).join('\n') || '_None yet_'}

## 🟡 Medium Priority (5.0-6.9)

${sortedIdeas.filter(i => i.score >= 5 && i.score < 7).map(i => this.ideaToListItem(i)).join('\n') || '_None yet_'}

## ⚪ Low Priority (<5.0)

${sortedIdeas.filter(i => i.score < 5).map(i => this.ideaToListItem(i)).join('\n') || '_None yet_'}

---

## All Ideas

${ideas.map(i => this.ideaToMarkdown(i)).join('\n---\n\n')}
`;

    await this.writeFile('Ideas/Ideas Overview.md', content);
  }

  ideaToListItem(idea) {
    return `- **${idea.text}** (${idea.score.toFixed(1)}) - ${new Date(idea.createdAt).toLocaleDateString()}`;
  }

  ideaToMarkdown(idea) {
    return `## ${idea.text}

**Score:** ${idea.score.toFixed(1)}/10
**Status:** ${idea.status}
**Created:** ${new Date(idea.createdAt).toLocaleDateString()}

### Scoring Breakdown

| Dimension | Score |
|-----------|-------|
| Impact | ${idea.scores.impact}/10 |
| Leverage | ${idea.scores.leverage}/10 |
| Momentum | ${idea.scores.momentum}/10 |
| Excitement | ${idea.scores.excitement}/10 |
| Ease | ${idea.scores.ease}/10 |
| Revenue | ${idea.scores.revenue}/10 |
| Strategic Fit | ${idea.scores.strategic}/10 |
| Automation | ${idea.scores.automation}/10 |

${idea.linkedProject ? `**Linked Project:** [[${idea.linkedProject}]]` : ''}
`;
  }

  async exportDomains(domains) {
    const byStatus = {
      active: domains.filter(d => d.status === 'active' || d.status === 'in-use'),
      parked: domains.filter(d => d.status === 'parked'),
      forSale: domains.filter(d => d.status === 'for-sale'),
    };

    const content = `# Domain Portfolio

**Total:** ${domains.length}

## Stats

- **Active/In-Use:** ${byStatus.active.length}
- **Parked:** ${byStatus.parked.length}
- **For Sale:** ${byStatus.forSale.length}

## 🟢 Active Domains

${byStatus.active.map(d => `- ${d.domain}`).join('\n') || '_None_'}

## 🟡 Parked Domains

${byStatus.parked.slice(0, 50).map(d => `- ${d.domain}`).join('\n')}
${byStatus.parked.length > 50 ? `\n_...and ${byStatus.parked.length - 50} more_` : ''}

## 🔵 For Sale

${byStatus.forSale.map(d => `- ${d.domain}`).join('\n') || '_None_'}

---

## All Domains

${domains.map(d => `- [[${d.domain}]] (${d.status})`).join('\n')}
`;

    await this.writeFile('Domains/Domain Portfolio.md', content);
  }

  async exportAgents(agents) {
    const content = `# AI Agent Registry

**Total Agents:** ${agents.length}

## By Type

${this.groupBy(agents, 'type').map(([type, items]) => 
  `### ${type} (${items.length})\n\n${items.map(a => `- **${a.name}** (${a.status})`).join('\n')}`
).join('\n\n')}

## By Status

${this.groupBy(agents, 'status').map(([status, items]) => 
  `### ${status} (${items.length})\n\n${items.map(a => `- ${a.name}`).join('\n')}`
).join('\n\n')}

---

## All Agents

${agents.map(a => this.agentToMarkdown(a)).join('\n---\n\n')}
`;

    await this.writeFile('Agents/Agent Registry.md', content);
  }

  agentToMarkdown(agent) {
    return `## ${agent.name}

**Type:** ${agent.type}
**Status:** ${agent.status}
**Runs:** ${agent.runsCount}
**Created:** ${new Date(agent.createdAt).toLocaleDateString()}

${agent.description ? `${agent.description}\n` : ''}
`;
  }

  async exportTasks(tasks) {
    const incomplete = tasks.filter(t => !t.completed);
    const complete = tasks.filter(t => t.completed);

    const content = `# Tasks

**Incomplete:** ${incomplete.length}
**Completed:** ${complete.length}

## 🔥 Active Tasks

${incomplete.map(t => `- [ ] ${t.text} (_${t.assignee}_)`).join('\n') || '_None_'}

## ✅ Completed

${complete.slice(0, 20).map(t => `- [x] ${t.text}`).join('\n') || '_None_'}

${complete.length > 20 ? `\n_...and ${complete.length - 20} more completed_` : ''}
`;

    await this.writeFile('Tasks/Tasks.md', content);
  }

  async exportUserState(state) {
    if (!state) return;

    const content = `# Mission Control State

**Last Updated:** ${new Date().toLocaleString()}

## Flagship

${state.flagship || '_Not selected_'}

## Active Seed (MVU)

${state.activeSeed ? `
**${state.activeSeed.text}**
Started: ${new Date(state.activeSeed.startedAt).toLocaleDateString()}
` : '_None_'}

## Today's Focus

${state.todayTask ? `
**${state.todayTask.text}**
Date: ${state.todayTask.date}
` : '_Not set_'}

## Energy Level

${state.energyLevel ? `${state.energyLevel}/4` : '_Not tracked_}
`;

    await this.writeFile('Mission Control State.md', content);
  }

  async exportDailyNote(data) {
    const today = new Date().toISOString().split('T')[0];
    const content = `# ${today}

## Focus

**Flagship:** ${data.userState?.flagship || '_Not selected_'}
**Seed:** ${data.userState?.activeSeed?.text || '_None_'}
**Today's Task:** ${data.userState?.todayTask?.text || '_Not set_'}

## Ideas Captured Today

${data.ideas.filter(i => {
  const ideaDate = new Date(i.createdAt).toISOString().split('T')[0];
  return ideaDate === today;
}).map(i => `- ${i.text} (${i.score.toFixed(1)})`).join('\n') || '_None_'}

## Tasks Completed Today

${data.tasks.filter(t => t.completed && t.completedAt && 
  new Date(t.completedAt).toISOString().split('T')[0] === today
).map(t => `- ✅ ${t.text}`).join('\n') || '_None_'}

## Notes

_Write your daily notes here..._

---

**Synced from Mission Control:** ${new Date().toLocaleString()}
`;

    await this.writeFile(`Daily Notes/${today}.md`, content);
  }

  // ========== IMPORT FROM OBSIDIAN ==========

  async importFromObsidian() {
    // Read markdown files and parse back to JSON
    // This would require file system access or user upload
    
    console.log('📥 Import from Obsidian requires file access');
    return { 
      success: false, 
      message: 'Manual import required - use file upload or File System Access API' 
    };
  }

  // ========== HELPERS ==========

  groupBy(array, key) {
    return Object.entries(array.reduce((groups, item) => {
      const value = item[key] || 'unknown';
      groups[value] = groups[value] || [];
      groups[value].push(item);
      return groups;
    }, {}));
  }

  async writeFile(path, content) {
    // In a browser environment, this would use:
    // 1. File System Access API (Chrome/Edge)
    // 2. Google Drive API
    // 3. Download as file
    
    console.log(`📝 Would write to: ${path}`);
    console.log(`   Size: ${content.length} bytes`);
    
    // For now, store in memory/localStorage for later export
    const key = `obsidian_${path}`;
    try {
      localStorage.setItem(key, content);
    } catch (e) {
      console.warn('localStorage full, would need to download');
    }
    
    return true;
  }

  // ========== GOOGLE DRIVE SYNC ==========

  async syncWithGoogleDrive() {
    // This would use Google Drive API
    // Requires OAuth setup
    
    console.log('🔄 Google Drive sync requires OAuth setup');
    return {
      success: false,
      message: 'Google Drive sync requires authentication setup'
    };
  }

  // ========== EXPORT ALL ==========

  downloadVault() {
    // Package all Obsidian files as a zip for download
    const files = {};
    
    // Collect all files from localStorage
    for (let i = 0; i < localStorage.length; i++) {
      const key = localStorage.key(i);
      if (key.startsWith('obsidian_')) {
        files[key.replace('obsidian_', '')] = localStorage.getItem(key);
      }
    }
    
    console.log('📦 Vault ready for download:', Object.keys(files));
    return files;
  }
}

// Export for use in app
window.ObsidianSync = ObsidianSync;
