# 🚀 GUÍA RÁPIDA DE DEPLOYMENT - 30 MINUTOS

## 📍 PASO 1: SUPABASE (10 min)

### 1.1 Crear Cuenta y Proyecto
1. **Abre:** https://supabase.com
2. **Click:** "Start your project"
3. **Sign up** con GitHub (recomendado)
4. **New Project:**
   - Name: `servimarket-rd`
   - Password: [crea una segura y guárdala]
   - Region: **South America (São Paulo)**
   - Plan: **Free**
5. **Espera** 2-3 minutos mientras se crea

### 1.2 Ejecutar Base de Datos
1. **Menú lateral** → **SQL Editor**
2. **Click** "New query"
3. **Abre** el archivo `database.sql` de tu proyecto
4. **Copia TODO** (Ctrl+A, Ctrl+C)
5. **Pega** en Supabase (Ctrl+V)
6. **Click** "Run" (botón verde)
7. ✅ Verás: "Success. No rows returned"

### 1.3 Copiar Credenciales
1. **Menú lateral** → **Settings** (⚙️) → **API**
2. **Copia estos dos valores:**

```
Project URL: https://xxxxx.supabase.co
anon public: eyJhbGc...
```

### 1.4 Actualizar App
1. **Abre:** `assets/js/supabase-config.js`
2. **Reemplaza líneas 7-8:**

```javascript
const SUPABASE_URL = 'https://TU-PROYECTO.supabase.co';  // ← PEGA AQUÍ
const SUPABASE_ANON_KEY = 'eyJhbGc...';  // ← PEGA AQUÍ
```

3. **Guarda** (Ctrl+S)

---

## 📍 PASO 2: TESTING LOCAL (5 min)

### 2.1 Probar App
1. **Abre** `index.html` en navegador
2. **Presiona F12** (consola)
3. **Verifica:** Debe decir "✅ Supabase configurado"

### 2.2 Crear Usuario CEO
1. **Click** "Registrarse"
2. **Completa:**
   ```
   Email: ceo@servimarketrd.com
   Nombre: [Tu Nombre]
   Contraseña: [segura]
   Rol: Cliente
   Municipio: Santo Domingo
   ```
3. **Click** "Registrarse"

### 2.3 Convertir a Admin
1. **Ve a Supabase** → **Table Editor** → **users**
2. **Busca** tu email
3. **Edita** columna `role`: `cliente` → **`admin`**
4. **Save**

### 2.4 Probar Panel CEO
1. **Login** con tu email/password
2. **Navega** a `admin.html`
3. ✅ Deberías ver el panel CEO

---

## 📍 PASO 3: GITHUB (5 min)

### 3.1 Inicializar Git
**Abre PowerShell en la carpeta del proyecto:**

```powershell
cd "C:\Users\pc\Desktop\info\Fraimel\Proyectos DS\marketplace_php"
git init
git add .
git commit -m "Initial commit - ServiMarket RD"
git branch -M main
```

### 3.2 Crear Repositorio
1. **Abre:** https://github.com/new
2. **Completa:**
   - Repository name: `servimarket-rd`
   - Description: `Marketplace dominicano completo`
   - Public o Private (tu elección)
   - ❌ NO marques "Add README"
3. **Click** "Create repository"

### 3.3 Push Código
**Copia los comandos que GitHub muestra:**

```powershell
git remote add origin https://github.com/TU_USUARIO/servimarket-rd.git
git push -u origin main
```

---

## 📍 PASO 4: VERCEL (5 min)

### 4.1 Crear Cuenta
1. **Abre:** https://vercel.com
2. **Click** "Sign Up"
3. **Selecciona** "Continue with GitHub"
4. **Autoriza** Vercel

### 4.2 Importar Proyecto
1. **Click** "New Project"
2. **Busca** "servimarket-rd"
3. **Click** "Import"

### 4.3 Configurar
- Framework Preset: **None**
- Root Directory: `./`
- Build Command: (dejar vacío)
- Output Directory: `./`

### 4.4 Deploy
1. **Click** "Deploy"
2. ⏳ **Espera** 1-2 minutos
3. ✅ **¡Listo!**

---

## 🎉 ¡COMPLETADO!

### Tu App Está Viva:
```
https://servimarket-rd.vercel.app
```

### Verifica:
- ✅ Página principal carga
- ✅ Puedes registrarte
- ✅ Panel CEO accesible en `/admin.html`

---

## 📊 Resumen de Tiempos

| Paso | Tiempo | Status |
|------|--------|--------|
| Supabase | 10 min | ⏳ Pendiente |
| Testing | 5 min | ⏳ Pendiente |
| GitHub | 5 min | ⏳ Pendiente |
| Vercel | 5 min | ⏳ Pendiente |
| **TOTAL** | **25 min** | |

---

## 🆘 Troubleshooting

### Error: "supabase is not defined"
- Verifica credenciales en `supabase-config.js`
- Recarga página (Ctrl+F5)

### Error: "Failed to fetch"
- Verifica que ejecutaste `database.sql`
- Verifica credenciales correctas

### GitHub push falla
- Verifica que creaste el repo
- Verifica la URL del remote

---

## ✅ Checklist Final

- [ ] Supabase configurado
- [ ] Usuario CEO creado (rol admin)
- [ ] Código en GitHub
- [ ] App desplegada en Vercel
- [ ] URL funcionando
- [ ] Panel CEO accesible

**¿Listo para empezar?** 🚀
