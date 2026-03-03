// GTM Launchpad - Ready-to-Deploy Sales Infrastructure
// Generated: 2026-02-18 6:45 AM

const GTMLaunchpad = {
  
  // ==================== TAM LISTS ====================
  
  tamLists: {
    
    ClaimHaus: {
      vertical: 'Distressed Debt',
      targetBuyers: ['Debt Buyers', 'Portfolio Managers', 'Collections Directors'],
      totalAddressable: 2500,
      scored: 0,
      priorityAccounts: [
        { company: 'Sherman Financial Group', type: 'Debt Buyer', size: '$1B+', priority: 1 },
        { company: 'Encore Capital Group', type: 'Debt Buyer', size: '$1B+', priority: 1 },
        { company: 'Portfolio Recovery Associates', type: 'Debt Buyer', size: '$1B+', priority: 1 },
        { company: 'Astreya', type: 'Collections', size: '$500M+', priority: 2 },
        { company: 'IC System', type: 'Collections', size: '$100M+', priority: 2 },
        { company: 'Midland Credit Management', type: 'Debt Buyer', size: '$500M+', priority: 1 },
        { company: 'Cavalry SPV I', type: 'Debt Buyer', size: '$250M+', priority: 2 },
        { company: 'Atlantic Credit & Finance', type: 'Debt Buyer', size: '$100M+', priority: 2 },
        { company: 'Resurgent Capital', type: 'Debt Buyer', size: '$100M+', priority: 2 },
        { company: 'Kansas City Credit Group', type: 'Collections', size: '$50M+', priority: 3 }
      ],
      signals: ['portfolio purchases', 'distressed debt activity', 'compliance needs'],
      outboundStrategy: 'AI-Teammate approach - automated qualification + human close'
    },
    
    Ignis: {
      vertical: 'Fire/Rescue Robotics',
      targetBuyers: ['Fire Chiefs', 'Emergency Managers', 'Safety Directors'],
      totalAddressable: 1800,
      scored: 0,
      priorityAccounts: [
        { company: 'Los Angeles Fire Department', type: 'Municipal', size: '$500M budget', priority: 1 },
        { company: 'New York Fire Department', type: 'Municipal', size: '$1B budget', priority: 1 },
        { company: 'Chicago Fire Department', type: 'Municipal', size: '$400M budget', priority: 1 },
        { company: 'Houston Fire Department', type: 'Municipal', size: '$300M budget', priority: 2 },
        { company: 'Phoenix Fire Department', type: 'Municipal', size: '$200M budget', priority: 2 },
        { company: 'CAL FIRE', type: 'State Agency', size: '$1B budget', priority: 1 },
        { company: 'Texas A&M Forest Service', type: 'State Agency', size: '$200M budget', priority: 2 },
        { company: 'Miami-Dade Fire Rescue', type: 'County', size: '$400M budget', priority: 2 },
        { company: 'Seattle Fire Department', type: 'Municipal', size: '$200M budget', priority: 2 },
        { company: 'Denver Fire Department', type: 'Municipal', size: '$150M budget', priority: 3 }
      ],
      signals: ['budget increases', 'new equipment RFPs', 'wildfire season prep'],
      outboundStrategy: 'Custom-agents approach - demo-driven sales cycle'
    },
    
    Saybrook: {
      vertical: 'Procurement Savings',
      targetBuyers: ['CFOs', 'Finance Directors', 'Procurement Officers'],
      totalAddressable: 5000,
      scored: 0,
      priorityAccounts: [
        { company: 'General Motors', type: 'Manufacturing', size: '$150B+', priority: 1 },
        { company: 'Ford Motor Company', type: 'Manufacturing', size: '$150B+', priority: 1 },
        { company: 'Boeing', type: 'Aerospace', size: '$75B+', priority: 1 },
        { company: 'Caterpillar', type: 'Manufacturing', size: '$50B+', priority: 2 },
        { company: '3M', type: 'Manufacturing', size: '$35B+', priority: 2 },
        { company: 'Honeywell', type: 'Manufacturing', size: '$35B+', priority: 2 },
        { company: 'United Technologies', type: 'Conglomerate', size: '$75B+', priority: 1 },
        { company: 'Deere & Company', type: 'Manufacturing', size: '$50B+', priority: 2 },
        { company: 'Cummins', type: 'Manufacturing', size: '$25B+', priority: 2 },
        { company: 'Eaton', type: 'Manufacturing', size: '$20B+', priority: 3 }
      ],
      signals: ['cost reduction initiatives', 'vendor reviews', 'budget pressures'],
      outboundStrategy: 'Source-of-truth approach - ROI calculator + case studies'
    },
    
    HeinemannCapital: {
      vertical: 'Real Estate Income Fund',
      targetBuyers: ['Family Offices', 'Allocators', 'RIAs'],
      totalAddressable: 3000,
      scored: 0,
      priorityAccounts: [
        { company: 'Morgan Stanley Wealth Management', type: 'Wealth Management', size: '$4T AUM', priority: 1 },
        { company: 'Merrill Lynch', type: 'Wealth Management', size: '$3T AUM', priority: 1 },
        { company: 'UBS Wealth Management', type: 'Wealth Management', size: '$3T AUM', priority: 1 },
        { company: 'Northern Trust', type: 'Wealth Management', size: '$1.5T AUM', priority: 2 },
        { company: 'BNY Mellon Wealth Management', type: 'Wealth Management', size: '$2T AUM', priority: 2 },
        { company: 'Cambridge Associates', type: 'Investment Consultant', size: '$500B advisory', priority: 1 },
        { company: 'Callan', type: 'Investment Consultant', size: '$300B advisory', priority: 2 },
        { company: 'Mercer', type: 'Investment Consultant', size: '$400B advisory', priority: 2 },
        { company: 'Wilshire', type: 'Investment Consultant', size: '$200B advisory', priority: 2 },
        { company: 'Aksia', type: 'Investment Consultant', size: '$150B advisory', priority: 3 }
      ],
      signals: ['fund searches', 'allocation changes', 'real estate focus'],
      outboundStrategy: 'AI-Teammate approach - relationship-based capital raise'
    },
    
    GraphNative: {
      vertical: 'Graph AI Governance',
      targetBuyers: ['CTOs', 'VP Engineering', 'Platform Architects'],
      totalAddressable: 4000,
      scored: 0,
      priorityAccounts: [
        { company: 'OpenAI', type: 'AI Lab', size: '$80B valuation', priority: 1 },
        { company: 'Anthropic', type: 'AI Lab', size: '$50B valuation', priority: 1 },
        { company: 'Google DeepMind', type: 'AI Lab', size: '$1T+ parent', priority: 1 },
        { company: 'Microsoft AI', type: 'Tech Giant', size: '$3T market cap', priority: 1 },
        { company: 'Meta AI', type: 'Tech Giant', size: '$1T market cap', priority: 1 },
        { company: 'NVIDIA', type: 'Chipmaker', size: '$2T market cap', priority: 1 },
        { company: 'Databricks', type: 'Data Platform', size: '$43B valuation', priority: 2 },
        { company: 'Snowflake', type: 'Data Platform', size: '$60B market cap', priority: 2 },
        { company: 'Scale AI', type: 'Data Labeling', size: '$7B valuation', priority: 2 },
        { company: 'Hugging Face', type: 'AI Platform', size: '$4.5B valuation', priority: 2 }
      ],
      signals: ['AI governance needs', 'agent deployments', 'compliance requirements'],
      outboundStrategy: 'Hybrid approach - technical proof-of-concept + enterprise sales'
    }
    
  },
  
  // ==================== OUTBOUND SEQUENCES ====================
  
  sequences: {
    
    'pilot-introduction': {
      name: 'Pilot Introduction',
      targetPhase: 'Phase 2 - Design Partner',
      steps: [
        {
          day: 0,
          type: 'email',
          subject: 'Quick question about [pain point]',
          template: `Hi [First Name],

I noticed [company-specific observation/pain point].

We've built [product] specifically for [use case] - companies like [similar company] are seeing [specific result].

Would you be open to a 15-minute pilot discussion?

[Signature]`
        },
        {
          day: 3,
          type: 'email',
          subject: 'RE: Quick question',
          template: `Hi [First Name],

Just following up - we recently helped [similar company] achieve [specific metric] in [timeframe].

Worth a quick call?

[Signature]`
        },
        {
          day: 7,
          type: 'email',
          subject: 'Case study for [company]',
          template: `Hi [First Name],

Thought you'd find this interesting - [case study link showing ROI].

If [specific pain point] is on your radar, I can show you how we solved it.

[Signature]`
        },
        {
          day: 14,
          type: 'email',
          subject: 'Last try?',
          template: `Hi [First Name],

I'll stop reaching out after this, but wanted to mention we have [limited pilot spots / deadline] coming up.

If timing is better in Q[X], happy to reconnect then.

[Signature]`
        }
      ]
    },
    
    'investor-introduction': {
      name: 'Investor Introduction',
      targetPhase: 'Fundraising',
      steps: [
        {
          day: 0,
          type: 'email',
          subject: '[Fund Name] - [Unique Angle]',
          template: `Hi [First Name],

I'm reaching out because [specific reason they're relevant].

[Fund Name] is [1-sentence description] with [key differentiator].

Our track record: [specific returns/metrics].

Would you be open to learning more?

[Signature]`
        },
        {
          day: 5,
          type: 'email',
          subject: 'RE: [Fund Name]',
          template: `Hi [First Name],

Quick follow-up with some recent portfolio metrics:

- [Metric 1]
- [Metric 2]
- [Metric 3]

Happy to share our deck if helpful.

[Signature]`
        },
        {
          day: 12,
          type: 'email',
          subject: 'Market thesis: [Specific Angle]',
          template: `Hi [First Name],

Here's our current market thesis on [specific opportunity]:

[2-3 bullet points on market dynamics]

We're positioning [Fund Name] to capture this by [strategy].

Worth a deeper conversation?

[Signature]`
        },
        {
          day: 21,
          type: 'email',
          subject: 'Final check-in',
          template: `Hi [First Name],

Last reach-out - if [specific investment focus] isn't a fit right now, I completely understand.

Happy to reconnect when timing aligns.

[Signature]`
        }
      ]
    },
    
    'enterprise-demo': {
      name: 'Enterprise Demo Request',
      targetPhase: 'Phase 2-3 - Pilot/Deployment',
      steps: [
        {
          day: 0,
          type: 'email',
          subject: '[Product] demo for [company]',
          template: `Hi [First Name],

I'd love to show you [product] in action.

[Company] could use it for [specific use case] - similar teams at [reference customer] are seeing [specific results].

Can I steal 20 minutes for a live demo?

[Signature]`
        },
        {
          day: 2,
          type: 'email',
          subject: 'RE: demo',
          template: `Hi [First Name],

Just circling back - happy to do a custom demo tailored to [company]'s [specific need].

Works with your schedule.

[Signature]`
        },
        {
          day: 5,
          type: 'email',
          subject: '[Specific feature] for [team]',
          template: `Hi [First Name],

One more thing - we just shipped [new feature] that's particularly relevant for [specific use case at their company].

Demo?

[Signature]`
        }
      ]
    }
    
  },
  
  // ==================== CRM STRUCTURE ====================
  
  crmStructure: {
    
    contactFields: [
      'firstName',
      'lastName',
      'email',
      'title',
      'company',
      'linkedinUrl',
      'phone',
      'shell', // Which shell this contact belongs to
      'status', // lead, qualified, opportunity, customer, churned
      'source', // LinkedIn, referral, cold outbound, event
      'owner', // Who owns this relationship
      'lastContact',
      'nextFollowUp',
      'notes'
    ],
    
    opportunityFields: [
      'company',
      'shell',
      'stage', // awareness, interest, consideration, intent, evaluation, purchase
      'value',
      'probability',
      'closeDate',
      'contacts', // array of contact IDs
      'competitors',
      'decisionCriteria',
      'nextAction',
      'blockers'
    ],
    
    interactionTypes: [
      'email-sent',
      'email-opened',
      'email-clicked',
      'email-replied',
      'call',
      'meeting',
      'demo',
      'proposal-sent',
      'negotiation',
      'closed-won',
      'closed-lost'
    ],
    
    pipelineStages: {
      'awareness': { probability: 10, color: '#gray' },
      'interest': { probability: 20, color: '#blue' },
      'consideration': { probability: 40, color: '#yellow' },
      'intent': { probability: 60, color: '#orange' },
      'evaluation': { probability: 80, color: '#purple' },
      'purchase': { probability: 100, color: '#green' }
    }
    
  },
  
  // ==================== AUTOMATION RULES ====================
  
  automationRules: {
    
    prospectorAgent: {
      schedule: '0 9 * * *', // Daily at 9 AM
      tasks: [
        'Search for new companies matching TAM criteria',
        'Enrich contact data (title, email, LinkedIn)',
        'Score leads based on ICP fit',
        'Add qualified leads to outbound queue'
      ]
    },
    
    outreachAgent: {
      schedule: '0 10 * * 1-5', // Weekdays at 10 AM
      tasks: [
        'Send scheduled emails in sequences',
        'Track opens, clicks, replies',
        'Update CRM with engagement data',
        'Trigger follow-up tasks based on engagement'
      ]
    },
    
    crmAgent: {
      schedule: '*/15 * * * *', // Every 15 minutes
      tasks: [
        'Log email interactions',
        'Update opportunity stages',
        'Clean duplicate contacts',
        'Sync with external CRMs (if connected)'
      ]
    },
    
    croAgent: {
      schedule: '0 17 * * *', // Daily at 5 PM
      tasks: [
        'Analyze pipeline health',
        'Identify stuck deals',
        'Generate next-action recommendations',
        'Score opportunities for priority'
      ]
    }
    
  },
  
  // ==================== KPIs TO TRACK ====================
  
  kpis: {
    
    outbound: {
      'emails-sent': { target: 100, period: 'week' },
      'open-rate': { target: 0.30, period: 'week' },
      'reply-rate': { target: 0.10, period: 'week' },
      'meetings-booked': { target: 10, period: 'week' },
      'meetings-held': { target: 8, period: 'week' }
    },
    
    pipeline: {
      'total-opportunities': { target: 50, period: 'month' },
      'pipeline-value': { target: 500000, period: 'month' },
      'average-deal-size': { target: 10000, period: 'month' },
      'sales-cycle-length': { target: 30, unit: 'days' },
      'win-rate': { target: 0.25, period: 'month' }
    },
    
    revenue: {
      'mrr': { target: 10000, period: 'month' },
      'arr': { target: 120000, period: 'year' },
      'arpu': { target: 1000, period: 'month' },
      'ltv': { target: 12000, period: 'lifetime' },
      'cac': { target: 500, period: 'month' },
      'ltv-cac-ratio': { target: 3.0 }
    },
    
    activity: {
      'contacts-per-shell': { target: 50, period: 'month' },
      'companies-sourced': { target: 20, period: 'week' },
      'sequences-active': { target: 10, period: 'week' },
      'follow-ups-sent': { target: 50, period: 'week' }
    }
    
  }
  
};

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
  module.exports = GTMLaunchpad;
}

// Make available globally in browser
if (typeof window !== 'undefined') {
  window.GTMLaunchpad = GTMLaunchpad;
}

console.log('🚀 GTM Launchpad loaded');
console.log('📊 TAM Lists:', Object.keys(GTMLaunchpad.tamLists).length, 'shells');
console.log('📧 Sequences:', Object.keys(GTMLaunchpad.sequences).length, 'templates');
console.log('🎯 Ready to deploy GTM infrastructure');
