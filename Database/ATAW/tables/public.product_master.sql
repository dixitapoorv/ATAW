CREATE TABLE public.product_master (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vertical_id UUID REFERENCES service_vertical_master(id),
    category_id UUID REFERENCES category_master(id),
    subcategory_id UUID REFERENCES subcategory_master(id),
    name VARCHAR(200) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);