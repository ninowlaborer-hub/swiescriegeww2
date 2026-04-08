-- Swisscierge Initial Database Schema
-- Creates all tables, indexes, RLS policies, and scheduled jobs
-- Based on data-model.md specification

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_cron";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ========================================
-- USER ACCOUNTS (extends Supabase Auth)
-- ========================================

CREATE TABLE IF NOT EXISTS public.user_accounts (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    email_verified BOOLEAN NOT NULL DEFAULT false,
    passwordless_enabled BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ========================================
-- USER PROFILES
-- ========================================

CREATE TABLE IF NOT EXISTS public.user_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE REFERENCES public.user_accounts(id) ON DELETE CASCADE,
    timezone TEXT NOT NULL DEFAULT 'UTC',
    work_window_start TIME,
    work_window_end TIME,
    quiet_hours_start TIME,
    quiet_hours_end TIME,
    location_lat DECIMAL(9,6),
    location_lng DECIMAL(9,6),
    location_name TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Validation constraints
    CONSTRAINT valid_location_lat CHECK (location_lat >= -90 AND location_lat <= 90),
    CONSTRAINT valid_location_lng CHECK (location_lng >= -180 AND location_lng <= 180)
);

-- ========================================
-- CALENDAR CONNECTIONS
-- ========================================

CREATE TABLE IF NOT EXISTS public.calendar_connections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.user_accounts(id) ON DELETE CASCADE,
    provider TEXT NOT NULL CHECK (provider IN ('google', 'microsoft', 'apple')),
    provider_account_id TEXT NOT NULL,
    access_token TEXT NOT NULL,  -- Will be encrypted at application layer
    refresh_token TEXT,  -- Will be encrypted at application layer
    token_expires_at TIMESTAMPTZ,
    scopes TEXT[] NOT NULL,
    has_write_permission BOOLEAN NOT NULL DEFAULT false,
    last_sync_at TIMESTAMPTZ,
    sync_status TEXT NOT NULL DEFAULT 'active' CHECK (sync_status IN ('active', 'expired', 'revoked', 'error')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Prevent duplicate connections
    UNIQUE(user_id, provider, provider_account_id)
);

-- ========================================
-- SLEEP DATA RECORDS
-- ========================================

CREATE TABLE IF NOT EXISTS public.sleep_data_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.user_accounts(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    sleep_time TIMESTAMPTZ NOT NULL,
    wake_time TIMESTAMPTZ NOT NULL,
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes >= 0 AND duration_minutes <= 1440),
    quality TEXT CHECK (quality IN ('poor', 'fair', 'good', 'excellent')),
    source TEXT NOT NULL CHECK (source IN ('manual', 'healthkit', 'googlefit')),
    source_record_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Validation: wake_time must be after sleep_time
    CONSTRAINT valid_sleep_times CHECK (wake_time > sleep_time),

    -- One sleep record per user per night
    UNIQUE(user_id, date)
);

-- ========================================
-- ACTIVITY CATALOG (predefined)
-- ========================================

CREATE TABLE IF NOT EXISTS public.activity_catalog (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    category TEXT NOT NULL CHECK (category IN ('work', 'health', 'personal', 'leisure')),
    typical_duration_min INTEGER,
    typical_duration_max INTEGER,
    is_outdoor BOOLEAN NOT NULL DEFAULT false,
    color_hex TEXT CHECK (color_hex ~ '^#[0-9A-Fa-f]{6}$'),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Validation
    CONSTRAINT valid_duration_range CHECK (typical_duration_max IS NULL OR typical_duration_max >= typical_duration_min)
);

-- Seed predefined activities
INSERT INTO public.activity_catalog (name, description, category, typical_duration_min, typical_duration_max, is_outdoor, color_hex) VALUES
    ('Exercise', 'Physical workout or running', 'health', 30, 60, true, '#FF5722'),
    ('Work', 'General work tasks', 'work', 60, 240, false, '#2196F3'),
    ('Focused Work', 'Deep work requiring concentration', 'work', 60, 120, false, '#3F51B5'),
    ('Meetings', 'Work meetings and calls', 'work', 30, 120, false, '#9C27B0'),
    ('Meal', 'Breakfast, lunch, or dinner', 'personal', 15, 45, false, '#FF9800'),
    ('Break', 'Short rest or coffee break', 'personal', 10, 30, false, '#4CAF50'),
    ('Rest', 'Relaxation or nap', 'personal', 15, 120, false, '#00BCD4'),
    ('Commute', 'Travel to work or activities', 'personal', 15, 90, false, '#607D8B'),
    ('Personal Care', 'Hygiene and grooming', 'personal', 15, 60, false, '#E91E63'),
    ('Leisure', 'Hobbies and entertainment', 'leisure', 30, 180, false, '#8BC34A')
