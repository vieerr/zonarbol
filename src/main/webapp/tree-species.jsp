<%@page import="com.espe.zonarbol.dao.TreeSpeciesDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.espe.zonarbol.model.TreeSpecies" %>
<%
    TreeSpeciesDAO speciesDAO = new TreeSpeciesDAO();
    List<TreeSpecies> speciesList = speciesDAO.getAllTreeSpecies();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <title>Especies de Árboles - ZonArbol</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@latest/dist/full.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body class="min-h-screen bg-gray-50 flex">
    <jsp:include page="components/sidebar.jsp" />

    <main class="flex-grow p-4 md:p-8">
        
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-2xl font-bold text-green-700">Especies de Árboles</h2>
            <button onclick="document.getElementById('add-species-modal').showModal()" 
                    class="btn btn-success gap-2">
                <i class="fas fa-plus"></i>
                Nueva Especie
            </button>
        </div>

        <!-- Filter and Search -->
        <div class="bg-white p-4 rounded-lg shadow mb-6">
            <div class="flex items-center gap-4">
                <div class="flex-grow">
                    <input type="text" placeholder="Buscar por nombre científico o común..." 
                           class="input input-bordered w-full">
                </div>
                <div>
                    <select class="select select-bordered">
                        <option>Todas las familias</option>
                        <option>Fagaceae</option>
                        <option>Meliaceae</option>
                        <option>Fabaceae</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Species Table -->
        <div class="bg-white rounded-lg shadow overflow-hidden">
            <div class="overflow-x-auto">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Nombre Científico</th>
                            <th>Nombre Común</th>
                            <th>Familia</th>
                            <th>Vida Promedio</th>
                            <th>Estado de Conservación</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (TreeSpecies species : speciesList) { %>
                        <tr>
                            <td><em><%= species.getScientificName() %></em></td>
                            <td><%= species.getCommonName() %></td>
                            <td><%= species.getFamily() %></td>
                            <td><%= species.getAverageLifespan() != null ? species.getAverageLifespan() + " años" : "N/A" %></td>
                            <td>
                                <span class="badge <%= getConservationStatusBadge(species.getConservationStatus()) %>">
                                    <%= species.getConservationStatus() %>
                                </span>
                            </td>
                            <td>
                                <div class="flex space-x-2">
                                    <button onclick="openEditSpeciesModal(<%= species.getSpeciesId() %>)" 
                                            class="btn btn-xs btn-primary">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button onclick="confirmDeleteSpecies(<%= species.getSpeciesId() %>)" 
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

    <!-- Add Species Modal -->
    <dialog id="add-species-modal" class="modal">
        <div class="modal-box w-11/12 max-w-4xl">
            <h3 class="font-bold text-lg">Registrar Nueva Especie de Árbol</h3>
            <form action="TreeSpeciesServlet" method="POST" class="mt-4">
                <input type="hidden" name="action" value="add">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="label">
                            <span class="label-text">Nombre Científico*</span>
                        </label>
                        <input type="text" name="scientificName" placeholder="Ej: Quercus costaricensis" 
                               class="input input-bordered w-full" required>
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Nombre Común</span>
                        </label>
                        <input type="text" name="commonName" placeholder="Ej: Roble" 
                               class="input input-bordered w-full">
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Familia</span>
                        </label>
                        <input type="text" name="family" placeholder="Ej: Fagaceae" 
                               class="input input-bordered w-full">
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Vida Promedio (años)</span>
                        </label>
                        <input type="number" name="averageLifespan" min="1" 
                               placeholder="Ej: 120" class="input input-bordered w-full">
                    </div>
                    <div class="md:col-span-2">
                        <label class="label">
                            <span class="label-text">Estado de Conservación*</span>
                        </label>
                        <select name="conservationStatus" class="select select-bordered w-full" required>
                            <option value="Not Evaluated">No Evaluado</option>
                            <option value="Least Concern">Preocupación Menor</option>
                            <option value="Near Threatened">Casi Amenazado</option>
                            <option value="Vulnerable">Vulnerable</option>
                            <option value="Endangered">En Peligro</option>
                            <option value="Critically Endangered">En Peligro Crítico</option>
                            <option value="Data Deficient">Datos Insuficientes</option>
                        </select>
                    </div>
                </div>
                <div class="modal-action">
                    <button type="button" onclick="document.getElementById('add-species-modal').close()" 
                            class="btn btn-ghost">Cancelar</button>
                    <button type="submit" class="btn btn-success">Guardar</button>
                </div>
            </form>
        </div>
    </dialog>

    <%!
        private String getConservationStatusBadge(String status) {
            if (status == null) return "badge-ghost";
            switch (status) {
                case "Critically Endangered": return "badge-error";
                case "Endangered": return "badge-error";
                case "Vulnerable": return "badge-warning";
                case "Near Threatened": return "badge-warning";
                case "Least Concern": return "badge-success";
                case "Data Deficient": return "badge-info";
                default: return "badge-ghost";
            }
        }
    %>

    <script>
        function openEditSpeciesModal(speciesId) {
            // Implement AJAX call to get species details and show edit modal
            console.log("Editing species ID:", speciesId);
        }

        function confirmDeleteSpecies(speciesId) {
            if (confirm("¿Está seguro que desea eliminar esta especie de árbol?")) {
                // Implement delete functionality
                console.log("Deleting species ID:", speciesId);
            }
        }
    </script>
</body>
</html>