CREATE TABLE public.riders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id),
    driving_license VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);