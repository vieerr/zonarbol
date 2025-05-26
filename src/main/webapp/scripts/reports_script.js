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

// Show/hide additional filters based on report type
document.querySelector('select[name="reportType"]').addEventListener('change', function() {
    const additionalFilters = document.getElementById('additionalFilters');
    const reportType = this.value;
    
    // Hide all filters first
    document.querySelectorAll('.report-filters').forEach(el => {
        el.classList.add('hidden');
    });
    
    if (reportType) {
        additionalFilters.classList.remove('hidden');
        document.getElementById(reportType + 'Filters').classList.remove('hidden');
    } else {
        additionalFilters.classList.add('hidden');
    }
});

// Initialize filters if returning to page with report type selected
document.addEventListener('DOMContentLoaded', function() {
    const reportType = document.querySelector('select[name="reportType"]').value;
    if (reportType) {
        document.getElementById('additionalFilters').classList.remove('hidden');
        document.getElementById(reportType + 'Filters').classList.remove('hidden');
    }
});