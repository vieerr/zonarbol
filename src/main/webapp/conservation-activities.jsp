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
                            <tr onclick="viewActivityDetails(
                                            '<%= activity.getActivityType().replace("'", "\\'") %>',
                                            '<%= activity.getDescription().replace("'", "\\'") %>'
                                            )" style="cursor: pointer;">
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
                                        <button onclick="event.stopPropagation(); openEditActivityModal(<%= activity.getActivityId() %>)" 
                                                class="btn btn-sm btn-info">
                                            <i class="fas fa-edit text-white"></i>
                                            <p class="text-white">Editar</p>
                                        </button>
                                        <button onclick="event.stopPropagation(); confirmDeleteActivity(<%= activity.getActivityId() %>)" 
                                                class="btn btn-sm btn-error ml-2">
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
        <!-- Edit Activity Modal -->
        <dialog id="edit-activity-modal" class="modal">
            <div class="modal-box w-11/12 max-w-5xl">
                <h3 class="font-bold text-lg">Editar Actividad de Conservación</h3>
                <form id="edit-activity-form" method="POST" action="ConservationActivityServlet">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="activityId" id="editActivityId">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="label"><span class="label-text">Zona Forestal*</span></label>
                            <select name="zoneId" id="editZoneId" class="select select-bordered w-full" required>
                                <option value="">Seleccione una zona...</option>
                                <% for (ForestZone zone : zoneDAO.getAllForestZones()) { %>
                                <option value="<%= zone.getZoneId() %>"><%= zone.getZoneName() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div>
                            <label class="label"><span class="label-text">Tipo de Actividad*</span></label>
                            <input type="text" name="activityType" id="editActivityType" class="input input-bordered w-full" required>
                        </div>
                        <div>
                            <label class="label"><span class="label-text">Fecha Inicio*</span></label>
                            <input type="date" name="startDate" id="editStartDate" class="input input-bordered w-full" required>
                        </div>
                        <div>
                            <label class="label"><span class="label-text">Fecha Finalización</span></label>
                            <input type="date" name="endDate" id="editEndDate" class="input input-bordered w-full">
                        </div>
                        <div>
                            <label class="label"><span class="label-text">Entidad Responsable</span></label>
                            <input type="text" name="responsibleEntity" id="editResponsibleEntity" class="input input-bordered w-full">
                        </div>
                        <div>
                            <label class="label"><span class="label-text">Presupuesto Estimado (₡)</span></label>
                            <input type="number" step="0.01" min="0" name="estimatedBudget" id="editEstimatedBudget" class="input input-bordered w-full">
                        </div>
                        <div class="md:col-span-2">
                            <label class="label"><span class="label-text">Descripción*</span></label>
                            <textarea name="description" id="editDescription" class="textarea textarea-bordered w-full" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-action">
                        <button type="button" onclick="document.getElementById('edit-activity-modal').close()" class="btn btn-ghost">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Actualizar</button>
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

                <div class="modal-action mt-6">
                    <button onclick="document.getElementById('detail-activity-modal').close()" 
                            class="btn btn-ghost hover:bg-gray-100">
                        Cerrar Ventana
                    </button>
                </div>
            </div>
        </dialog>

        <script>
            function viewActivityDetails(type, description) {
                document.getElementById('detailType').innerText = type;
                document.getElementById('detailDescription').innerText = description || '—';
                document.getElementById('detail-activity-modal').showModal();
            }
            async function openEditActivityModal(activityId) {
                try {
                    const url = `/zonarbol/ConservationActivityServlet?action=search&id=` + activityId;

                    const response = await fetch(url);
                    const text = await response.text();

                    if (!text)
                        throw new Error("Respuesta vacía");
                    const data = JSON.parse(text);
                    document.getElementById('editActivityId').value = data.activityId;
                    document.getElementById('editZoneId').value = data.zoneId;
                    document.getElementById('editActivityType').value = data.activityType;
                    document.getElementById('editStartDate').value = data.startDate.split(' ')[0];
                    document.getElementById('editEndDate').value = data.endDate ? data.endDate.split(' ')[0] : '';
                    document.getElementById('editResponsibleEntity').value = data.responsibleEntity;
                    document.getElementById('editEstimatedBudget').value = data.estimatedBudget;
                    document.getElementById('editDescription').value = data.description;

                    document.getElementById('edit-activity-modal').showModal();
                } catch (err) {
                    alert("Error al cargar los datos");
                    console.error(err);
                }
            }
            function confirmDeleteActivity(activityId) {
                if (!confirm("¿Está seguro que desea eliminar esta actividad de conservación?"))
                    return;
                const form = document.createElement("form");
                form.method = "POST";
                form.action = "ConservationActivityServlet";

                const inputAction = document.createElement("input");
                inputAction.type = "hidden";
                inputAction.name = "action";
                inputAction.value = "delete";
                form.appendChild(inputAction);

                const inputId = document.createElement("input");
                inputId.type = "hidden";
                inputId.name = "activityId";
                inputId.value = activityId;
                form.appendChild(inputId);
                document.body.appendChild(form);
                form.submit();
            }
        </script>
    </body>
</html>