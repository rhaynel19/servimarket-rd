/**
 * ServiMarket RD - Supabase Configuration
 * 
 * INSTRUCCIONES:
 * 1. Ve a tu proyecto en Supabase (https://supabase.com)
 * 2. Settings → API
 * 3. Copia el "Project URL" y "anon public" key
 * 4. Reemplaza los valores abajo con TUS credenciales
 */

// ⚠️ REEMPLAZA ESTOS VALORES CON LOS TUYOS
const SUPABASE_URL = 'https://teltguzvcwdedrkpsbxz.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable__wCr-KJ0Nv1BcRfHzycS1A_qdwG7XiC';

// Inicializar cliente de Supabase
const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Verificar conexión
console.log('✅ Supabase configurado:', SUPABASE_URL);
