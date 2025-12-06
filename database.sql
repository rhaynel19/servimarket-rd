-- ServiMarket RD - Database Schema for Supabase
-- Ejecuta este script en el SQL Editor de Supabase

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========================================
-- TABLA: users (Usuarios)
-- ========================================
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255), -- Supabase Auth maneja esto
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
CREATE TABLE products (
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
CREATE TABLE services (
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
CREATE TABLE jobs (
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
CREATE TABLE orders (
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
CREATE TABLE order_items (
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
CREATE TABLE service_requests (
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
CREATE TABLE job_applications (
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
CREATE TABLE reviews (
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
CREATE TABLE chat_messages (
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
CREATE INDEX idx_products_seller ON products(seller_id);
CREATE INDEX idx_products_municipio ON products(municipio);
CREATE INDEX idx_services_provider ON services(provider_id);
CREATE INDEX idx_services_municipio ON services(municipio);
CREATE INDEX idx_jobs_employer ON jobs(employer_id);
CREATE INDEX idx_jobs_status ON jobs(status);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_reviews_target ON reviews(target_type, target_id);
CREATE INDEX idx_chat_sender ON chat_messages(sender_id);
CREATE INDEX idx_chat_receiver ON chat_messages(receiver_id);

-- ========================================
-- FUNCIONES para actualizar updated_at
-- ========================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger a tablas relevantes
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON services
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ========================================
-- ROW LEVEL SECURITY (RLS)
-- ========================================
-- Habilitar RLS en todas las tablas
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;

-- Políticas básicas (todos pueden leer, solo dueños pueden modificar)
CREATE POLICY "Public can view products" ON products FOR SELECT USING (true);
CREATE POLICY "Users can insert own products" ON products FOR INSERT WITH CHECK (auth.uid() = seller_id);
CREATE POLICY "Users can update own products" ON products FOR UPDATE USING (auth.uid() = seller_id);

CREATE POLICY "Public can view services" ON services FOR SELECT USING (true);
CREATE POLICY "Users can insert own services" ON services FOR INSERT WITH CHECK (auth.uid() = provider_id);

CREATE POLICY "Public can view jobs" ON jobs FOR SELECT USING (true);
CREATE POLICY "Users can insert own jobs" ON jobs FOR INSERT WITH CHECK (auth.uid() = employer_id);

-- ========================================
-- DATOS INICIALES (Opcional - para testing)
-- ========================================
-- Nota: Los usuarios se crearán a través de Supabase Auth
-- Estos son solo ejemplos de productos/servicios

INSERT INTO products (name, price, category, description, municipio, barrio, rating, stock) VALUES
('Dulce de Leche Artesanal', 150.00, 'Postres', 'Hecho con leche fresca dominicana', 'Santo Domingo', 'Piantini', 4.7, 50),
('Guayabera Premium', 2500.00, 'Ropa', 'Lino 100% blanco', 'Santo Domingo', 'Piantini', 4.5, 15),
('Muñeca Limé', 800.00, 'Artesanía', 'Artesanía típica dominicana', 'Santo Domingo', 'Piantini', 5.0, 30);

INSERT INTO services (name, price, category, description, municipio, barrio, availability, rating) VALUES
('Reparación de Fugas', 1500.00, 'Plomería', 'Reparación rápida 24/7', 'Santiago', 'Centro', '24/7', 4.9),
('Instalación de Baños', 3000.00, 'Plomería', 'Instalación completa profesional', 'Santiago', 'Centro', 'Lun-Sab', 4.8),
('Corte de Cabello', 300.00, 'Barbería', 'Corte moderno y clásico', 'Santiago', 'Centro', 'Lun-Dom', 4.7);

INSERT INTO jobs (title, type, pay, pay_per, description, municipio, barrio) VALUES
('Ayudante de Construcción', 'Por Hora', 250.00, 'hora', 'Se busca ayudante para obra en construcción', 'Santo Domingo', 'Naco'),
('Delivery de Comida', 'Por Servicio', 150.00, 'entrega', 'Delivery con motor propio', 'Santo Domingo', 'Zona Colonial');

-- ========================================
-- COMPLETADO
-- ========================================
-- Base de datos lista para ServiMarket RD
-- Próximo paso: Configurar autenticación en Supabase Dashboard
