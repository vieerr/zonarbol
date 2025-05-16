<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.espe.zonarbol.model.ForestZone" %>
<%@ page import="com.espe.zonarbol.dao.ForestZoneDAO" %>
<%
    ForestZoneDAO zoneDAO = new ForestZoneDAO();
    List<ForestZone> zones = zoneDAO.getAllForestZones();
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
            <button onclick="document.getElementById('add-zone-modal').showModal()" 
                    class="btn btn-success gap-2">
                <i class="fas fa-plus"></i>
                Nueva Zona
            </button>
        </div>

        <!-- Filter and Search -->
        <div class="bg-white p-4 rounded-lg shadow mb-6">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                    <label class="label">Provincia</label>
                    <select class="select select-bordered w-full">
                        <option>Todas</option>
                        <option>San José</option>
                        <option>Limón</option>
                        <option>Puntarenas</option>
                    </select>
                </div>
                <div>
                    <label class="label">Cantón</label>
                    <input type="text" placeholder="Buscar cantón..." class="input input-bordered w-full">
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

        <!-- Zones Table -->
        <div class="bg-white rounded-lg shadow overflow-hidden">
            <div class="overflow-x-auto">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Nombre</th>
                            <th>Ubicación</th>
                            <th>Área (ha)</th>
                            <th>Tipo de Bosque</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (ForestZone zone : zones) { %>
                        <tr>
                            <td><%= zone.getZoneName() %></td>
                            <td><%= zone.getProvince() %>, <%= zone.getCanton() %></td>
                            <td><%= String.format("%,.2f", zone.getTotalAreaHectares()) %></td>
                            <td><%= zone.getForestType() %></td>
                            <td>
                                <span class="badge <%= zone.getState().equals("ACTIVE") ? "badge-success" : "badge-error" %>">
                                    <%= zone.getState().equals("ACTIVE") ? "Activo" : "Inactivo" %>
                                </span>
                            </td>
                            <td>
                                <div class="flex space-x-2">
                                    <button onclick="openEditModal(<%= zone.getZoneId() %>)" 
                                            class="btn btn-xs btn-primary">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button onclick="confirmDelete(<%= zone.getZoneId() %>)" 
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

    <!-- Add Zone Modal -->
    <dialog id="add-zone-modal" class="modal">
        <div class="modal-box w-11/12 max-w-5xl">
            <h3 class="font-bold text-lg">Registrar Nueva Zona Forestal</h3>
            <form action="ForestZoneServlet" method="POST" class="mt-4">
                <input type="hidden" name="action" value="add">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="label">
                            <span class="label-text">Nombre de la Zona*</span>
                        </label>
                        <input type="text" name="zoneName" placeholder="Ej: Bosque Alto Talamanca" 
                               class="input input-bordered w-full" required>
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Tipo de Bosque*</span>
                        </label>
                        <input type="text" name="forestType" placeholder="Ej: Bosque húmedo tropical" 
                               class="input input-bordered w-full" required>
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Provincia*</span>
                        </label>
                        <select name="province" class="select select-bordered w-full" required>
                            <option value="">Seleccione...</option>
                            <option value="San José">San José</option>
                            <option value="Alajuela">Alajuela</option>
                            <option value="Cartago">Cartago</option>
                            <option value="Heredia">Heredia</option>
                            <option value="Guanacaste">Guanacaste</option>
                            <option value="Puntarenas">Puntarenas</option>
                            <option value="Limón">Limón</option>
                        </select>
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Cantón*</span>
                        </label>
                        <input type="text" name="canton" placeholder="Ej: Talamanca" 
                               class="input input-bordered w-full" required>
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Área Total (hectáreas)*</span>
                        </label>
                        <input type="number" step="0.01" min="0.01" name="totalAreaHectares" 
                               placeholder="Ej: 15000.50" class="input input-bordered w-full" required>
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Estado*</span>
                        </label>
                        <select name="state" class="select select-bordered w-full" required>
                            <option value="ACTIVE">Activo</option>
                            <option value="INACTIVE">Inactivo</option>
                        </select>
                    </div>
                </div>
                <div class="modal-action">
                    <button type="button" onclick="document.getElementById('add-zone-modal').close()" 
                            class="btn btn-ghost">Cancelar</button>
                    <button type="submit" class="btn btn-success">Guardar</button>
                </div>
            </form>
        </div>
    </dialog>

    <script>
        function openEditModal(zoneId) {
            // Here you would fetch the zone data and populate the edit modal
            console.log("Editing zone ID:", zoneId);
            // Implement AJAX call to get zone details and show edit modal
        }

        function confirmDelete(zoneId) {
            if (confirm("¿Está seguro que desea eliminar esta zona forestal?")) {
                // Implement delete functionality
                console.log("Deleting zone ID:", zoneId);
            }
        }
    </script>
</body>
</html>