ON CONFLICT (name) DO NOTHING;

-- ========================================
-- DAILY ROUTINES
-- ========================================

CREATE TABLE IF NOT EXISTS public.daily_routines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.user_accounts(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    generated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    generation_type TEXT NOT NULL CHECK (generation_type IN ('automatic', 'on_demand')),
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'partially_accepted', 'rejected')),
    accepted_at TIMESTAMPTZ,
    version INTEGER NOT NULL DEFAULT 1,
    expires_at DATE NOT NULL DEFAULT (CURRENT_DATE + INTERVAL '90 days'),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Allow multiple versions per day (regeneration)
    UNIQUE(user_id, date, version)
);

-- ========================================
-- TIME BLOCKS
-- ========================================

CREATE TABLE IF NOT EXISTS public.time_blocks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    routine_id UUID NOT NULL REFERENCES public.daily_routines(id) ON DELETE CASCADE,
    activity_id UUID NOT NULL REFERENCES public.activity_catalog(id),
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    duration_minutes INTEGER NOT NULL,
    label TEXT NOT NULL,
    confidence_score DECIMAL(3,2) NOT NULL CHECK (confidence_score >= 0.00 AND confidence_score <= 1.00),
    explanation TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'suggested' CHECK (status IN ('suggested', 'accepted', 'edited', 'snoozed')),
    original_start_time TIMESTAMPTZ,
    original_end_time TIMESTAMPTZ,
    edit_count INTEGER NOT NULL DEFAULT 0,
    calendar_event_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Validation: end_time must be after start_time
    CONSTRAINT valid_time_block CHECK (end_time > start_time)
);

-- ========================================
-- WEATHER FORECASTS
-- ========================================

CREATE TABLE IF NOT EXISTS public.weather_forecasts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.user_accounts(id) ON DELETE CASCADE,
    location_lat DECIMAL(9,6) NOT NULL,
    location_lng DECIMAL(9,6) NOT NULL,
    forecast_time TIMESTAMPTZ NOT NULL,
    temperature_celsius DECIMAL(4,1),
    temperature_fahrenheit DECIMAL(4,1),
    precipitation_probability INTEGER CHECK (precipitation_probability >= 0 AND precipitation_probability <= 100),
    precipitation_type TEXT CHECK (precipitation_type IN ('none', 'rain', 'snow', 'sleet')),
    air_quality_index INTEGER CHECK (air_quality_index >= 0 AND air_quality_index <= 500),
    air_quality_category TEXT CHECK (air_quality_category IN ('good', 'moderate', 'unhealthy_sensitive', 'unhealthy', 'very_unhealthy', 'hazardous')),
    weather_condition TEXT NOT NULL CHECK (weather_condition IN ('clear', 'partly_cloudy', 'cloudy', 'rain', 'snow', 'thunderstorm', 'fog')),
    wind_speed_kmh DECIMAL(4,1),
    fetched_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- One forecast per user per hour
    UNIQUE(user_id, forecast_time)
);

-- ========================================
-- USER FEEDBACK
-- ========================================

