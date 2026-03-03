-- Affiliate Engine Database Schema
-- Run this in PostgreSQL after deployment

-- Campaigns table
CREATE TABLE IF NOT EXISTS campaigns (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    offer_name VARCHAR(255),
    offer_url TEXT,
    payout DECIMAL(10, 2),
    status VARCHAR(50) DEFAULT 'draft', -- draft, testing, scaled, killed, paused
    facebook_campaign_id VARCHAR(100),
    daily_budget DECIMAL(10, 2) DEFAULT 10.00,
    total_spend DECIMAL(10, 2) DEFAULT 0,
    total_revenue DECIMAL(10, 2) DEFAULT 0,
    total_conversions INTEGER DEFAULT 0,
    roi DECIMAL(5, 2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Adsets table
CREATE TABLE IF NOT EXISTS adsets (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER REFERENCES campaigns(id),
    name VARCHAR(255) NOT NULL,
    facebook_adset_id VARCHAR(100),
    targeting JSONB, -- Facebook targeting config
    bid_amount DECIMAL(10, 2),
    status VARCHAR(50) DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creatives table
CREATE TABLE IF NOT EXISTS creatives (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER REFERENCES campaigns(id),
    adset_id INTEGER REFERENCES adsets(id),
    creative_id VARCHAR(100),
    prompt TEXT,
    headline VARCHAR(255),
    body_text TEXT,
    image_url TEXT,
    facebook_ad_id VARCHAR(100),
    spend DECIMAL(10, 2) DEFAULT 0,
    conversions INTEGER DEFAULT 0,
    ctr DECIMAL(5, 4) DEFAULT 0,
    status VARCHAR(50) DEFAULT 'ready',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Analytics table (hourly snapshots)
CREATE TABLE IF NOT EXISTS analytics (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER REFERENCES campaigns(id),
    adset_id INTEGER REFERENCES adsets(id),
    creative_id INTEGER REFERENCES creatives(id),
    metric_date DATE,
    metric_hour INTEGER,
    spend DECIMAL(10, 2),
    impressions INTEGER,
    clicks INTEGER,
    conversions INTEGER,
    revenue DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Prompts library (for bulk generation)
CREATE TABLE IF NOT EXISTS prompts (
    id SERIAL PRIMARY KEY,
    campaign_id INTEGER REFERENCES campaigns(id),
    prompt_text TEXT NOT NULL,
    category VARCHAR(100), -- emotional hook, benefit, problem-agitation
    style VARCHAR(100), -- minimalist, bold, lifestyle
    generated BOOLEAN DEFAULT FALSE,
    creative_id INTEGER REFERENCES creatives(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_campaigns_status ON campaigns(status);
CREATE INDEX idx_creatives_campaign ON creatives(campaign_id);
CREATE INDEX idx_analytics_date ON analytics(metric_date, metric_hour);

-- Insert sample campaign
INSERT INTO campaigns (name, offer_name, payout, status, daily_budget)
VALUES
    ('Weight Loss - US', 'Keto Diet Pills', 45.00, 'draft', 10.00),
    ('Skin Care - Female 35+', 'Anti-Aging Serum', 52.00, 'draft', 10.00),
    ('Finance - Credit Repair', 'Credit Boost Pro', 85.00, 'draft', 10.00);

-- Insert sample prompts for batch generation
INSERT INTO prompts (campaign_id, prompt_text, category, style)
SELECT c.id, p.prompt, p.category, p.style
FROM campaigns c
CROSS JOIN (
    VALUES
        ('Desperate woman looking at mirror, frustrated expression, soft lighting', 'problem-agitation', 'lifestyle'),
        ('Happy confident person smiling, transformation journey, before/after vibe', 'benefit', 'lifestyle'),
        ('Bold red text on dark background, urgent message, high contrast', 'emotional hook', 'bold'),
        ('Minimalist product shot, clean white background, professional lighting', 'benefit', 'minimalist'),
        ('Stressed person at desk, bills piling up, relatable struggle', 'problem-agitation', 'lifestyle')
) AS p(prompt, category, style)
WHERE c.name = 'Weight Loss - US';

-- Grant permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres;
