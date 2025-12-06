-- ServiMarket RD - Database Schema for Supabase
-- Ejecuta este script en el SQL Editor de Supabase

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========================================
-- TABLA: users (Usuarios)
-- ========================================
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255),
    role VARCHAR(20) CHECK (role IN ('vendedor', 'proveedor', 'cliente', 'admin')) DEFAULT 'cliente',
    phone VARCHAR(20),
    municipio VARCHAR(100),
    barrio VARCHAR(100),
    description TEXT,
    rating DECIMAL(2,1) DEFAULT 5.0 CHECK (rating >= 0 AND rating <= 5),
    review_count INT DEFAULT 0,
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- TABLA: products (Productos)
-- ========================================
CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    category VARCHAR(100),
    description TEXT,
    seller_id UUID REFERENCES users(id) ON DELETE CASCADE,
    municipio VARCHAR(100),
    barrio VARCHAR(100),
    rating DECIMAL(2,1) DEFAULT 5.0,
    stock INT DEFAULT 0 CHECK (stock >= 0),
    image_url TEXT,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'sold_out')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- TABLA: services (Servicios)
-- ========================================
CREATE TABLE IF NOT EXISTS services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    category VARCHAR(100),
    description TEXT,
    provider_id UUID REFERENCES users(id) ON DELETE CASCADE,
    municipio VARCHAR(100),
    barrio VARCHAR(100),
    availability VARCHAR(100),
    rating DECIMAL(2,1) DEFAULT 5.0,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- TABLA: jobs (Empleos)
-- ========================================
CREATE TABLE IF NOT EXISTS jobs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    type VARCHAR(50) CHECK (type IN ('Por Hora', 'Por Servicio', 'Tiempo Completo')),
    pay DECIMAL(10,2) NOT NULL,
    pay_per VARCHAR(50),
    description TEXT,
    employer_id UUID REFERENCES users(id) ON DELETE CASCADE,
    municipio VARCHAR(100),
    barrio VARCHAR(100),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'closed', 'filled')),
    posted_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- TABLA: orders (Pedidos)
-- ========================================
CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    total DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) CHECK (payment_method IN ('card', 'cash', 'delivery')),
    delivery_address TEXT,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- TABLA: order_items (Items del Pedido)
-- ========================================
CREATE TABLE IF NOT EXISTS order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(id) ON DELETE SET NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- TABLA: service_requests (Solicitudes de Servicio)
-- ========================================
CREATE TABLE IF NOT EXISTS service_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    service_id UUID REFERENCES services(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'in_progress', 'completed', 'cancelled')),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- TABLA: job_applications (Aplicaciones a Empleos)
-- ========================================
CREATE TABLE IF NOT EXISTS job_applications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    job_id UUID REFERENCES jobs(id) ON DELETE CASCADE,
    applicant_id UUID REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
    message TEXT,
    applied_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(job_id, applicant_id)
);

-- ========================================
-- TABLA: reviews (Reseñas)
-- ========================================
CREATE TABLE IF NOT EXISTS reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    target_type VARCHAR(50) CHECK (target_type IN ('product', 'service', 'user')),
    target_id UUID NOT NULL,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- TABLA: chat_messages (Mensajes de Chat)
