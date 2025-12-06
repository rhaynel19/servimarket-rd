// Lógica del Carrito de Compras

function updateCartCount() {
    let cart = JSON.parse(localStorage.getItem('cart')) || [];
    let count = cart.reduce((acc, item) => acc + item.cantidad, 0);
    let badge = document.getElementById('cart-count');
    if (badge) {
        badge.innerText = count > 0 ? `(${count})` : '';
    }
}

function renderCart() {
    let cart = JSON.parse(localStorage.getItem('cart')) || [];
    let container = document.getElementById('cart-items');
    let totalSpan = document.getElementById('cart-total');

    if (!container) return;

    container.innerHTML = '';
    let total = 0;

    if (cart.length === 0) {
        container.innerHTML = '<p>Tu carrito está vacío.</p>';
        if (totalSpan) totalSpan.innerText = '0.00';
        return;
    }

    cart.forEach((item, index) => {
        let subtotal = item.precio * item.cantidad;
        total += subtotal;

        let div = document.createElement('div');
        div.className = 'cart-item';
        div.style.borderBottom = '1px solid #eee';
        div.style.padding = '10px 0';
        div.style.display = 'flex';
        div.style.justifyContent = 'space-between';
        div.style.alignItems = 'center';

        div.innerHTML = `
            <div>
                <strong>${item.nombre}</strong><br>
                RD$ ${item.precio.toFixed(2)} x ${item.cantidad}
            </div>
            <div>
                RD$ ${subtotal.toFixed(2)}
                <button onclick="removeFromCart(${index})" class="btn btn-danger" style="padding: 2px 8px; margin-left: 10px;">X</button>
            </div>
        `;
        container.appendChild(div);
    });

    if (totalSpan) totalSpan.innerText = total.toFixed(2);
}

function removeFromCart(index) {
    let cart = JSON.parse(localStorage.getItem('cart')) || [];
    cart.splice(index, 1);
    localStorage.setItem('cart', JSON.stringify(cart));
    renderCart();
    updateCartCount();
}

function clearCart() {
    localStorage.removeItem('cart');
    renderCart();
    updateCartCount();
}

// Inicializar
document.addEventListener('DOMContentLoaded', () => {
    updateCartCount();
    renderCart();

    // Si estamos en checkout, llenar el input oculto
    let checkoutInput = document.getElementById('cart-data');
    if (checkoutInput) {
        let cart = JSON.parse(localStorage.getItem('cart')) || [];
        if (cart.length === 0) {
            alert('El carrito está vacío');
            window.location.href = 'index.php';
        }
        checkoutInput.value = JSON.stringify(cart);
    }
});

// Validación de Tarjeta (Simulada)
document.addEventListener('input', function (e) {
    if (e.target.placeholder === '0000 0000 0000 0000') {
        let value = e.target.value.replace(/\D/g, '');
        e.target.value = value.replace(/(\d{4})(?=\d)/g, '$1 ');
    }
});

document.getElementById('checkout-form')?.addEventListener('submit', function (e) {
    let metodo = document.getElementById('metodo_pago').value;
    if (metodo === 'tarjeta') {
        let cardInput = document.querySelector('input[placeholder="0000 0000 0000 0000"]');
        if (cardInput && cardInput.value.replace(/\s/g, '').length < 16) {
            e.preventDefault();
            alert('Por favor ingrese un número de tarjeta válido (16 dígitos).');
        }
    }
});

