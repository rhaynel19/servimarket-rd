/**
 * ServiMarket RD - Core Logic with Supabase
 * Production-ready version using real backend
 */

// --- Geolocation Data ---
const GEO = {
    municipios: {
        'Santo Domingo': ['Zona Colonial', 'Naco', 'Piantini', 'Gazcue', 'Los Mina'],
        'Santiago': ['Centro', 'Gurabo', 'Cienfuegos', 'Los Jardines'],
        'La Romana': ['Centro', 'Caleta', 'Cumayasa'],
        'Puerto Plata': ['Centro', 'Playa Dorada', 'Sosúa'],
        'San Cristóbal': ['Centro', 'Villa Altagracia', 'Haina']
    }
};

// --- Database with Supabase ---
const db = {
    // Get all records from a table
    get: async (table) => {
        try {
            const { data, error } = await supabase.from(table).select('*');
            if (error) throw error;
            return data || [];
        } catch (error) {
            console.error(`Error getting ${table}:`, error);
            return [];
        }
    },

    // Add a new record
    add: async (table, item) => {
        try {
            const { data, error } = await supabase.from(table).insert([item]).select();
            if (error) throw error;
            return data[0];
        } catch (error) {
            console.error(`Error adding to ${table}:`, error);
            throw error;
        }
    },

    // Update a record
    update: async (table, id, updates) => {
        try {
            const { data, error } = await supabase
                .from(table)
                .update(updates)
                .eq('id', id)
                .select();
            if (error) throw error;
            return data[0];
        } catch (error) {
            console.error(`Error updating ${table}:`, error);
            return null;
        }
    },

    // Delete a record
    delete: async (table, id) => {
        try {
            const { error } = await supabase.from(table).delete().eq('id', id);
            if (error) throw error;
            return true;
        } catch (error) {
            console.error(`Error deleting from ${table}:`, error);
            return false;
        }
    },

    // Find records with a condition
    find: async (table, column, value) => {
        try {
            const { data, error } = await supabase.from(table).select('*').eq(column, value);
            if (error) throw error;
            return data || [];
        } catch (error) {
            console.error(`Error finding in ${table}:`, error);
            return [];
        }
    },

    // Find one record
    findOne: async (table, column, value) => {
        try {
            const { data, error } = await supabase.from(table).select('*').eq(column, value).single();
            if (error) throw error;
            return data;
        } catch (error) {
            console.error(`Error finding one in ${table}:`, error);
            return null;
        }
    }
};

// --- Authentication with Supabase ---
const auth = {
    // Register new user
    register: async (userData) => {
        try {
            // Create auth user
            const { data: authData, error: authError } = await supabase.auth.signUp({
                email: userData.email,
                password: userData.password,
            });

            if (authError) throw authError;

            // Create user profile
            const { error: profileError } = await supabase.from('users').insert([{
                id: authData.user.id,
                email: userData.email,
                name: userData.name,
                role: userData.role || 'cliente',
                phone: userData.phone,
                municipio: userData.municipio,
                barrio: userData.barrio,
                description: userData.description || '',
                rating: 5.0,
                review_count: 0
            }]);

            if (profileError) throw profileError;

            ui.toast('¡Registro exitoso! Revisa tu email para confirmar.');
            return authData.user;
        } catch (error) {
            console.error('Error en registro:', error);
            throw new Error(error.message || 'Error al registrar usuario');
        }
    },

    // Login user
    login: async (email, password) => {
        try {
            const { data, error } = await supabase.auth.signInWithPassword({
                email,
                password
            });

            if (error) throw error;

            // Get user profile
            const profile = await db.findOne('users', 'id', data.user.id);

            if (profile) {
                localStorage.setItem('currentUser', JSON.stringify(profile));
                return profile;
            }

            return null;
        } catch (error) {
            console.error('Error en login:', error);
            return null;
        }
    },

    // Logout
    logout: async () => {
        try {
            await supabase.auth.signOut();
            localStorage.removeItem('currentUser');
            window.location.href = 'index.html';
        } catch (error) {
            console.error('Error en logout:', error);
        }
    },

    // Get current user
    getCurrentUser: () => {
        return JSON.parse(localStorage.getItem('currentUser'));
    },

    // Update profile
    updateProfile: async (updates) => {
        const user = auth.getCurrentUser();
        if (user) {
            const updated = await db.update('users', user.id, updates);
            if (updated) {
                localStorage.setItem('currentUser', JSON.stringify(updated));
            }
            return updated;
        }
        return null;
    },

    // Check if user is logged in
    isLoggedIn: async () => {
        const { data } = await supabase.auth.getSession();
        return data.session !== null;
    }
};

// --- Cart Logic (Still using LocalStorage for cart) ---
const cart = {
    get: () => JSON.parse(localStorage.getItem('cart')) || [],

    add: (product) => {
        const items = cart.get();
        const existing = items.find(i => i.id === product.id);
        if (existing) {
            existing.quantity++;
        } else {
            items.push({ ...product, quantity: 1 });
        }
        localStorage.setItem('cart', JSON.stringify(items));
        ui.updateCartCount();
        ui.toast(`¡${product.name} añadido al carrito!`);
    },

    remove: (id) => {
        const items = cart.get().filter(i => i.id !== id);
        localStorage.setItem('cart', JSON.stringify(items));
        ui.updateCartCount();
    },

    clear: () => {
        localStorage.setItem('cart', JSON.stringify([]));
        ui.updateCartCount();
    },

    total: () => cart.get().reduce((sum, item) => sum + (item.price * item.quantity), 0),
    count: () => cart.get().reduce((sum, item) => sum + item.quantity, 0)
};

