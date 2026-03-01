CREATE TABLE public.merchant_products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID REFERENCES merchants(id),
    product_id UUID REFERENCES product_master(id),
    is_available BOOLEAN DEFAULT TRUE
);