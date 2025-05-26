<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>
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
        <title>Resumen</title>
        <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@latest/dist/full.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    </head>
    <body class="min-h-screen bg-gray-50 flex">
        <jsp:include page="components/sidebar.jsp" />
        <main class="grid grid-cols-[300px_3fr] gap-4 p-4 w-full">
            <aside class="bg-gray-200 p-4">
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
            <section class="bg-gray-100 p-4 grid grid-rows-[1fr_1fr] gap-4 w-full">
                <div>
                    <h3 class="text-2xl font-bold text-green-700">Especies incluidas</h3>
                    <div id="species-wrapper" class="max-h-64 overflow-y-auto space-y-4">
                        <div class="my-4 border-2 border-lime-500 rounded-xl p-4">
                            <div class="rounded-sm text-center font-bold">
                                Seleccione una Zona
                            </div>
                        </div>
                    </div>
                </div>
                <div>
                    <h3 class="text-2xl font-bold text-green-700">Actividades vinculadas</h3>
                    <div id="activities-wrapper" class="max-h-64 overflow-y-auto space-y-4">
                        <div class="my-4 border-2 border-green-600 rounded-xl p-4">
                            <div class="rounded-sm text-center font-bold">
                                Seleccione una Zona
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>
    </body>
    
    <script src="scripts/summary_script.js"></script>
</html>