CREATE TABLE IF NOT EXISTS public.user_feedback (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.user_accounts(id) ON DELETE CASCADE,
    time_block_id UUID NOT NULL REFERENCES public.time_blocks(id) ON DELETE CASCADE,
    action TEXT NOT NULL CHECK (action IN ('accepted', 'edited', 'snoozed')),
    edit_delta_minutes INTEGER,
    snooze_reason TEXT,
    feedback_text TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ========================================
-- INDEXES
-- ========================================

-- User lookups
CREATE INDEX idx_user_accounts_email ON public.user_accounts(email);

-- Routine queries
CREATE INDEX idx_daily_routines_user_date ON public.daily_routines(user_id, date DESC);
CREATE INDEX idx_daily_routines_expires_at ON public.daily_routines(expires_at) WHERE status IN ('pending', 'accepted', 'partially_accepted');

-- Time block queries
CREATE INDEX idx_time_blocks_routine_id ON public.time_blocks(routine_id);
CREATE INDEX idx_time_blocks_start_time ON public.time_blocks(start_time);

-- Calendar connections
CREATE INDEX idx_calendar_connections_user_id ON public.calendar_connections(user_id);
CREATE INDEX idx_calendar_connections_sync_status ON public.calendar_connections(sync_status) WHERE sync_status IN ('expired', 'error');

-- Weather forecasts
CREATE INDEX idx_weather_forecasts_user_time ON public.weather_forecasts(user_id, forecast_time DESC);

-- Sleep data
CREATE INDEX idx_sleep_data_user_date ON public.sleep_data_records(user_id, date DESC);

-- User feedback
CREATE INDEX idx_user_feedback_user_id ON public.user_feedback(user_id);
CREATE INDEX idx_user_feedback_action ON public.user_feedback(action);

-- ========================================
-- ROW LEVEL SECURITY (RLS)
-- ========================================

-- Enable RLS on all tables
ALTER TABLE public.user_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.calendar_connections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sleep_data_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_routines ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.time_blocks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.weather_forecasts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activity_catalog ENABLE ROW LEVEL SECURITY;

-- User profiles
CREATE POLICY "Users can view own profile" ON public.user_profiles
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own profile" ON public.user_profiles
    FOR UPDATE USING (auth.uid() = user_id);

-- Calendar connections
CREATE POLICY "Users can manage own calendar connections" ON public.calendar_connections
    FOR ALL USING (auth.uid() = user_id);

-- Sleep data
CREATE POLICY "Users can manage own sleep data" ON public.sleep_data_records
    FOR ALL USING (auth.uid() = user_id);

-- Daily routines
CREATE POLICY "Users can view own routines" ON public.daily_routines
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own routines" ON public.daily_routines
    FOR UPDATE USING (auth.uid() = user_id);

-- Time blocks
CREATE POLICY "Users can manage own time blocks" ON public.time_blocks
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.daily_routines
            WHERE daily_routines.id = time_blocks.routine_id
              AND daily_routines.user_id = auth.uid()
        )
    );

-- Weather forecasts
CREATE POLICY "Users can view own weather forecasts" ON public.weather_forecasts
    FOR SELECT USING (auth.uid() = user_id);

-- User feedback
CREATE POLICY "Users can submit own feedback" ON public.user_feedback
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Activity catalog (read-only for all authenticated users)
CREATE POLICY "All users can view activity catalog" ON public.activity_catalog
    FOR SELECT USING (auth.role() = 'authenticated');

-- ========================================
-- SCHEDULED CLEANUP FUNCTIONS
-- ========================================

-- Function to delete expired routines (90-day retention)
CREATE OR REPLACE FUNCTION cleanup_expired_routines()
RETURNS void AS $$
BEGIN
    DELETE FROM public.daily_routines
    WHERE expires_at < CURRENT_DATE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to delete old weather forecasts (7-day retention)
CREATE OR REPLACE FUNCTION cleanup_old_weather_forecasts()
RETURNS void AS $$
BEGIN
    DELETE FROM public.weather_forecasts
    WHERE forecast_time < NOW() - INTERVAL '7 days';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Schedule cleanup jobs (if pg_cron is available)
-- Note: These require pg_cron extension and superuser permissions
-- Run manually if pg_cron is not available in your Supabase instance

-- SELECT cron.schedule('cleanup-expired-routines', '0 2 * * *', 'SELECT cleanup_expired_routines();');
-- SELECT cron.schedule('cleanup-old-forecasts', '0 3 * * *', 'SELECT cleanup_old_weather_forecasts();');

-- ========================================
-- TRIGGERS FOR updated_at
-- ========================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply triggers to tables with updated_at
CREATE TRIGGER update_user_accounts_updated_at BEFORE UPDATE ON public.user_accounts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON public.user_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_calendar_connections_updated_at BEFORE UPDATE ON public.calendar_connections FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_sleep_data_records_updated_at BEFORE UPDATE ON public.sleep_data_records FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_daily_routines_updated_at BEFORE UPDATE ON public.daily_routines FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_time_blocks_updated_at BEFORE UPDATE ON public.time_blocks FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
