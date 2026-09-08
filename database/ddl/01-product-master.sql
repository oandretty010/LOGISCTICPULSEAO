-- LOGISTPULSE Product Master - PostgreSQL DDL
-- Academic synthetic dataset. Not an official Nestle catalog.

CREATE SCHEMA IF NOT EXISTS product_master;
SET search_path TO product_master;

CREATE TABLE IF NOT EXISTS category (
    category_id BIGSERIAL PRIMARY KEY,
    category_name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS subcategory (
    subcategory_id BIGSERIAL PRIMARY KEY,
    category_id BIGINT NOT NULL REFERENCES category(category_id),
    subcategory_name VARCHAR(100) NOT NULL,
    CONSTRAINT uq_subcategory UNIQUE (category_id, subcategory_name)
);

CREATE TABLE IF NOT EXISTS brand_family (
    brand_family_id BIGSERIAL PRIMARY KEY,
    brand_family_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS market (
    market_code CHAR(2) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS storage_profile (
    storage_profile_id BIGSERIAL PRIMARY KEY,
    storage_zone VARCHAR(20) NOT NULL UNIQUE,
    temp_min_c NUMERIC(5,2) NOT NULL,
    temp_max_c NUMERIC(5,2) NOT NULL,
    CONSTRAINT ck_storage_temperature CHECK (temp_min_c <= temp_max_c)
);

CREATE TABLE IF NOT EXISTS product (
    product_id BIGINT PRIMARY KEY,
    sku VARCHAR(30) NOT NULL UNIQUE,
    ean13 CHAR(13) NOT NULL UNIQUE,
    manufacturer VARCHAR(120) NOT NULL,
    product_name VARCHAR(220) NOT NULL,
    subcategory_id BIGINT NOT NULL REFERENCES subcategory(subcategory_id),
    brand_family_id BIGINT NOT NULL REFERENCES brand_family(brand_family_id),
    market_code CHAR(2) NOT NULL REFERENCES market(market_code),
    package_type VARCHAR(40) NOT NULL,
    net_content NUMERIC(12,3) NOT NULL CHECK (net_content > 0),
    content_unit VARCHAR(5) NOT NULL,
    gross_weight_kg NUMERIC(12,3) NOT NULL CHECK (gross_weight_kg > 0),
    length_cm NUMERIC(10,2) NOT NULL CHECK (length_cm > 0),
    width_cm NUMERIC(10,2) NOT NULL CHECK (width_cm > 0),
    height_cm NUMERIC(10,2) NOT NULL CHECK (height_cm > 0),
    units_per_case INTEGER NOT NULL CHECK (units_per_case > 0),
    cases_per_pallet INTEGER NOT NULL CHECK (cases_per_pallet > 0),
    shelf_life_days INTEGER NOT NULL CHECK (shelf_life_days > 0),
    storage_profile_id BIGINT NOT NULL REFERENCES storage_profile(storage_profile_id),
    lot_tracking BOOLEAN NOT NULL,
    expiry_tracking BOOLEAN NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE INDEX IF NOT EXISTS idx_product_subcategory ON product(subcategory_id);
CREATE INDEX IF NOT EXISTS idx_product_brand ON product(brand_family_id);
CREATE INDEX IF NOT EXISTS idx_product_market ON product(market_code);
CREATE INDEX IF NOT EXISTS idx_product_storage ON product(storage_profile_id);
CREATE INDEX IF NOT EXISTS idx_product_active ON product(active);
