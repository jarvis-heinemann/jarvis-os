// Affiliate Marketing Engine - AI-Powered Ad Generation & Scaling
// Based on interview insights - 111 Method

const AffiliateEngine = {
  
  config: {
    // Ad Generation
    adGeneration: {
      platform: 'OpenArt.AI',
      models: ['Nano Banana', 'ChatGPT', 'Flux'],
      costPerImage: 0.08,
      batchSize: 500, // prompts per run
      overnight: true, // Generate overnight
      
      automation: {
        platform: 'N8N',
        hosting: 'Digital Ocean',
        specs: '8GB RAM',
        costPerMonth: 40
      }
    },
    
    // 111 Scaling Method
    scalingMethod: {
      name: '111 Method',
      structure: {
        campaigns: 10,
        adsetsPerCampaign: 50,
        adsPerAdset: 1
      },
      totalAds: 500, // 10 × 50 × 1
      
      bitCap: {
        daily: 200, // $200/day max spend
        autoScale: true,
        scaleTrigger: 'profitable'
      }
    },
    
    // Testing Protocol
    testing: {
      creativeBudget: 30, // $30 per creative (if payout $20)
      totalTestBudget: 600, // $600 total
      killWindow: 3, // days
      maxLossPercent: 0.30, // 30% max loss
      
      rules: {
        'kill-if': 'no conversions after 3 days',
        'scale-if': 'ROI > 100% for 2 days',
        'maintain-if': 'ROI 20-100%'
      }
    },
    
    // Platform Stack
    platforms: {
      primary: {
        name: 'Facebook',
        format: '9:16 vertical',
        audienceSize: 'broad (no targeting)',
        optimization: 'Conversions'
      },
      secondary: {
        name: 'TikTok',
        format: '9:16 vertical',
        audienceSize: 'broad',
        optimization: 'Conversions'
      }
    },
    
    // Spy Tools
    spyTools: {
      adPlexity: {
        name: 'AdPlexity (Facebook)',
        cost: 199, // per month
        purpose: 'Competitor ad research',
        features: ['Ad library', 'Performance data', 'Landing pages']
      },
      foreplay: {
        name: 'Foreplay',
        cost: 49, // per month
        purpose: 'Creative analysis',
        features: ['Ad breakdown', 'Hook analysis', 'Script extraction']
      }
    },
    
    // Copywriting System
    copywriting: {
      claudeSkill: {
        trainedOn: ['VSLs', 'Marketing books', 'High-converting ads'],
        frameworks: ['136 emotions', 'AIDA', 'PAS'],
        features: ['Auto-rewrite headlines', 'Hook generation', 'CTA optimization']
      },
      
      hooks: [
        'If you\'re [persona], stop scrolling',
        '[Counter-intuitive statement]',
        '[Specific number] [timeframe] [result]',
        'I [embarrassing admission], but [unexpected win]',
        '[Authority figure] doesn\'t want you to know this',
        'This [product] saved my [painful situation]',
        '[Question that hits pain point]',
        '[Bold promise] without [common objection]'
      ],
      
      emotions: [
        'Curiosity', 'Fear', 'Greed', 'Vanity', 'Laziness',
        'Guilt', 'Pride', 'Envy', 'Hope', 'Urgency',
        'Exclusivity', 'Nostalgia', 'Anger', 'Love', 'Security'
        // ... 121 more in full framework
      ]
    }
    
  },
  
  // ==================== CAMPAIGN STRUCTURES ====================
  
  campaigns: [
    {
      id: 'campaign-001',
      name: 'ClaimHaus - Debt Buyers',
      vertical: 'Finance',
      offer: 'Distressed debt platform',
      payout: 50, // per conversion
      status: 'ready',
      creatives: {
        generated: 0,
        testing: 0,
        scaling: 0,
        killed: 0
      },
      metrics: {
        spend: 0,
        revenue: 0,
        roi: 0,
        conversions: 0
      }
    },
    {
      id: 'campaign-002',
      name: 'Ignis - Fire Departments',
      vertical: 'Robotics',
      offer: 'Fire rescue robotics pilot',
      payout: 200, // per qualified lead
      status: 'ready',
      creatives: {
        generated: 0,
        testing: 0,
        scaling: 0,
        killed: 0
      },
      metrics: {
        spend: 0,
        revenue: 0,
        roi: 0,
        conversions: 0
      }
    },
    {
      id: 'campaign-003',
      name: 'Saybrook - Manufacturing CFOs',
      vertical: 'Services',
      offer: 'Procurement savings audit',
      payout: 100, // per qualified lead
      status: 'ready',
      creatives: {
        generated: 0,
        testing: 0,
        scaling: 0,
        killed: 0
      },
      metrics: {
        spend: 0,
        revenue: 0,
        roi: 0,
        conversions: 0
      }
    },
    {
      id: 'campaign-004',
      name: 'HeinemannCapital - Wealth Managers',
      vertical: 'Capital',
      offer: 'Real estate income fund allocation',
      payout: 500, // per qualified investor
      status: 'ready',
      creatives: {
        generated: 0,
        testing: 0,
        scaling: 0,
        killed: 0
      },
      metrics: {
        spend: 0,
        revenue: 0,
        roi: 0,
        conversions: 0
      }
    },
    {
      id: 'campaign-005',
      name: 'GraphNative - Tech CTOs',
      vertical: 'Platform',
      offer: 'AI governance demo',
      payout: 150, // per demo booking
      status: 'ready',
      creatives: {
        generated: 0,
        testing: 0,
        scaling: 0,
        killed: 0
      },
      metrics: {
        spend: 0,
        revenue: 0,
        roi: 0,
        conversions: 0
      }
    }
  ],
  
  // ==================== CREATIVE GENERATION WORKFLOW ====================
  
  creativeWorkflow: {
    
    step1_generatePrompts: function(campaignId, count = 500) {
      // Generate 500 prompts for overnight batch
      const prompts = [];
      const campaign = this.campaigns.find(c => c.id === campaignId);
      
      // Mix hooks × angles × emotions
      for (let i = 0; i < count; i++) {
        const hook = this.config.copywriting.hooks[i % this.config.copywriting.hooks.length];
        const emotion = this.config.copywriting.emotions[i % this.config.copywriting.emotions.length];
        
        prompts.push({
          id: `${campaignId}-${i}`,
          hook: hook,
          emotion: emotion,
          angle: `${campaign.offer} - ${emotion} angle`,
          prompt: `Generate 9:16 vertical ad creative: ${hook}, emotion: ${emotion}, product: ${campaign.offer}`
        });
      }
      
      return prompts;
    },
    
    step2_generateCreatives: function(prompts) {
      // Export to spreadsheet for overnight generation
      const csv = prompts.map(p => `${p.id},${p.prompt},${p.hook},${p.emotion}`).join('\n');
      
      return {
        format: 'CSV',
        destination: 'Google Sheets',
        platform: 'OpenArt.AI',
        cost: prompts.length * this.config.adGeneration.costPerImage,
        estimatedTime: '8 hours overnight'
      };
    },
    
    step3_uploadCreatives: function(creatives) {
      // Upload to ad platforms
      return {
        facebook: creatives.length,
        tiktok: creatives.length,
        structure: '111 Method (10 campaigns × 50 adsets × 1 ad)'
      };
    },
    
    step4_testPhase: function() {
      // First 3 days - kill or keep
      return {
        budget: this.config.testing.totalTestBudget,
        duration: `${this.config.testing.killWindow} days`,
        dailyBudget: this.config.testing.totalTestBudget / this.config.testing.killWindow,
        rules: this.config.testing.rules
      };
    },
    
    step5_scaleWinners: function(winningCreatives) {
      // Scale profitable creatives
      return {
        bitCap: this.config.scalingMethod.bitCap.daily,
        autoScale: this.config.scalingMethod.bitCap.autoScale,
        maxSpend: `${this.config.scalingMethod.bitCap.daily * 30}/month`
      };
    }
    
  },
  
  // ==================== AUTOMATION RULES ====================
  
  automationRules: {
    
    dailyOptimization: {
      schedule: '0 8 * * *', // 8 AM daily
      tasks: [
        'Check ROI for all active creatives',
        'Kill creatives below threshold (3-day window)',
        'Scale creatives with ROI > 100%',
        'Generate new creative variations for winners',
        'Update campaign budgets'
      ]
    },
    
    creativeGeneration: {
      schedule: '0 22 * * 0', // 10 PM Sundays
      tasks: [
        'Analyze top performers from past week',
        'Generate 500 new prompts based on winners',
        'Submit batch to OpenArt.AI',
        'Creatives ready by Monday 6 AM'
      ]
    },
    
    spyCompetitors: {
      schedule: '0 9 * * 1', // 9 AM Mondays
      tasks: [
        'Scan AdPlexity for new competitor ads',
        'Analyze creative angles with Foreplay',
        'Extract winning hooks and scripts',
        'Add to creative brief for next batch'
      ]
    }
    
  },
  
  // ==================== KPIs ====================
  
  kpis: {
    
    daily: {
      'spend': 0,
      'revenue': 0,
      'profit': 0,
      'roi': 0,
      'conversions': 0,
      'costPerConversion': 0,
      'clickThroughRate': 0,
      'conversionRate': 0
    },
    
    weekly: {
      'totalSpend': 0,
      'totalRevenue': 0,
      'totalProfit': 0,
      'averageROI': 0,
      'creativesTested': 0,
      'creativesScaled': 0,
      'creativesKilled': 0,
      'newCreativesGenerated': 0
    },
    
    monthly: {
      'totalSpend': 0,
      'totalRevenue': 0,
      'totalProfit': 0,
      'campaignsLaunched': 0,
      'shellsMonetized': 0,
      'costPerShell': 0
    },
    
    targets: {
      'monthlyProfit': 10000,
      'averageROI': 150, // 150% ROI
      'conversionsPerDay': 10,
      'costPerConversion': 20
    }
    
  },
  
  // ==================== STATUS ====================
  
  getStatus: function() {
    return {
      campaigns: {
        total: this.campaigns.length,
        ready: this.campaigns.filter(c => c.status === 'ready').length,
        active: this.campaigns.filter(c => c.status === 'active').length,
        paused: this.campaigns.filter(c => c.status === 'paused').length
      },
      creatives: {
        total: this.campaigns.reduce((sum, c) => sum + c.creatives.generated, 0),
        testing: this.campaigns.reduce((sum, c) => sum + c.creatives.testing, 0),
        scaling: this.campaigns.reduce((sum, c) => sum + c.creatives.scaling, 0)
      },
      costs: {
        adSpend: this.campaigns.reduce((sum, c) => sum + c.metrics.spend, 0),
        tools: this.config.spyTools.adPlexity.cost + this.config.spyTools.foreplay.cost,
        automation: this.config.adGeneration.automation.costPerMonth,
        totalMonthly: 0 // calculated
      },
      revenue: {
        total: this.campaigns.reduce((sum, c) => sum + c.metrics.revenue, 0),
        profit: 0 // calculated
      }
    };
  }
  
};

// Calculate totals
const status = AffiliateEngine.getStatus();
AffiliateEngine.kpis.monthly.totalSpend = status.costs.adSpend + status.costs.tools + status.costs.automation;
AffiliateEngine.kpis.monthly.totalRevenue = status.revenue.total;
AffiliateEngine.kpis.monthly.totalProfit = status.revenue.total - status.costs.adSpend;

// Export
if (typeof module !== 'undefined' && module.exports) {
  module.exports = AffiliateEngine;
}

if (typeof window !== 'undefined') {
  window.AffiliateEngine = AffiliateEngine;
}

console.log('💰 Affiliate Engine loaded');
console.log('📊 Campaigns:', AffiliateEngine.campaigns.length, 'ready');
console.log('🎯 111 Method configured (10 × 50 × 1 = 500 ads)');
console.log('💵 Target: $10K/month profit');
