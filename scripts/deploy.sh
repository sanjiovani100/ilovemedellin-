#!/bin/bash
# I Love Medellin - Deployment Script

echo "🚀 I Love Medellin - Deployment Script"
echo "======================================"

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found. Please copy config/.env.example to .env and configure it."
    exit 1
fi

# Load environment variables
source .env

echo "✅ Environment loaded"
echo "📦 Installing dependencies..."

# Install npm dependencies
npm install

echo "🗄️  Setting up database..."

# Deploy Supabase functions if CLI is available
if command -v supabase &> /dev/null; then
    echo "📤 Deploying Supabase functions..."
    supabase functions deploy stripe-webhook
    supabase functions deploy send-whatsapp-confirmation
    echo "✅ Functions deployed"
else
    echo "⚠️  Supabase CLI not found. Please install it to deploy functions."
fi

echo "🔍 Running health checks..."

# Basic health checks
if [ -n "$SUPABASE_URL" ]; then
    echo "✅ Supabase URL configured"
else
    echo "❌ Supabase URL missing"
fi

if [ -n "$STRIPE_SECRET_KEY" ]; then
    echo "✅ Stripe configured"
else
    echo "❌ Stripe not configured"
fi

if [ -n "$WATI_API_TOKEN" ]; then
    echo "✅ WhatsApp API configured"
else
    echo "❌ WhatsApp API not configured"
fi

echo "🎉 Deployment completed!"
echo ""
echo "Next steps:"
echo "1. Configure your .env file with actual API keys"
echo "2. Set up Stripe webhooks pointing to your Supabase functions"
echo "3. Configure WhatsApp templates in WATI dashboard"
echo "4. Test the booking flow"
