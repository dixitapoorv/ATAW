CREATE TABLE public.rider_status (
    rider_id UUID PRIMARY KEY REFERENCES riders(id),
    is_available BOOLEAN DEFAULT FALSE
);