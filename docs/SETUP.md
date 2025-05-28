# I Love Medellín - Setup Guide

## 🚀 Quick Start

### 1. Clone and Setup
```bash
git clone https://github.com/sanjiovani100/ilovemedellin-.git
cd ilovemedellin-
npm install
```

### 2. Environment Configuration
```bash
# Copy environment template
cp config/.env.example .env

# Edit .env with your actual API keys:
# - Supabase URL and keys
# - Stripe keys  
# - WhatsApp API token
# - Webflow API token
```

### 3. Database Setup
```bash
# Install Supabase CLI
npm install -g supabase

# Login to Supabase
supabase login

# Deploy database schema
supabase db push

# Deploy functions
supabase functions deploy stripe-webhook
supabase functions deploy send-whatsapp-confirmation
```

### 4. Quick Deploy
```bash
# Run deployment script
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

## 🔧 Manual Configuration

### Stripe Webhooks
1. Go to Stripe Dashboard → Webhooks
2. Add endpoint: `https://[your-supabase-url]/functions/v1/stripe-webhook`
3. Select events: payment_intent.succeeded, payment_intent.payment_failed

### WhatsApp Templates (WATI)
1. Import templates from `whatsapp/templates/message-templates.json`
2. Configure in WATI dashboard
3. Approve templates with WhatsApp

### n8n Workflows (Optional)
1. Import workflows from `n8n/workflows/`
2. Configure credentials
3. Activate workflows

## 🎯 Next Steps

1. Test booking flow end-to-end
2. Configure host onboarding
3. Set up monitoring and analytics
4. Launch marketing campaigns

## 🆘 Support

- Documentation: `/docs/`
- Issues: GitHub Issues
- Email: support@ilovemedellin.com
