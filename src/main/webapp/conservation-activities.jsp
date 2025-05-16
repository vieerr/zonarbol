<%@page import="com.espe.zonarbol.model.ForestZone"%>
<%@page import="com.espe.zonarbol.model.ConservationActivity"%>
<%@page import="com.espe.zonarbol.dao.ForestZoneDAO"%>
<%@page import="com.espe.zonarbol.dao.ConservationActivityDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%
    ConservationActivityDAO activityDAO = new ConservationActivityDAO();
    ForestZoneDAO zoneDAO = new ForestZoneDAO();
    List<ConservationActivity> activities = activityDAO.getAllConservationActivities();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <title>Actividades de Conservación - ZonArbol</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@latest/dist/full.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body class="min-h-screen bg-gray-50 flex">
    <jsp:include page="components/sidebar.jsp" />
    <main class="flex-grow p-4 md:p-8">
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-2xl font-bold text-green-700">Actividades de Conservación</h2>
            <button onclick="document.getElementById('add-activity-modal').showModal()" class="btn btn-success gap-2">
                <i class="fas fa-plus"></i>
                Nueva Actividad
            </button>
        </div>

        <!-- Filter and Search -->
        <div class="bg-white p-4 rounded-lg shadow mb-6">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                <div>
                    <label class="label">Zona Forestal</label>
                    <select id="filterZone" class="select select-bordered w-full">
                        <option value="">Todas</option>
                        <% for (ForestZone zone : zoneDAO.getAllForestZones()) { %>
                        <option value="<%= zone.getZoneName() %>"><%= zone.getZoneName() %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label class="label">Tipo de Actividad</label>
                    <input id="filterType" type="text" placeholder="Filtrar por tipo..." class="input input-bordered w-full">
                </div>
                <div>
                    <label class="label">Fecha Inicio</label>
                    <input id="filterDate" type="date" class="input input-bordered w-full">
                </div>
                <div>
                    <label class="label">Estado</label>
                    <select id="filterStatus" class="select select-bordered w-full">
                        <option value="">Todos</option>
                        <option value="Activo">Activo</option>
                        <option value="Inactivo">Inactivo</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Activities Table -->
        <div class="bg-white rounded-lg shadow overflow-hidden">
            <div class="overflow-x-auto">
                <table class="table" id="activityTable">
                    <thead>
                        <tr>
                            <th>Zona Forestal</th>
                            <th>Tipo de Actividad</th>
                            <th>Fechas</th>
                            <th>Entidad Responsable</th>
                            <th>Presupuesto</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (ConservationActivity activity : activities) {
                            ForestZone zone = zoneDAO.getForestZoneById(activity.getZoneId());
                            String estado = activity.getEndDate() == null ? "Activo" : "Inactivo";
                        %>
                        <tr class="activity-row"
                            data-zone="<%= zone.getZoneName() %>"
                            data-type="<%= activity.getActivityType() %>"
                            data-date="<%= activity.getStartDate() %>"
                            data-status="<%= estado %>">
                            <td><%= zone.getZoneName() %></td>
                            <td><%= activity.getActivityType() %></td>
                            <td>
                                <%= activity.getStartDate() %>
                                <% if (activity.getEndDate() != null) { %>
                                - <%= activity.getEndDate() %>
                                <% } else { %>
                                (En curso)
                                <% } %>
                            </td>
                            <td><%= activity.getResponsibleEntity() %></td>
                            <td>
                                <% if (activity.getEstimatedBudget() != null) { %>
                                ₡<%= String.format("%,.2f", activity.getEstimatedBudget()) %>
                                <% } else { %>
                                N/A
                                <% } %>
                            </td>
                            <td>
                                <div class="flex space-x-2">
                                    <button onclick="event.stopPropagation(); openEditActivityModal(<%= activity.getActivityId() %>)" class="btn btn-sm btn-info">
                                        <i class="fas fa-edit text-white"></i>
                                        <p class="text-white">Editar</p>
                                    </button>
                                    <button onclick="event.stopPropagation(); confirmDeleteActivity(<%= activity.getActivityId() %>)" class="btn btn-sm btn-error ml-2">
                                        <i class="fas fa-trash text-white"></i>
                                        <p class="text-white">Eliminar</p>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Modals (unchanged, you can keep your original modals here) -->

    <!-- Filtering Script -->
    <script>
        const zoneFilter = document.getElementById("filterZone");
        const typeFilter = document.getElementById("filterType");
        const dateFilter = document.getElementById("filterDate");
        const statusFilter = document.getElementById("filterStatus");

        const rows = document.querySelectorAll(".activity-row");

        function applyFilters() {
            const zone = zoneFilter.value.toLowerCase();
            const type = typeFilter.value.toLowerCase();
            const date = dateFilter.value;
            const status = statusFilter.value;

            rows.forEach(row => {
                const rZone = row.dataset.zone.toLowerCase();
                const rType = row.dataset.type.toLowerCase();
                const rDate = row.dataset.date;
                const rStatus = row.dataset.status;

                const matchZone = !zone || rZone.includes(zone);
                const matchType = !type || rType.includes(type);
                const matchDate = !date || rDate === date;
                const matchStatus = !status || rStatus === status;

                row.style.display = (matchZone && matchType && matchDate && matchStatus) ? "" : "none";
            });
        }

        [zoneFilter, typeFilter, dateFilter, statusFilter].forEach(input =>
            input.addEventListener("input", applyFilters)
        );
    </script>
</body>
</html>
