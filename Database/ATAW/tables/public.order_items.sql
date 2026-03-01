CREATE TABLE public.order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES orders(id),
    merchant_product_id UUID REFERENCES merchant_products(id),
    quantity INT,
    price NUMERIC(10,2)
);