# 🇩🇴 ServiMarket RD

**Marketplace completo dominicano de productos, servicios y empleos**

[![Deploy](https://img.shields.io/badge/Deploy-Vercel-black)](https://vercel.com)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## 🌟 Características

- 🛍️ **Marketplace de Productos** - Compra y vende productos locales
- 🔧 **Servicios Profesionales** - Encuentra plomeros, electricistas, barberos y más
- 💼 **Empleos** - Publica y aplica a trabajos por hora o servicio
- 📊 **Panel de Negocio** - Gestiona tu inventario y ventas
- 📍 **Geolocalización** - Filtra por municipio y barrio
- ⭐ **Reviews y Ratings** - Sistema de calificaciones
- 💬 **Chat** - Comunicación entre usuarios
- 💳 **Múltiples Métodos de Pago** - Tarjeta, efectivo, contra entrega

## 🚀 Demo

**URL:** [https://servimarket-rd.vercel.app](https://servimarket-rd.vercel.app) *(actualizar con tu URL)*

**Credenciales de prueba:**
- Email: `carlos@test.com`
- Password: `123`

## 🛠️ Tecnologías

- **Frontend:** HTML5, CSS3, JavaScript (ES6+)
- **Backend:** Supabase (PostgreSQL + Auth + Storage)
- **Hosting:** Vercel
- **Imágenes:** Cloudinary
- **Emails:** SendGrid

## 📋 Requisitos Previos

- Cuenta en [Supabase](https://supabase.com) (gratis)
- Cuenta en [Vercel](https://vercel.com) (gratis)
- Git instalado

## ⚡ Inicio Rápido

### 1. Clonar el Repositorio

```bash
git clone https://github.com/TU_USUARIO/servimarket-rd.git
cd servimarket-rd
```

### 2. Configurar Supabase

1. Crea un proyecto en [Supabase](https://supabase.com)
2. En el SQL Editor, ejecuta el contenido de `database.sql`
3. Ve a Settings → API y copia:
   - `Project URL`
   - `anon public key`

### 3. Configurar Variables

Edita `assets/js/supabase-config.js`:

```javascript
const SUPABASE_URL = 'https://tu-proyecto.supabase.co';
const SUPABASE_ANON_KEY = 'tu-clave-aqui';
```

### 4. Probar Localmente

Abre `index.html` en tu navegador o usa un servidor local:

```bash
# Con Python
python -m http.server 8000

# Con Node.js
npx serve
```

### 5. Deploy en Vercel

```bash
# Instalar Vercel CLI
npm i -g vercel

# Deploy
vercel
```

O conecta tu repositorio de GitHub en [vercel.com](https://vercel.com).

## 📁 Estructura del Proyecto

```
servimarket-rd/
├── assets/
│   ├── css/
│   │   └── style.css          # Estilos globales
│   └── js/
│       ├── app.js             # Lógica principal
│       └── supabase-config.js # Configuración Supabase
├── index.html                 # Página principal
├── login.html                 # Login
├── register.html              # Registro
├── services.html              # Servicios
├── jobs.html                  # Empleos
├── dashboard.html             # Panel de negocio
├── cart.html                  # Carrito
├── checkout.html              # Checkout
├── terms.html                 # Términos y condiciones
├── privacy.html               # Política de privacidad
├── database.sql               # Schema de base de datos
├── vercel.json                # Configuración Vercel
└── README.md                  # Este archivo
```

## 🗄️ Base de Datos

El schema completo está en `database.sql`. Incluye tablas para:

- `users` - Usuarios (vendedores, proveedores, clientes)
- `products` - Productos
- `services` - Servicios
- `jobs` - Empleos
- `orders` - Pedidos
- `reviews` - Reseñas
- `chat_messages` - Mensajes
- `job_applications` - Aplicaciones a empleos

## 🔐 Seguridad

- ✅ Autenticación con Supabase Auth
- ✅ Row Level Security (RLS) habilitado
- ✅ Validación de inputs
- ✅ HTTPS obligatorio en producción
- ✅ Sanitización de datos

## 📱 Responsive

La aplicación es completamente responsive y funciona en:
- 📱 Móviles (iOS/Android)
- 💻 Tablets
- 🖥️ Desktop

## 🤝 Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -m 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver `LICENSE` para más detalles.

## 📞 Soporte

- **Email:** soporte@servimarketrd.com
- **Issues:** [GitHub Issues](https://github.com/TU_USUARIO/servimarket-rd/issues)

## 🙏 Agradecimientos

- Diseño inspirado en marketplaces modernos
- Iconos de emojis nativos
- Comunidad de desarrolladores dominicanos

---

**Hecho con ❤️ en República Dominicana 🇩🇴**
