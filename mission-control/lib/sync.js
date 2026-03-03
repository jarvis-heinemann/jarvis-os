// Mission Control - Convex Integration Layer
// Syncs between localStorage, Convex, and Obsidian

class MissionControlSync {
  constructor() {
    this.convex = null; // Will be initialized with Convex client
    this.obsidian = null; // Will be initialized with ObsidianSync
    this.userId = this.getUserId();
    this.syncInterval = null;
    this.isOnline = navigator.onLine;
    
    this.init();
  }

  // ========== INITIALIZATION ==========

  getUserId() {
    // Get or create user ID
    let userId = localStorage.getItem('missionControlUserId');
    if (!userId) {
      userId = 'user_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
      localStorage.setItem('missionControlUserId', userId);
    }
    return userId;
  }

  async init() {
    // Initialize Obsidian sync
    if (window.ObsidianSync) {
      this.obsidian = new window.ObsidianSync({
        vaultPath: this.getObsidianPath(),
        syncEnabled: true
      });
      await this.obsidian.init();
    }

    // Listen for online/offline
    window.addEventListener('online', () => {
      this.isOnline = true;
      this.sync();
    });
    
    window.addEventListener('offline', () => {
      this.isOnline = false;
    });

    // Auto-sync every 5 minutes when online
    this.syncInterval = setInterval(() => {
      if (this.isOnline) {
        this.sync();
      }
    }, 5 * 60 * 1000);

    console.log('✅ Mission Control Sync initialized');
  }

  getObsidianPath() {
    // Default Google Drive path for Obsidian
    return localStorage.getItem('obsidianPath') || 
           '~/Google Drive/Obsidian/Mission Control';
  }

  setObsidianPath(path) {
    localStorage.setItem('obsidianPath', path);
    if (this.obsidian) {
      this.obsidian.vaultPath = path;
    }
  }

  // ========== CONVEX SYNC ==========

  async initConvex(convexClient) {
    this.convex = convexClient;
    console.log('✅ Convex client connected');
    
    // Initial sync
    await this.syncFromConvex();
  }

  async syncFromConvex() {
    if (!this.convex || !this.isOnline) return;

    try {
      const remoteData = await this.convex.query('getFullSync', { 
        userId: this.userId 
      });

      if (remoteData) {
        // Merge with local data
        this.mergeData(remoteData);
        console.log('✅ Synced from Convex');
      }
    } catch (error) {
      console.error('❌ Convex sync failed:', error);
    }
  }

  async syncToConvex(data) {
    if (!this.convex || !this.isOnline) return;

    try {
      // Sync each entity type
      if (data.projects) {
        // TODO: Batch sync projects
      }
      
      if (data.repos) {
        await this.convex.mutation('syncRepos', {
          repos: data.repos,
          userId: this.userId
        });
      }

      if (data.domains) {
        await this.convex.mutation('syncDomains', {
          domains: data.domains,
          userId: this.userId
        });
      }

      if (data.userState) {
        await this.convex.mutation('updateUserState', {
          userId: this.userId,
          ...data.userState
        });
      }

      console.log('✅ Synced to Convex');
    } catch (error) {
      console.error('❌ Convex sync failed:', error);
    }
  }

  // ========== OBSIDIAN SYNC ==========

  async syncToObsidian(data) {
    if (!this.obsidian) return;

    try {
      await this.obsidian.exportToObsidian(data);
      console.log('✅ Synced to Obsidian');
    } catch (error) {
      console.error('❌ Obsidian sync failed:', error);
    }
  }

  async downloadVault() {
    if (this.obsidian) {
      return this.obsidian.downloadVault();
    }
    return null;
  }

  // ========== HYBRID SYNC ==========

  async sync() {
    // Get local data
    const localData = this.getLocalData();

    // Sync to Convex (if online)
    if (this.convex && this.isOnline) {
      await this.syncToConvex(localData);
    }

    // Sync to Obsidian (local)
    await this.syncToObsidian(localData);

    // Update sync timestamp
    localStorage.setItem('lastSync', Date.now().toString());

    console.log('🔄 Full sync complete');
  }

  getLocalData() {
    try {
      const data = localStorage.getItem('missionControlState');
      return data ? JSON.parse(data) : {};
    } catch {
      return {};
    }
  }

  mergeData(remoteData) {
    const localData = this.getLocalData();
    
    // Merge strategy: remote wins for conflicts
    const merged = {
      ...localData,
      ...remoteData,
      lastMerge: Date.now()
    };

    // Save merged data
    localStorage.setItem('missionControlState', JSON.stringify(merged));

    // Trigger UI update
    window.dispatchEvent(new CustomEvent('dataMerged', { detail: merged }));
  }

  // ========== MANUAL TRIGGERS ==========

  async forceSyncAll() {
    console.log('🔄 Force syncing all data...');
    await this.sync();
    return { success: true, timestamp: Date.now() };
  }

  async exportAllFormats() {
    const data = this.getLocalData();
    
    // Export for Convex
    const convexExport = JSON.stringify(data, null, 2);
    
    // Export for Obsidian
    const obsidianFiles = await this.downloadVault();
    
    // Export as JSON backup
    const jsonBackup = JSON.stringify({
      ...data,
      exportedAt: Date.now(),
      version: '2.0'
    }, null, 2);

    return {
      convex: convexExport,
      obsidian: obsidianFiles,
      json: jsonBackup
    };
  }

  // ========== STATUS ==========

  getSyncStatus() {
    return {
      convex: this.convex ? 'connected' : 'not configured',
      obsidian: this.obsidian ? 'ready' : 'not initialized',
      online: this.isOnline,
      lastSync: localStorage.getItem('lastSync'),
      userId: this.userId
    };
  }
}

// Export
window.MissionControlSync = MissionControlSync;
