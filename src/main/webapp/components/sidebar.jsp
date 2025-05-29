<%@page import="com.espe.zonarbol.dao.UserDAO"%>
<%@page import="com.espe.zonarbol.dao.RoleDAO"%>
<%@page import="com.espe.zonarbol.model.User"%>
<%@page import="com.espe.zonarbol.model.Role"%>
<%
    String username = (String) session.getAttribute("username");
    Integer roleId = (Integer) session.getAttribute("roleId");
    
    if (username == null || roleId == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    RoleDAO roleDAO = new RoleDAO();
    Role usrRole = roleDAO.getRoleById(roleId);
%>
<!-- Sidebar -->
<aside class="w-64 h-screen bg-white sticky top-0 text-nowrap shadow-lg flex flex-col hidden md:flex">
    <div class="p-6 border-b border-gray-200">
        <div class="flex items-center space-x-3">
            <div class="text-3xl text-green-600">
                <i class="fas fa-tree"></i>
            </div>

            <h1 class="text-2xl font-bold text-green-700">ZonArbol</h1>
        </div>
        <p class="text-sm text-gray-600 mt-2">Usuario: <strong><%= username%></strong></p>
        <p class="text-sm text-gray-600 mt-2">Rol: <strong><%= usrRole.getRoleName()%></strong></p>
    </div>
    <nav class="flex-grow p-4 space-y-1">
        <a href="menu.jsp" class="flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-green-50 hover:text-green-600 transition-all break-words whitespace-normal">
            <i class="fas fa-home w-5 text-center"></i>
            <span class="font-medium">Inicio</span>
        </a>
        <a href="summary.jsp" class="flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-green-50 hover:text-green-600 transition-all break-words whitespace-normal">
            <i class="fa-solid fa-clipboard-list"></i>
            <span class="font-medium">Resumen</span>
        </a>
        <a href="forest-zones.jsp" class="flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-green-50 hover:text-green-600 transition-all break-words whitespace-normal">
            <i class="fas fa-map-marked-alt w-5 text-center"></i>
            <span class="font-medium">Zonas Forestales</span>
        </a>
        <a href="tree-species.jsp" class="flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-green-50 hover:text-green-600 transition-all break-words whitespace-normal">
            <i class="fas fa-leaf w-5 text-center"></i>
            <span class="font-medium">Especies de Árboles</span>
        </a>
        <a href="conservation-activities.jsp" class="flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-green-50 hover:text-green-600 transition-all break-words whitespace-normal">
            <i class="fas fa-hands-helping w-5 text-center"></i>
            <span class="font-medium">Actividades de Conservación</span>
        </a>
        <a href="reports.jsp" class="flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-green-50 hover:text-green-600 transition-all break-words whitespace-normal">
            <i class="fas fa-chart-bar w-5 text-center"></i>
            <span class="font-medium">Reportes</span>
        </a>
    </nav>
    <form action="auth" method="post" class="p-6 border-t border-gray-200">
        <input type="hidden" name="action" value="logout">
        <button type="submit" class="btn btn-error btn-block gap-2 text-white">
            <i class="fas fa-sign-out-alt"></i>
            Cerrar sesión
        </button>
    </form>
</aside>
