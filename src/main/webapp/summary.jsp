<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="com.espe.zonarbol.model.ForestZone" %>
<%@ page import="com.espe.zonarbol.dao.ForestZoneDAO" %>
<%@ page import="com.espe.zonarbol.dao.TreeSpeciesDAO" %>
<%@ page import="com.espe.zonarbol.model.TreeSpecies" %>
<%@ page import="com.espe.zonarbol.utils.RoleCheck" %>
<%
    String username = (String) session.getAttribute("username");
    Integer roleId = (Integer) session.getAttribute("roleId");
    
    if (username == null || roleId == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    ForestZoneDAO zoneDAO = new ForestZoneDAO();
    List<ForestZone> zones = zoneDAO.getAllForestZones();
    
    TreeSpeciesDAO speciesDAO = new TreeSpeciesDAO();
    List<TreeSpecies> speciesList = speciesDAO.getAllTreeSpecies();
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8" />
        <title>Resumen</title>
        <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@latest/dist/full.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    </head>
    <body class="min-h-screen bg-gray-50 flex" data-roleid="<%= roleId %>">
        <jsp:include page="components/sidebar.jsp" />
        <main class="grid grid-cols-[300px_3fr] gap-4 p-4 w-full">
            <aside class="card rounded-lg shadow-md bg-gray-200 p-4 sticky top-4 self-start h-fit">
                <h2 class="text-2xl font-bold text-green-700 mb-3">Zona Forestal</h2>
                <select id="zoneName" name="zoneName" class="select select-bordered w-full">
                    <option value="">Seleccione...</option>
                    <% for (ForestZone zone : zones) { %>
                    <option value="<%= zone.getZoneName() %>" related-zone-id="<%= zone.getZoneId()%>"><%= zone.getZoneName() %></option>
                    <% } %>
                </select>
                <div id="zone-info-wrapper" class="mt-5">
                </div>
            </aside>
            <section class="card bg-white rounded-lg shadow-md p-4 grid grid-rows-[1fr_1fr] gap-4 w-full overflow-hidden">
                <div>
                    <h3 class="text-2xl font-bold text-lime-700">Especies de árboles incluidos</h3>
                    <div id="species-wrapper" class="max-h-full overflow-y-auto space-y-4">
                        <div class="my-4 border-2 border-lime-500 rounded-xl p-4">
                            <div class="rounded-sm text-center font-bold">
                                Seleccione una Zona
                            </div>
                        </div>
                    </div>
                </div>
                <div>
                    <h3 class="text-2xl font-bold text-green-700">Actividades vinculadas</h3>
                    <div id="activities-wrapper" class="max-h-full overflow-y-auto space-y-4">
                        <div class="my-4 border-2 border-green-600 rounded-xl p-4">
                            <div class="rounded-sm text-center font-bold">
                                Seleccione una Zona
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>
                
        <!-- Add ZoneSpecie Modal -->
        <dialog id="base-modal-form" class="modal">
            <div class="modal-box w-11/12 max-w-5xl">
                <h3 id="form-title" class="font-bold text-lg">Title</h3>
                <form action="SummaryServerlet" method="POST" class="mt-4">
                    <input id="input-action" type="hidden" name="action" value="add">
                    <input id="input-zoneId" type="hidden" name="zoneId" value="0">
                    <input id="input-specieId" type="hidden" name="specieId" value="0">
                    <div class="grid grid-cols-1 gap-4">
                        <div>
                            <label class="label">
                                <span class="label-text">Especie de árbol*</span>
                            </label>
                            <select id="commonName" name="commonName" class="select select-bordered w-full" required>
                                <option value="">Seleccione...</option>
                                <% for (TreeSpecies specie : speciesList) { %>
                                <option value="<%= specie.getCommonName() %>" related-specie-id="<%= specie.getSpeciesId()%>"><%= specie.getCommonName() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div>
                            <label class="label">
                                <span class="label-text">Población estimada*</span>
                            </label>
                            <input id="input-populationEstimate" type="number" step="1" min="1" name="populationEstimate" 
                               placeholder="Ej: 700" class="input input-bordered w-full" required>
                        </div>
                    </div>
                    <div class="modal-action">
                        <button type="button" onclick="document.getElementById('base-modal-form').close()" 
                            class="btn btn-ghost">Cancelar</button>
                        <button id="btn-sumbit-action" type="submit" class="btn btn-success">Añadir</button>
                    </div>
                </form>
            </div>
        </dialog>
    </body>
    
    <script src="scripts/summary_script.js"></script>
</html>
