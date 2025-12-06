# Script para actualizar todos los HTML con Supabase
# Este script agrega los scripts de Supabase a todos los archivos HTML

$files = @(
    "login.html",
    "register.html",
    "services.html",
    "jobs.html",
    "dashboard.html",
    "cart.html",
    "checkout.html",
    "product.html",
    "service-detail.html"
)

$supabaseScripts = @"
    <!-- Supabase Client -->
    <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
    <script src="assets/js/supabase-config.js"></script>
"@

foreach ($file in $files) {
    $path = "c:\Users\pc\Desktop\info\Fraimel\Proyectos DS\marketplace_php\$file"
    
    if (Test-Path $path) {
        $content = Get-Content $path -Raw
        
        # Solo agregar si no existe ya
        if ($content -notmatch "supabase-config.js") {
            # Buscar la línea con app.js y agregar antes
            $content = $content -replace '(\s*<script src="assets/js/app.js">)', "$supabaseScripts`n`$1"
            Set-Content -Path $path -Value $content -NoNewline
            Write-Host "✅ Actualizado: $file"
        } else {
            Write-Host "⏭️  Ya tiene Supabase: $file"
        }
    } else {
        Write-Host "❌ No encontrado: $file"
    }
}

Write-Host "`n✨ Proceso completado!"
