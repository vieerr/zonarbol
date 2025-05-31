<%@page import="com.espe.zonarbol.model.ForestZone"%>
<%@page import="com.espe.zonarbol.model.ForestZone"%>
<%@page import="com.espe.zonarbol.model.ConservationActivity"%>
<%@page import="com.espe.zonarbol.dao.ForestZoneDAO"%>
<%@page import="com.espe.zonarbol.dao.ConservationActivityDAO"%>
<%@page import="com.espe.zonarbol.dao.ConservationActivityDAO"%>
<%@ page import="com.espe.zonarbol.utils.RoleCheck" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%
    String username = (String) session.getAttribute("username");
    Integer roleId = (Integer) session.getAttribute("roleId");
    
    if (username == null || roleId == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
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
                <button onclick="openAddModal()" 
                        class="btn btn-success gap-2 text-white"
                        <%= RoleCheck.evaluteAdd(roleId) ? "" : "disabled" %>>
                    <i class="fas fa-plus text-white"></i>
                    <p class="text-white">Nueva Actividad</p>
                </button>
            </div>

            <!-- Filter and Search -->
            <div class="bg-white p-4 rounded-lg shadow mb-6">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <div>
                        <label class="label">Zona Forestal</label>
                        <select id="filter-zone" class="select select-bordered w-full" onchange="filterActivities()">
                            <option value="">Todas</option>
                            <% for (ForestZone zone : zoneDAO.getAllForestZones()) { %>
                            <option value="<%= zone.getZoneName() %>"><%= zone.getZoneName() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div>
                        <label class="label">Tipo de Actividad</label>
                        <input id="filter-activityType" type="text" placeholder="Filtrar por tipo..." class="input input-bordered w-full" onchange="filterActivities()">
                    </div>
                    <div>
                        <label class="label">Entidad Responsable</label>
                        <input id="filter-responsableEntity" type="text" placeholder="Filtrar por nombre..." class="input input-bordered w-full" onchange="filterActivities()">
                    </div>
                    <div>
                        <label class="label">Fecha Inicio</label>
                        <input id="filter-startDate" type="date" class="input input-bordered w-full" onchange="filterActivities()">
                    </div>
                </div>
            </div>

            <!-- Activities Table -->
            <div class="bg-white rounded-lg shadow overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="table">
                        <thead>
                            <tr class="bg-[#659378] text-lg text-center font-bold text-white">
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
                            <tr class="hover:bg-[#F4FAF7] activities-row"
                                onclick="viewActivityDetails(
                                            '<%= activity.getActivityType().replace("'", "\\'") %>',
                                            '<%= activity.getDescription().replace("'", "\\'") %>'
                                            )" style="cursor: pointer;" 
                                data-zone="<%= zoneDAO.getForestZoneById(activity.getZoneId()).getZoneName().toLowerCase() %>"
                                data-activity-type="<%= activity.getActivityType() != null ? activity.getActivityType().toLowerCase() : "" %>"
                                data-responsable-entity="<%= activity.getResponsibleEntity() != null ? activity.getResponsibleEntity().toLowerCase() : "" %>"
                                data-start-date="<%= activity.getStartDate() != null ? activity.getStartDate() : "" %>">
                                
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
                                    $<%= String.format("%,.2f", activity.getEstimatedBudget()) %>
                                    <% } else { %>
                                    N/A
                                    <% } %>
                                </td>
                                <td>
                                    <div class="flex space-x-2 justify-center">
                                        <button onclick="event.stopPropagation(); openEditModal(<%= activity.getActivityId() %>)" 
                                                class="btn btn-sm btn-info" <%= RoleCheck.evaluteEdit(roleId) ? "" : "disabled" %>>
                                            <i class="fas fa-edit text-white"></i>
                                            <p class="text-white">Editar</p>
                                        </button>
                                        <button onclick="event.stopPropagation(); confirmDelete(<%= activity.getActivityId() %>)" 
                                                class="btn btn-sm btn-error ml-2" <%= RoleCheck.evaluteDelete(roleId) ? "" : "disabled" %>>
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

        <!-- Add Activity Modal -->
        <dialog id="base-modal-form" class="modal">
            <div class="modal-box w-11/12 max-w-5xl">
                <h3 id="form-title" class="font-bold text-lg">Title</h3>
                <form action="ConservationActivityServlet" method="POST" class="mt-4" id="frm-send">
                    <input id="input-action" type="hidden" name="action" value="add">
                    <input id="input-activityId" type="hidden" name="activityId" value="0">
                    <div id="frm-input-wrapper" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="label">
                                <span class="label-text">Zona Forestal*</span>
                            </label>
                            <select id="select-zoneId" name="zoneId" class="select select-bordered w-full" required>
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
                            <input id="input-activityType" type="text" name="activityType" placeholder="Ej: Reforestación" 
                                   class="input input-bordered w-full" required>
                        </div>
                        <div>
                            <label class="label">
                                <span class="label-text">Fecha Inicio*</span>
                            </label>
                            <input id="input-startDate" type="date" name="startDate" class="input input-bordered w-full" required>
                        </div>
                        <div>
                            <label class="label">
                                <span class="label-text">Fecha Finalización</span>
                                <span class="label-text">
                                    Marcar en curso
                                    <input id="check-is-in-course" type="checkbox" class="checkbox checkbox-sm checkbox-success" />
                                </span>
                            </label>
                            <input id="input-endDate" type="date" name="endDate" class="input input-bordered w-full">
                        </div>
                        <div>
                            <label class="label">
                                <span class="label-text">Entidad Responsable</span>
                            </label>
                            <input id="input-responsibleEntity" type="text" name="responsibleEntity" placeholder="Ej: MINAE" 
                                   class="input input-bordered w-full">
                        </div>
                        <div>
                            <label class="label">
                                <span class="label-text">Presupuesto Estimado ($)</span>
                            </label>
                            <input id="input-estimatedBudget" type="number" step="0.01" min="0" name="estimatedBudget" 
                                   placeholder="Ej: 150000.00" class="input input-bordered w-full">
                        </div>
                        <div class="md:col-span-2">
                            <label class="label">
                                <span class="label-text">Descripción*</span>
                            </label>
                            <textarea id="input-description" name="description" class="textarea textarea-bordered w-full" 
                                      rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-action">
                        <button type="button" onclick="document.getElementById('base-modal-form').close()" 
                                class="btn btn-ghost">Cancelar</button>
                        <button type="submit" class="btn btn-success">Guardar</button>
                    </div>
                </form>
            </div>
        </dialog>

        <!-- Detail Activity Modal -->
        <dialog id="detail-activity-modal" class="modal">
            <div class="modal-box w-11/12 max-w-2xl">
                <div class="flex justify-between items-start mb-6">
                    <h3 class="font-bold text-xl text-green-700 flex items-center gap-2">
                        <i class="fas fa-info-circle text-green-600"></i>
                        Detalles de la Actividad
                    </h3>
                    <button onclick="document.getElementById('detail-activity-modal').close()" 
                            class="btn btn-circle btn-ghost btn-sm">
                        ✕
                    </button>
                </div>

                <div class="space-y-4">
                    <div class="bg-green-50 p-4 rounded-lg">
                        <div class="flex items-center gap-3 mb-2">
                            <div class="bg-green-100 p-2 rounded-full">
                                <i class="fas fa-tag text-green-600 text-lg"></i>
                            </div>
                            <div>
                                <p class="text-sm font-semibold text-gray-500">Tipo de Actividad</p>
                                <p id="detailType" class="text-lg font-medium text-green-700"></p>
                            </div>
                        </div>
                    </div>

                    <div class="bg-blue-50 p-4 rounded-lg">
                        <div class="flex items-start gap-3">
                            <div class="bg-blue-100 p-2 rounded-full mt-1">
                                <i class="fas fa-align-left text-blue-600 text-lg"></i>
                            </div>
                            <div class="flex-1">
                                <p class="text-sm font-semibold text-gray-500 mb-2">Descripción detallada</p>
                                <p id="detailDescription" class="text-gray-700 leading-relaxed whitespace-pre-line"></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </dialog>

        <script src="scripts/conservation_activities_script.js"></script>
    </body>
</html>