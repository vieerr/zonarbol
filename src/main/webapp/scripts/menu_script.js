// Toggle mobile sidebar
document.getElementById('menu-toggle').addEventListener('click', function() {
    const sidebar = document.querySelector('aside');
    const overlay = document.getElementById('mobile-sidebar-overlay');
    
    sidebar.classList.toggle('hidden');
    sidebar.classList.toggle('absolute');
    sidebar.classList.toggle('z-50');
    sidebar.classList.toggle('h-full');
    overlay.classList.toggle('hidden');
});

// Close sidebar when clicking overlay
document.getElementById('mobile-sidebar-overlay').addEventListener('click', function() {
    const sidebar = document.querySelector('aside');
    const overlay = document.getElementById('mobile-sidebar-overlay');
    
    sidebar.classList.add('hidden');
    overlay.classList.add('hidden');
});

// Search functionality
document.querySelector('input[type="text"]').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        const query = this.value.trim();
        if (query) {
            window.location.href = 'search.jsp?query=' + encodeURIComponent(query);
        }
    }
});