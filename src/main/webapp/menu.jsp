<%@page import="com.espe.zonarbol.model.ConservationActivity"%>
<%@page import="com.espe.zonarbol.dao.TreeSpeciesDAO"%>
<%@page import="com.espe.zonarbol.dao.ConservationActivityDAO"%>
<%@page import="com.espe.zonarbol.dao.ForestZoneDAO"%>
<%@page import="com.espe.zonarbol.dao.ForestZoneDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ page import="java.util.List" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("index.jsp");
        return; 
    }

    // Initialize DAOs
    ForestZoneDAO zoneDAO = new ForestZoneDAO();
    TreeSpeciesDAO speciesDAO = new TreeSpeciesDAO();
    ConservationActivityDAO activityDAO = new ConservationActivityDAO();

    // Get counts for dashboard
    int zonesCount = zoneDAO.getForestZonesCount();
    int speciesCount = speciesDAO.getTreeSpeciesCount();
    int activitiesCount = activityDAO.getConservationActivitiesCount();
    int activeActivitiesCount = activityDAO.getActiveConservationActivitiesCount();

    // Get recent activities
    List<ConservationActivity> recentActivities = activityDAO.getRecentActivities(5);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard - ZonArbol</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@latest/dist/full.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body class="min-h-screen bg-gray-50 flex">

    <jsp:include page="components/sidebar.jsp" />


    <!-- Main content -->
    <main class="flex-grow p-4 md:p-8">
        <!-- Mobile header -->
        <div class="md:hidden flex justify-between items-center mb-6 p-4 bg-white rounded-lg shadow">
            <button id="menu-toggle" class="text-gray-600">
                <i class="fas fa-bars text-xl"></i>
            </button>
            <h1 class="text-xl font-bold text-green-700">ZonArbol</h1>
            <div class="w-6"></div> <!-- Spacer for balance -->
        </div>

        <div class="flex justify-between items-center mb-6">
            <h2 class="text-2xl md:text-3xl font-bold text-green-700">Bienvenido, <%= username %></h2>
            <div class="relative">
                <input type="text" placeholder="Buscar..." class="input input-bordered w-full md:w-64 pl-10" />
                <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
            <!-- Card: Total Forest Zones -->
            <div class="card bg-white shadow-md rounded-lg overflow-hidden">
                <div class="p-6">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Zonas Forestales</p>
                            <h3 class="text-3xl font-bold mt-1 text-green-600"><%= zonesCount %></h3>
                        </div>
                        <div class="p-3 rounded-full bg-green-100 text-green-600">
                            <i class="fas fa-map-marked-alt"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <span class="text-green-600 text-sm font-medium">
                            <%= zoneDAO.getForestZonesAddedThisMonth() %> este mes
                        </span>
                    </div>
                </div>
            </div>

            <!-- Card: Total Tree Species -->
            <div class="card bg-white shadow-md rounded-lg overflow-hidden">
                <div class="p-6">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Especies de Árboles</p>
                            <h3 class="text-3xl font-bold mt-1 text-blue-600"><%= speciesCount %></h3>
                        </div>
                        <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                            <i class="fas fa-leaf"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <span class="text-blue-600 text-sm font-medium">
                            <%= speciesDAO.getSpeciesAddedThisMonth() %> este mes
                        </span>
                    </div>
                </div>
            </div>

            <!-- Card: Conservation Activities -->
            <div class="card bg-white shadow-md rounded-lg overflow-hidden">
                <div class="p-6">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Actividades</p>
                            <h3 class="text-3xl font-bold mt-1 text-purple-600"><%= activitiesCount %></h3>
                        </div>
                        <div class="p-3 rounded-full bg-purple-100 text-purple-600">
                            <i class="fas fa-hands-helping"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <span class="text-purple-600 text-sm font-medium">
                            <%= activeActivitiesCount %> activas
                        </span>
                    </div>
                </div>
            </div>

        </div>

        <!-- Main Content Grid -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Recent Activities -->
            <div class="lg:col-span-2">
                <div class="card bg-white shadow-md rounded-lg overflow-hidden">
                    <div class="p-6 border-b border-gray-200">
                        <h3 class="text-xl font-semibold">Actividades Recientes</h3>
                    </div>
                    <div class="p-6">
                        <div class="space-y-4">
                            <% for (ConservationActivity activity : recentActivities) { %>
                            <div class="flex items-start">
                                <div class="p-2 rounded-full bg-purple-100 text-purple-600 mr-4">
                                    <i class="fas fa-<%= getActivityIcon(activity.getActivityType()) %>"></i>
                                </div>
                                <div>
                                    <p class="font-medium"><%= activity.getActivityType() %></p>
                                    <p class="text-sm text-gray-500"><%= activity.getDescription() %></p>
                                    <p class="text-xs text-gray-400 mt-1">
                                        <%= activity.getStartDate() %>
                                        <% if (activity.getEndDate() != null) { %>
                                        - <%= activity.getEndDate() %>
                                        <% } else { %>
                                        (En curso)
                                        <% } %>
                                    </p>
                                </div>
                            </div>
                            <% } %>
                        </div>
                        <a href="conservation-activities.jsp" class="btn btn-ghost btn-sm mt-4 text-green-600">
                            Ver todas las actividades
                        </a>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div>
                <div class="card bg-white shadow-md rounded-lg overflow-hidden">
                    <div class="p-6 border-b border-gray-200">
                        <h3 class="text-xl font-semibold">Acciones Rápidas</h3>
                    </div>
                    <div class="p-6 space-y-3">
                        <a href="forest-zones.jsp?action=add" class="btn btn-outline btn-block justify-start gap-2">
                            <i class="fas fa-plus"></i>
                            Añadir Zona Forestal
                        </a>
                        <a href="tree-species.jsp?action=add" class="btn btn-outline btn-block justify-start gap-2">
                            <i class="fas fa-plus"></i>
                            Registrar Especie
                        </a>
                        <a href="conservation-activities.jsp?action=add" class="btn btn-outline btn-block justify-start gap-2">
                            <i class="fas fa-calendar-plus"></i>
                            Programar Actividad
                        </a>
                        <a href="reports.jsp" class="btn btn-outline btn-block justify-start gap-2">
                            <i class="fas fa-file-export"></i>
                            Generar Reporte
                        </a>
                    </div>
                </div>

            </div>
        </div>
    </main>

    <!-- Mobile sidebar overlay -->
    <div id="mobile-sidebar-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-40 hidden"></div>

    <script src="scripts/menu_script.js"></script>
</body>
</html>

<%!
    private String getActivityIcon(String activityType) {
        if (activityType == null) return "calendar-alt";
        
        activityType = activityType.toLowerCase();
        if (activityType.contains("reforest")) return "tree";
        if (activityType.contains("educ")) return "chalkboard-teacher";
        if (activityType.contains("taller")) return "users";
        if (activityType.contains("monitor")) return "binoculars";
        if (activityType.contains("control")) return "bug";
        return "calendar-alt";
    }

    private String getMonthAbbreviation(String month) {
        switch (month) {
            case "01": return "ENE";
            case "02": return "FEB";
            case "03": return "MAR";
            case "04": return "ABR";
            case "05": return "MAY";
            case "06": return "JUN";
            case "07": return "JUL";
            case "08": return "AGO";
            case "09": return "SEP";
            case "10": return "OCT";
            case "11": return "NOV";
            case "12": return "DIC";
            default: return month;
        }
    }
%>