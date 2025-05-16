<%@page import="com.espe.zonarbol.model.ForestZone"%>
<%@page import="com.espe.zonarbol.model.ForestZone"%>
<%@page import="com.espe.zonarbol.model.ConservationActivity"%>
<%@page import="com.espe.zonarbol.dao.ForestZoneDAO"%>
<%@page import="com.espe.zonarbol.dao.ConservationActivityDAO"%>
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
            <button onclick="document.getElementById('add-activity-modal').showModal()" 
                    class="btn btn-success gap-2">
                <i class="fas fa-plus"></i>
                Nueva Actividad
            </button>
        </div>

        <!-- Filter and Search -->
        <div class="bg-white p-4 rounded-lg shadow mb-6">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                <div>
                    <label class="label">Zona Forestal</label>
                    <select class="select select-bordered w-full">
                        <option>Todas</option>
                        <% for (ForestZone zone : zoneDAO.getAllForestZones()) { %>
                        <option value="<%= zone.getZoneId() %>"><%= zone.getZoneName() %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label class="label">Tipo de Actividad</label>
                    <input type="text" placeholder="Filtrar por tipo..." class="input input-bordered w-full">
                </div>
                <div>
                    <label class="label">Fecha Inicio</label>
                    <input type="date" class="input input-bordered w-full">
                </div>
                <div>
                    <label class="label">Estado</label>
                    <select class="select select-bordered w-full">
                        <option>Todos</option>
                        <option>Activo</option>
                        <option>Inactivo</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Activities Table -->
        <div class="bg-white rounded-lg shadow overflow-hidden">
            <div class="overflow-x-auto">
                <table class="table">
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
                        <% for (ConservationActivity activity : activities) { %>
                        <tr>
                            <td><%= zoneDAO.getForestZoneById(activity.getZoneId()).getZoneName() %></td>
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
                                    <button onclick="openEditActivityModal(<%= activity.getActivityId() %>)" 
                                            class="btn btn-xs btn-primary">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button onclick="confirmDeleteActivity(<%= activity.getActivityId() %>)" 
                                            class="btn btn-xs btn-error">
                                        <i class="fas fa-trash"></i>
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

    <!-- Add Activity Modal -->
    <dialog id="add-activity-modal" class="modal">
        <div class="modal-box w-11/12 max-w-5xl">
            <h3 class="font-bold text-lg">Registrar Nueva Actividad de Conservación</h3>
            <form action="ConservationActivityServlet" method="POST" class="mt-4">
                <input type="hidden" name="action" value="add">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="label">
                            <span class="label-text">Zona Forestal*</span>
                        </label>
                        <select name="zoneId" class="select select-bordered w-full" required>
                            <option value="">Seleccione una zona...</option>
                            <% for (ForestZone zone : zoneDAO.getAllForestZones()) { %>
                            <option value="<%= zone.getZoneId() %>"><%= zone.getZoneName() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Tipo de Actividad*</span>
                        </label>
                        <input type="text" name="activityType" placeholder="Ej: Reforestación" 
                               class="input input-bordered w-full" required>
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Fecha Inicio*</span>
                        </label>
                        <input type="date" name="startDate" class="input input-bordered w-full" required>
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Fecha Finalización</span>
                        </label>
                        <input type="date" name="endDate" class="input input-bordered w-full">
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Entidad Responsable</span>
                        </label>
                        <input type="text" name="responsibleEntity" placeholder="Ej: MINAE" 
                               class="input input-bordered w-full">
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Presupuesto Estimado (₡)</span>
                        </label>
                        <input type="number" step="0.01" min="0" name="estimatedBudget" 
                               placeholder="Ej: 150000.00" class="input input-bordered w-full">
                    </div>
                    <div class="md:col-span-2">
                        <label class="label">
                            <span class="label-text">Descripción*</span>
                        </label>
                        <textarea name="description" class="textarea textarea-bordered w-full" 
                                  rows="3" required></textarea>
                    </div>
                </div>
                <div class="modal-action">
                    <button type="button" onclick="document.getElementById('add-activity-modal').close()" 
                            class="btn btn-ghost">Cancelar</button>
                    <button type="submit" class="btn btn-success">Guardar</button>
                </div>
            </form>
        </div>
    </dialog>

    <script>
        function openEditActivityModal(activityId) {
            // Implement AJAX call to get activity details and show edit modal
            console.log("Editing activity ID:", activityId);
        }

        function confirmDeleteActivity(activityId) {
            if (confirm("¿Está seguro que desea eliminar esta actividad de conservación?")) {
                // Implement delete functionality
                console.log("Deleting activity ID:", activityId);
            }
        }

        function viewActivityDetails(activityId) {
            // Implement view details functionality
            console.log("Viewing details for activity ID:", activityId);
        }
    </script>
</body>
</html>