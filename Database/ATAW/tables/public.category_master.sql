CREATE TABLE public.category_master (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vertical_id UUID REFERENCES service_vertical_master(id),
    name VARCHAR(150) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);