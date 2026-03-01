CREATE TABLE public.orders (
    id UUID PRIMARY KEY,
    customer_user_id UUID REFERENCES users(id),
    merchant_id UUID REFERENCES merchants(id),
    vertical_id UUID REFERENCES service_vertical_master(id),
    rider_id UUID REFERENCES riders(id),
    total_amount NUMERIC(10,2),
    status INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);