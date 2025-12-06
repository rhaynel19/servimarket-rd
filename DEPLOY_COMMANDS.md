# 🚀 COMANDOS RÁPIDOS - Copy & Paste

## PASO 4: Git (Ejecuta en PowerShell)

```powershell
# 1. Navegar a la carpeta del proyecto
cd "C:\Users\pc\Desktop\info\Fraimel\Proyectos DS\marketplace_php"

# 2. Inicializar Git
git init

# 3. Agregar todos los archivos
git add .

# 4. Hacer commit
git commit -m "Initial commit - ServiMarket RD production ready"

# 5. Crear rama main
git branch -M main

# 6. Conectar con GitHub (REEMPLAZA TU_USUARIO)
git remote add origin https://github.com/TU_USUARIO/servimarket-rd.git

# 7. Subir código
git push -u origin main
```

## NOTAS IMPORTANTES:

### Para Paso 1 (Supabase):
- Ya tienes Supabase abierto en tu navegador
- Click en "Start your project"
- Usa región: **South America (São Paulo)**
- Guarda la contraseña de la base de datos

### Para Paso 2 (Configuración):
Archivo a editar: `assets/js/supabase-config.js`

Reemplaza las líneas 7-8 con tus credenciales de Supabase.

### Para Paso 3 (Probar):
1. Abre `index.html` en navegador
2. F12 para ver consola
3. Debe decir: "✅ Supabase configurado"

### Para Paso 5 (Vercel):
1. Ve a https://vercel.com
2. Sign up con GitHub
3. Import repository
4. Deploy!

## ⚡ ORDEN DE EJECUCIÓN:

1. ✅ Supabase (ya abierto) → Crear proyecto → Ejecutar database.sql
2. ✅ Copiar credenciales → Actualizar supabase-config.js
3. ✅ Probar en navegador local
4. ✅ Ejecutar comandos Git arriba ⬆️
5. ✅ Deploy en Vercel

## 🎯 RESULTADO FINAL:

Tu app estará en: `https://servimarket-rd.vercel.app`
Costo: $0/mes
Tiempo total: ~30 minutos