// --- Reviews System ---
const reviews = {
    add: async (targetType, targetId, rating, comment) => {
        const user = auth.getCurrentUser();
        if (!user) throw new Error("Debes iniciar sesión");

        const review = {
            target_type: targetType,
            target_id: targetId,
            user_id: user.id,
            rating,
            comment
        };

        await db.add('reviews', review);
        await reviews.updateRating(targetType, targetId);
        return review;
    },

    getFor: async (targetType, targetId) => {
        const allReviews = await db.get('reviews');
        return allReviews.filter(r => r.target_type === targetType && r.target_id === targetId);
    },

    updateRating: async (targetType, targetId) => {
        const targetReviews = await reviews.getFor(targetType, targetId);
        if (targetReviews.length === 0) return;

        const avgRating = targetReviews.reduce((sum, r) => sum + r.rating, 0) / targetReviews.length;
        const table = targetType === 'user' ? 'users' : targetType === 'product' ? 'products' : 'services';

        await db.update(table, targetId, {
            rating: Math.round(avgRating * 10) / 10,
            review_count: targetReviews.length
        });
    }
};

// --- Chat System ---
const chat = {
    send: async (receiverId, message) => {
        const user = auth.getCurrentUser();
        if (!user) throw new Error("Debes iniciar sesión");

        const msg = {
            sender_id: user.id,
            receiver_id: receiverId,
            message,
            read_status: false
        };

        return await db.add('chat_messages', msg);
    },

    getConversation: async (userId1, userId2) => {
        const messages = await db.get('chat_messages');
        return messages.filter(m =>
            (m.sender_id === userId1 && m.receiver_id === userId2) ||
            (m.sender_id === userId2 && m.receiver_id === userId1)
        ).sort((a, b) => new Date(a.created_at) - new Date(b.created_at));
    }
};

// --- Jobs System ---
const jobs = {
    post: async (jobData) => {
        const user = auth.getCurrentUser();
        if (!user) throw new Error("Debes iniciar sesión");

        jobData.employer_id = user.id;
        jobData.status = 'active';

        return await db.add('jobs', jobData);
    },

    apply: async (jobId) => {
        const user = auth.getCurrentUser();
        if (!user) throw new Error("Debes iniciar sesión");

        const application = {
            job_id: jobId,
            applicant_id: user.id,
            status: 'pending'
        };

        return await db.add('job_applications', application);
    },

    getApplications: async (jobId) => {
        return await db.find('job_applications', 'job_id', jobId);
    }
};

// --- UI Helpers ---
const ui = {
    formatCurrency: (amount) => new Intl.NumberFormat('es-DO', { style: 'currency', currency: 'DOP' }).format(amount),

    toast: (msg, type = 'success') => {
        const toast = document.createElement('div');
        toast.style.cssText = `
            position: fixed; bottom: 20px; right: 20px; 
            background: ${type === 'error' ? '#ef4444' : type === 'warning' ? '#f59e0b' : '#10b981'}; 
            color: white; padding: 1rem 2rem; border-radius: 8px; 
            box-shadow: 0 4px 6px rgba(0,0,0,0.1); z-index: 10000;
            animation: slideUp 0.3s ease-out; font-weight: 600;
        `;
        toast.textContent = msg;
        document.body.appendChild(toast);
        setTimeout(() => {
            toast.style.opacity = '0';
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    },

    updateCartCount: () => {
        const el = document.getElementById('cart-count');
        if (el) {
            const count = cart.count();
            el.textContent = count > 0 ? `(${count})` : '';
        }
    },

    renderStars: (rating) => {
        const full = Math.floor(rating);
        const half = rating % 1 >= 0.5 ? 1 : 0;
        const empty = 5 - full - half;
        return '★'.repeat(full) + (half ? '½' : '') + '☆'.repeat(empty);
    },

    checkAuthElements: () => {
        const user = auth.getCurrentUser();
        const navUl = document.querySelector('nav ul');
        if (!navUl) return;

        if (user) {
            const loginLink = navUl.querySelector('a[href="login.html"]');
            const registerLink = navUl.querySelector('a[href="register.html"]');
            if (loginLink) loginLink.parentElement.remove();
            if (registerLink) registerLink.parentElement.remove();

            if (!navUl.querySelector('a[href="dashboard.html"]')) {
                const liDash = document.createElement('li');
                liDash.innerHTML = `<a href="dashboard.html">Mi Negocio</a>`;
                navUl.appendChild(liDash);
            }
            if (!navUl.querySelector('#logout-btn')) {
                const liLogout = document.createElement('li');
                liLogout.innerHTML = `<a href="#" id="logout-btn">Salir</a>`;
                liLogout.querySelector('a').onclick = (e) => { e.preventDefault(); auth.logout(); };
                navUl.appendChild(liLogout);
            }
        }
    }
};

// --- Initialization ---
document.addEventListener('DOMContentLoaded', async () => {
    ui.updateCartCount();
    ui.checkAuthElements();

    // Check auth session
    const { data } = await supabase.auth.getSession();
    if (data.session) {
        const profile = await db.findOne('users', 'id', data.session.user.id);
        if (profile) {
            localStorage.setItem('currentUser', JSON.stringify(profile));
            ui.checkAuthElements();
        }
    }
});
