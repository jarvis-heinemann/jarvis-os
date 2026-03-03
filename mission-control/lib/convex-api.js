// Convex API - Browser Client
// Auto-generated configuration

const CONVEX_URL = "https://aromatic-basilisk-680.convex.cloud";
const CONVEX_SITE = "https://aromatic-basilisk-680.convex.site";

// Convex client wrapper for Mission Control
class ConvexAPI {
  constructor() {
    this.client = null;
    this.connected = false;
  }

  async init() {
    if (typeof Convex === 'undefined') {
      console.warn('Convex library not loaded');
      return false;
    }

    try {
      this.client = new Convex.ConvexClient(CONVEX_URL);
      this.connected = true;
      console.log('✅ Connected to Convex:', CONVEX_URL);
      return true;
    } catch (error) {
      console.error('❌ Convex connection failed:', error);
      return false;
    }
  }

  // ========== PROJECTS ==========

  async createProject(data) {
    return await this.client.mutation('createProject', data);
  }

  async listProjects(userId) {
    return await this.client.query('listProjects', { userId });
  }

  async updateProject(id, updates) {
    return await this.client.mutation('updateProject', { id, ...updates });
  }

  // ========== IDEAS ==========

  async createIdea(data) {
    return await this.client.mutation('createIdea', data);
  }

  async listIdeas(userId) {
    return await this.client.query('listIdeas', { userId });
  }

  // ========== REPOS ==========

  async syncRepos(repos, userId) {
    return await this.client.mutation('syncRepos', { repos, userId });
  }

  async listRepos(userId) {
    return await this.client.query('listRepos', { userId });
  }

  // ========== DOMAINS ==========

  async syncDomains(domains, userId) {
    return await this.client.mutation('syncDomains', { domains, userId });
  }

  async listDomains(userId) {
    return await this.client.query('listDomains', { userId });
  }

  // ========== USER STATE ==========

  async getUserState(userId) {
    return await this.client.query('getUserState', { userId });
  }

  async updateUserState(userId, updates) {
    return await this.client.mutation('updateUserState', { userId, ...updates });
  }

  // ========== FULL SYNC ==========

  async getFullSync(userId) {
    return await this.client.query('getFullSync', { userId });
  }

  // ========== SUBSCRIPTIONS ==========

  subscribeToProjects(userId, callback) {
    return this.client.onUpdate(
      this.client.query('listProjects', { userId }),
      callback
    );
  }

  subscribeToIdeas(userId, callback) {
    return this.client.onUpdate(
      this.client.query('listIdeas', { userId }),
      callback
    );
  }
}

// Export
window.ConvexAPI = ConvexAPI;
window.CONVEX_URL = CONVEX_URL;
