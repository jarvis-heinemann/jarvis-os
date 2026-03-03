# N8N Workflows - Affiliate Engine

These workflows automate the 111 Method for affiliate marketing.

## Workflows Included

### 1. OpenArt Bulk Generator (`openart-bulk-generator.json`)
Generates ad images in bulk using OpenArt.AI API.

**Flow:**
1. Read prompts from database
2. Send to OpenArt.AI for generation
3. Download generated images
4. Upload to Minio storage
5. Save metadata to PostgreSQL

**Setup:**
- Add OpenArt.AI API key to N8N credentials
- Configure Minio credentials
- Run schema.sql to create database tables

### 2. 111 Method Auto-Scaler (`111-method-scaler.json`)
Automatically kills losing creatives and scales winners.

**Rules:**
- **Kill criteria:** $30+ spend, 0 conversions → PAUSE
- **Scale criteria:** $10+ spend, 2+ conversions → 2x daily budget

**Runs:** Every hour via schedule trigger

**Setup:**
- Add Facebook Graph API credentials
- Ensure analytics table is populated with real data

## Deployment Order

1. Deploy stack: `./zimaboard-affiliate-stack.sh`
2. Run schema.sql in PostgreSQL
3. Import workflows to N8N (http://192.168.4.65:5678/)
4. Add credentials (OpenArt, Facebook, Minio, PostgreSQL)
5. Activate workflows

## Environment Variables

Set these in N8N credentials:

```
OPENART_API_KEY=your_key_here
FACEBOOK_APP_ID=your_app_id
FACEBOOK_APP_SECRET=your_app_secret
FACEBOOK_ACCESS_TOKEN=your_token
```

## Minio Setup

After deployment:
1. Open http://192.168.4.65:9011/
2. Login: admin / Zima307783!
3. Create bucket: `affiliate-ads`
4. Set bucket policy to public (for ad serving)

## Testing

1. Add a campaign to PostgreSQL
2. Add prompts for that campaign
3. Trigger OpenArt workflow manually
4. Check Minio for generated images
5. Activate 111 Method scaler

## Scaling to 500 Creatives

With 500 prompts in the database:
- Cost: $0.08 × 500 = $40
- Time: ~2 hours (parallel generation)
- Output: 500 unique ad images ready for testing

## Next Steps

1. Connect Facebook Ads API
2. Build automated campaign launcher
3. Add performance tracking webhook
4. Create dashboard in Mission Control
