-- I Love Medellin - Complete Database Schema
-- File: supabase/sql/schema.sql

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";

-- Drop existing tables if they exist (for clean reinstall)
DROP TABLE IF EXISTS whatsapp_logs CASCADE;
DROP TABLE IF EXISTS sync_operations CASCADE;
DROP TABLE IF EXISTS sync_history CASCADE;
DROP TABLE IF EXISTS system_settings CASCADE;
DROP TABLE IF EXISTS field_mappings CASCADE;
DROP TABLE IF EXISTS sync_config CASCADE;
DROP TABLE IF EXISTS api_secrets CASCADE;
DROP TABLE IF EXISTS chatbot_settings CASCADE;
DROP TABLE IF EXISTS landing_pages CASCADE;
DROP TABLE IF EXISTS venues CASCADE;
DROP TABLE IF EXISTS organizations CASCADE;
DROP TABLE IF EXISTS cuisines CASCADE;
DROP TABLE IF EXISTS cities CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS booking_payments CASCADE;
DROP TABLE IF EXISTS stripe_transfers CASCADE;
DROP TABLE IF EXISTS stripe_payment_intents CASCADE;
DROP TABLE IF EXISTS stripe_customers CASCADE;
DROP TABLE IF EXISTS form_submissions CASCADE;
DROP TABLE IF EXISTS reminders CASCADE;
DROP TABLE IF EXISTS rental_details CASCADE;
DROP TABLE IF EXISTS property_details CASCADE;
DROP TABLE IF EXISTS properties CASCADE;
DROP TABLE IF EXISTS experiences CASCADE;
DROP TABLE IF EXISTS experience_categories CASCADE;
DROP TABLE IF EXISTS event_categories CASCADE;
DROP TABLE IF EXISTS events CASCADE;
DROP TABLE IF EXISTS event_registrations CASCADE;
DROP TABLE IF EXISTS messages CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS listings CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- 1. Users table
CREATE TABLE users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    name TEXT,
    avatar_url TEXT,
    profile_image_url TEXT,
    phone TEXT,
    role TEXT DEFAULT 'user' CHECK (role IN ('user', 'host', 'admin')),
    is_verified BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    auth_provider TEXT DEFAULT 'email',
    stripe_customer_id TEXT,
    stripe_connect_account_id TEXT,
    preferred_language TEXT DEFAULT 'es' CHECK (preferred_language IN ('es', 'en')),
    location JSONB,
    payment_preferences JSONB,
    marketing_consent BOOLEAN DEFAULT false,
    whatsapp_opted_in BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Cities table
CREATE TABLE cities (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    region TEXT,
    country TEXT DEFAULT 'Colombia',
    lat NUMERIC,
    lng NUMERIC,
    timezone TEXT DEFAULT 'America/Bogota',
    currency TEXT DEFAULT 'COP',
    webflow_id TEXT UNIQUE,
    link TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Categories table
CREATE TABLE categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Experience Categories
CREATE TABLE experience_categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    icon_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Event Categories
CREATE TABLE event_categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. Listings table
CREATE TABLE listings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    type TEXT CHECK (type IN ('experience', 'event', 'property', 'tour', 'restaurant')),
    location JSONB,
    price NUMERIC(10,2),
    currency TEXT DEFAULT 'COP',
    image_url TEXT,
    gallery TEXT[],
    host_id UUID REFERENCES users(id),
    category_id UUID REFERENCES categories(id),
    tags TEXT[],
    pinecone_vector_id TEXT,
    avg_rating NUMERIC(3,2) DEFAULT 0,
    booking_count INTEGER DEFAULT 0,
    dynamic_pricing BOOLEAN DEFAULT false,
    search_score NUMERIC DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
