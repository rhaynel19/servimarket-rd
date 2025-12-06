# Guía de Pruebas: Marketplace Dominicano

Dado que PHP y MySQL requieren un servidor para funcionar, sigue estos pasos para probar tu aplicación en **XAMPP**.

## 1. Preparar el Entorno
1.  Asegúrate de tener **XAMPP** instalado y abierto.
2.  En el panel de XAMPP, inicia los módulos **Apache** y **MySQL** (Botones "Start").

## 2. Instalar la Aplicación
1.  Ve a la carpeta donde generé el código: `.../Proyecto 1 Rendimiento Academico/marketplace_php`.
2.  Copia la carpeta completa `marketplace_php`.
3.  Pégala dentro de la carpeta `htdocs` de tu instalación de XAMPP (usualmente `C:\xampp\htdocs\`).
    - Deberías tener: `C:\xampp\htdocs\marketplace_php`.

## 3. Configurar la Base de Datos
1.  Abre tu navegador y ve a: [http://localhost/phpmyadmin](http://localhost/phpmyadmin).
2.  Haz clic en **"Nueva"** en la barra lateral izquierda.
3.  Escribe el nombre de la base de datos: `marketplace_db` y dale a **Crear**.
4.  Selecciona la base de datos recién creada.
5.  Ve a la pestaña **"Importar"** (arriba).
6.  Selecciona el archivo `database.sql` que está dentro de la carpeta `marketplace_php` que copiaste.
7.  Haz clic en **"Continuar"** (abajo del todo).
    - *Deberías ver un mensaje verde indicando que las tablas se crearon correctamente.*

## 4. Ejecutar la Prueba
Abre tu navegador y visita: [http://localhost/marketplace_php](http://localhost/marketplace_php)

### Escenarios de Prueba Recomendados:

#### A. Registro de Vendedor
1.  Ve a "Registrarse".
2.  Llena los datos y selecciona **Tipo de Cuenta: Vendedor**.
3.  Ingresa el nombre de tu negocio (ej. "Postres Doña Juana").
4.  Inicia sesión con tu nuevo usuario.
5.  Ve a "Mis Productos" y agrega un producto con foto.

#### B. Compra como Cliente
1.  Abre una **Ventana de Incógnito** (para no cerrar la sesión del vendedor).
2.  Ve a [http://localhost/marketplace_php](http://localhost/marketplace_php).
3.  Regístrate como **Cliente**.
4.  Busca el producto que creó el vendedor.
5.  Agrégalo al carrito.
6.  Ve al Carrito y procede al Pago.
7.  Elige "Efectivo" o "Tarjeta" (prueba la validación de tarjeta con números falsos).
8.  Confirma el pedido.

#### C. Verificar Pedido
1.  En la ventana del Cliente, ve a "Mis Pedidos" para ver el estado.
2.  Vuelve a la ventana del Vendedor y recarga el "Panel". Verás que aumentaron tus ingresos y ventas.

---
**Nota:** Si tienes problemas de conexión a la base de datos, abre el archivo `includes/db.php` y verifica que el usuario sea `root` y la contraseña esté vacía (configuración por defecto de XAMPP).