-- ========================================
CREATE TABLE IF NOT EXISTS chat_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
    receiver_id UUID REFERENCES users(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    read_status BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- ÍNDICES para mejor rendimiento
-- ========================================
CREATE INDEX IF NOT EXISTS idx_products_seller ON products(seller_id);
CREATE INDEX IF NOT EXISTS idx_products_municipio ON products(municipio);
CREATE INDEX IF NOT EXISTS idx_services_provider ON services(provider_id);
CREATE INDEX IF NOT EXISTS idx_services_municipio ON services(municipio);
CREATE INDEX IF NOT EXISTS idx_jobs_employer ON jobs(employer_id);
CREATE INDEX IF NOT EXISTS idx_jobs_status ON jobs(status);
CREATE INDEX IF NOT EXISTS idx_orders_user ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_target ON reviews(target_type, target_id);
CREATE INDEX IF NOT EXISTS idx_chat_sender ON chat_messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_chat_receiver ON chat_messages(receiver_id);

-- ========================================
-- ROW LEVEL SECURITY (RLS)
-- ========================================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;

-- Eliminar políticas existentes si existen
DROP POLICY IF EXISTS "Public can view products" ON products;
DROP POLICY IF EXISTS "Users can insert own products" ON products;
DROP POLICY IF EXISTS "Users can update own products" ON products;
DROP POLICY IF EXISTS "Public can view services" ON services;
DROP POLICY IF EXISTS "Users can insert own services" ON services;
DROP POLICY IF EXISTS "Public can view jobs" ON jobs;
DROP POLICY IF EXISTS "Users can insert own jobs" ON jobs;

-- Políticas básicas (todos pueden leer, solo dueños pueden modificar)
CREATE POLICY "Public can view products" ON products FOR SELECT USING (true);
CREATE POLICY "Users can insert own products" ON products FOR INSERT WITH CHECK (auth.uid() = seller_id);
CREATE POLICY "Users can update own products" ON products FOR UPDATE USING (auth.uid() = seller_id);

CREATE POLICY "Public can view services" ON services FOR SELECT USING (true);
CREATE POLICY "Users can insert own services" ON services FOR INSERT WITH CHECK (auth.uid() = provider_id);

CREATE POLICY "Public can view jobs" ON jobs FOR SELECT USING (true);
CREATE POLICY "Users can insert own jobs" ON jobs FOR INSERT WITH CHECK (auth.uid() = employer_id);

-- ========================================
-- DATOS INICIALES - Productos de Ejemplo
-- ========================================
-- Insertar solo si no existen productos
INSERT INTO products (name, price, category, description, municipio, barrio, rating, stock, status, image_url)
SELECT * FROM (VALUES
    ('Dulce de Leche Artesanal', 150.00, 'Postres', 'Hecho con leche fresca dominicana', 'Santo Domingo', 'Piantini', 4.7, 50, 'active', 'assets/images/dulce-leche.png'),
    ('Guayabera Premium', 2500.00, 'Ropa', 'Lino 100% blanco', 'Santo Domingo', 'Piantini', 4.5, 15, 'active', 'assets/images/guayabera.png'),
    ('Muñeca Limé', 800.00, 'Artesanía', 'Artesanía típica dominicana', 'Santo Domingo', 'Piantini', 5.0, 30, 'active', 'assets/images/muneca-lime.png')
) AS v(name, price, category, description, municipio, barrio, rating, stock, status, image_url)
WHERE NOT EXISTS (SELECT 1 FROM products LIMIT 1);

-- ========================================
-- DATOS INICIALES - Servicios de Ejemplo
-- ========================================
INSERT INTO services (name, price, category, description, municipio, barrio, availability, rating, status)
SELECT * FROM (VALUES
    ('Reparación de Fugas', 1500.00, 'Plomería', 'Reparación rápida 24/7', 'Santiago', 'Centro', '24/7', 4.9, 'active'),
    ('Instalación de Baños', 3000.00, 'Plomería', 'Instalación completa profesional', 'Santiago', 'Centro', 'Lun-Sab', 4.8, 'active'),
    ('Corte de Cabello', 300.00, 'Barbería', 'Corte moderno y clásico', 'Santiago', 'Centro', 'Lun-Dom', 4.7, 'active')
) AS v(name, price, category, description, municipio, barrio, availability, rating, status)
WHERE NOT EXISTS (SELECT 1 FROM services LIMIT 1);

-- ========================================
-- DATOS INICIALES - Empleos de Ejemplo
-- ========================================
INSERT INTO jobs (title, type, pay, pay_per, description, municipio, barrio, status)
SELECT * FROM (VALUES
    ('Ayudante de Construcción', 'Por Hora', 250.00, 'hora', 'Se busca ayudante para obra en construcción', 'Santo Domingo', 'Naco', 'active'),
    ('Delivery de Comida', 'Por Servicio', 150.00, 'entrega', 'Delivery con motor propio', 'Santo Domingo', 'Zona Colonial', 'active')
) AS v(title, type, pay, pay_per, description, municipio, barrio, status)
WHERE NOT EXISTS (SELECT 1 FROM jobs LIMIT 1);

-- ========================================
-- COMPLETADO
-- ========================================
-- Base de datos lista para ServiMarket RD
-- Los productos, servicios y empleos de ejemplo se insertarán automáticamente
