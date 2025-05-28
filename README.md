# I Love Medellín - Smart Booking Platform

[![Deploy Status](https://img.shields.io/badge/deploy-success-brightgreen)](https://ilovemedellin.com)
[![Database](https://img.shields.io/badge/database-supabase-green)](https://supabase.com)
[![Frontend](https://img.shields.io/badge/frontend-webflow-blue)](https://webflow.com)
[![Automation](https://img.shields.io/badge/automation-n8n-orange)](https://n8n.io)

> Conecta a viajeros con las experiencias más auténticas de Medellín, impulsadas por inteligencia artificial y respaldadas por la comunidad local.

## 🌟 Project Overview

**I Love Medellín** is a comprehensive booking platform for authentic local experiences in Medellín, Colombia. The platform connects international tourists and local visitors with verified experience providers including tours, restaurants, cultural activities, and accommodations.

### Key Features
- 🤖 **AI-Powered Recommendations** - Personalized experience suggestions
- 💬 **WhatsApp-First Communication** - Native messaging for Colombian market
- 💳 **Stripe Connect Integration** - Secure marketplace payments
- 🌐 **Bilingual Support** - Spanish and English interfaces
- 📱 **Mobile-First Design** - Optimized for Colombian mobile users
- 🔄 **Real-time Sync** - Webflow ↔ Supabase data synchronization

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     USER INTERFACES                        │
├─────────────────┬─────────────────┬─────────────────────────┤
│  Webflow Web    │  WhatsApp Bot   │  Admin Dashboard        │
│  - Responsive   │  - WATI/Twilio  │  - Host Management      │
│  - Multilingual │  - Conversational│  - Analytics            │
│  - PWA Ready    │  - Booking Flow │  - Content Management   │
└─────────────────┴─────────────────┴─────────────────────────┘
                           │
┌─────────────────────────────────────────────────────────────┐
│                   API GATEWAY LAYER                        │
├─────────────────┬─────────────────┬─────────────────────────┤
│   Supabase      │    BuildShip    │       n8n               │
│   - REST APIs   │    - Serverless │       - Workflows       │
│   - Real-time   │    - Custom     │       - Integrations    │
│   - Auth        │    - Logic      │       - Automation      │
└─────────────────┴─────────────────┴─────────────────────────┘
```

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ and npm
- Supabase account
- Webflow account with CMS plan
- Stripe account
- WhatsApp Business API access (WATI or Twilio)

### 1. Clone Repository
```bash
git clone https://github.com/sanjiovani100/ilovemedellin-.git
cd ilovemedellin-
```

### 2. Environment Setup
```bash
# Copy environment template
cp config/.env.example .env

# Install dependencies
npm install

# Setup database
npm run db:setup
```
