/* ============================================
   Main JavaScript Functionality
   ============================================ */

// Initialize dropdown menus
document.addEventListener('DOMContentLoaded', function() {
    initializeDropdowns();
    initializeMobileMenu();
    initializeFormValidation();
});

// Dropdown menu functionality
function initializeDropdowns() {
    const dropdowns = document.querySelectorAll('.user-dropdown');
    
    dropdowns.forEach(dropdown => {
        const button = dropdown.querySelector('.user-button');
        if (button) {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                dropdown.classList.toggle('active');
            });
        }
    });

    // Close dropdowns when clicking outside
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.user-dropdown')) {
            dropdowns.forEach(dropdown => {
                dropdown.classList.remove('active');
            });
        }
    });
}

// Mobile menu toggle
function initializeMobileMenu() {
    const toggle = document.querySelector('.mobile-menu-toggle');
    const menu = document.querySelector('.navbar-menu');
    
    if (toggle && menu) {
        toggle.addEventListener('click', function() {
            menu.classList.toggle('active');
        });
    }
}

// Form validation
function initializeFormValidation() {
    const forms = document.querySelectorAll('form');
    
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            const emailInputs = form.querySelectorAll('input[type="email"]');
            const passwordInputs = form.querySelectorAll('input[type="password"]');
            
            // Email validation
            emailInputs.forEach(input => {
                if (input.value && !isValidEmail(input.value)) {
                    e.preventDefault();
                    input.focus();
                    showError(input, 'Email không hợp lệ');
                }
            });
            
            // Password validation for registration
            if (form.querySelector('input[name="role"]')) {
                const password = form.querySelector('input[name="password"]');
                const confirm = form.querySelector('input[name="confirmPassword"]');
                
                if (password && confirm && password.value !== confirm.value) {
                    e.preventDefault();
                    confirm.focus();
                    showError(confirm, 'Mật khẩu không trùng khớp');
                }
            }
        });
    });
}

// Email validation helper
function isValidEmail(email) {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
}

// Show error message
function showError(element, message) {
    const parent = element.closest('.form-group') || element.parentElement;
    
    // Remove existing error
    const existing = parent.querySelector('.error-message');
    if (existing) existing.remove();
    
    // Add error
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message';
    errorDiv.textContent = message;
    errorDiv.style.cssText = `
        color: var(--danger);
        font-size: 0.875rem;
        margin-top: 0.25rem;
    `;
    
    parent.appendChild(errorDiv);
    
    // Add error state to input
    element.style.borderColor = 'var(--danger)';
    element.addEventListener('input', function() {
        element.style.borderColor = '';
        const error = parent.querySelector('.error-message');
        if (error) error.remove();
    });
}

// Smooth scroll for anchors
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Add hover animation to buttons
const buttons = document.querySelectorAll('.btn');
buttons.forEach(btn => {
    btn.addEventListener('mouseenter', function() {
        this.style.transform = 'translateY(-2px)';
    });
    
    btn.addEventListener('mouseleave', function() {
        this.style.transform = 'translateY(0)';
    });
});

// Format currency
function formatCurrency(value) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(value);
}

// Format date
function formatDate(date) {
    return new Intl.DateTimeFormat('vi-VN', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    }).format(new Date(date));
}

// Table row hover effect
const tables = document.querySelectorAll('.data-table tbody tr');
tables.forEach(row => {
    row.addEventListener('mouseenter', function() {
        this.style.backgroundColor = 'rgba(16, 185, 129, 0.05)';
    });
    
    row.addEventListener('mouseleave', function() {
        this.style.backgroundColor = '';
    });
});

// Notification helper
function showNotification(message, type = 'success') {
    const notification = document.createElement('div');
    notification.className = `alert alert-${type}`;
    notification.innerHTML = `
        <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
        <span>${message}</span>
    `;
    notification.style.cssText = `
        position: fixed;
        top: 80px;
        right: 20px;
        z-index: 1000;
        animation: slideInRight 0.3s ease;
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'slideOutRight 0.3s ease';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideInRight {
        from {
            opacity: 0;
            transform: translateX(100px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }
    
    @keyframes slideOutRight {
        from {
            opacity: 1;
            transform: translateX(0);
        }
        to {
            opacity: 0;
            transform: translateX(100px);
        }
    }
`;
document.head.appendChild(style);

// Export functions for global use
window.formatCurrency = formatCurrency;
window.formatDate = formatDate;
window.showNotification = showNotification;
