<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.espe.zonarbol.model.ForestZone" %>
<%@ page import="com.espe.zonarbol.dao.ForestZoneDAO" %>
<%
    ForestZoneDAO zoneDAO = new ForestZoneDAO();
    List<ForestZone> zones = zoneDAO.getAllForestZones();
    
    // Get unique values for filters
    java.util.Set<String> provinces = new java.util.HashSet<>();
    java.util.Set<String> forestTypes = new java.util.HashSet<>();
    
    for (ForestZone zone : zones) {
        provinces.add(zone.getProvince());
        forestTypes.add(zone.getForestType());
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <title>Zonas Forestales - ZonArbol</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@latest/dist/full.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body class="min-h-screen bg-gray-50 flex">
    <jsp:include page="components/sidebar.jsp" />

    <main class="flex-grow p-4 md:p-8">
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-2xl font-bold text-green-700">Zonas Forestales</h2>
            <button onclick="openAddModal()" 
                    class="btn btn-soft btn-success text-white">
                <i class="fas fa-plus"></i>
                Nueva Zona
            </button>
        </div>

        <!-- Filter and Search -->
        <div class="bg-white p-4 rounded-lg shadow mb-6">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                    <label class="label">Provincia</label>
                    <select id="filter-province" class="select select-bordered w-full" onchange="filterZones()">
                        <option value="">Todas</option>
                        <% for (String province : provinces) { %>
                            <option value="<%= province %>"><%= province %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label class="label">Cantón</label>
                    <input id="filter-canton" type="text" placeholder="Buscar cantón..." 
                           class="input input-bordered w-full" oninput="filterZones()">
                </div>
                <div>
                    <label class="label">Tipo de Bosque</label>
                    <select id="filter-forest-type" class="select select-bordered w-full" onchange="filterZones()">
                        <option value="">Todos</option>
                        <% for (String type : forestTypes) { %>
                            <option value="<%= type %>"><%= type %></option>
                        <% } %>
                    </select>
                </div>
            </div>
        </div>

        <!-- Zones Table -->
        <div class="bg-white rounded-lg shadow overflow-hidden">
            <div class="overflow-x-auto">
                <table class="table">
                    <thead>
                        <tr class="text-center">
                            <th>Nombre</th>
                            <th>Ubicación</th>
                            <th>Área (ha)</th>
                            <th>Tipo de Bosque</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody id="zones-table-body">
                        <% for (ForestZone zone : zones) { %>
                        <tr class="zone-row" 
                            data-province="<%= zone.getProvince() %>"
                            data-canton="<%= zone.getCanton() %>"
                            data-forest-type="<%= zone.getForestType() %>">
                            <td><%= zone.getZoneName() %></td>
                            <td><%= zone.getProvince() %>, <%= zone.getCanton() %></td>
                            <td><%= String.format("%,.2f", zone.getTotalAreaHectares()) %></td>
                            <td><%= zone.getForestType() %></td>
                            <td>
                                <div class="flex space-x-2">
                                    <button onclick="openEditModal(<%= zone.getZoneId() %>)" 
                                            class="btn btn-sm btn-info">
                                        <i class="fas fa-edit text-white"></i>
                                        <p class="text-white">Editar</p>
                                    </button>
                                    <button onclick="confirmDelete(<%= zone.getZoneId() %>)" 
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

    <!-- Add Zone Modal -->
    <dialog id="base-modal-form" class="modal">
        <div class="modal-box w-11/12 max-w-5xl">
            <h3 id="form-title" class="font-bold text-lg">Title</h3>
            <form action="ForestZoneServlet" method="POST" class="mt-4">
                <input id="input-action" type="hidden" name="action" value="add">
                <input id="input-zoneId" type="hidden" name="zoneId" value="0">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="label">
                            <span class="label-text">Nombre de la Zona*</span>
                        </label>
                        <input id="input-zoneName" type="text" name="zoneName" placeholder="Ej: Bosque Alto Talamanca" 
                               class="input input-bordered w-full" required>
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Tipo de Bosque*</span>
                        </label>
                        <input id="input-forestType" type="text" name="forestType" placeholder="Ej: Bosque húmedo tropical" 
                               class="input input-bordered w-full" required>
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Provincia*</span>
                        </label>
                        <select id="province" name="province" class="select select-bordered w-full" required>
                            <option value="">Seleccione...</option>
                        </select>
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Cantón*</span>
                        </label>
                        <select id="canton" name="canton" class="select select-bordered w-full" disabled required>
                            <option value="">Seleccione...</option>
                        </select>
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Área Total (hectáreas)*</span>
                        </label>
                        <input id="input-totalAreaHectares" type="number" step="0.01" min="0.01" name="totalAreaHectares" 
                               placeholder="Ej: 15000.50" class="input input-bordered w-full" required>
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

    <script src="scripts/forest_zone_script.js"></script>
</body>
</html>