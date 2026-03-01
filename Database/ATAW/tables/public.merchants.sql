CREATE TABLE public.merchants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_user_id UUID REFERENCES users(id),
    vertical_id UUID REFERENCES service_vertical_master(id),
    name VARCHAR(200) NOT NULL,
    phone VARCHAR(20),
    gst_number VARCHAR(50),
    is_approved BOOLEAN DEFAULT FALSE,
    status INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);