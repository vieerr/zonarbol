<%@page import="com.espe.zonarbol.dao.TreeSpeciesDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.espe.zonarbol.model.TreeSpecies" %>
<%@ page import="com.espe.zonarbol.utils.RoleCheck" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%
    TreeSpeciesDAO speciesDAO = new TreeSpeciesDAO();
    List<TreeSpecies> speciesList = speciesDAO.getAllTreeSpecies();
    Integer roleId = (Integer) session.getAttribute("roleId");
    
    // Get unique values for filters
    Set<String> families = new HashSet<>();
    Set<String> conservationStatuses = new HashSet<>();
    
    for (TreeSpecies species : speciesList) {
        if (species.getFamily() != null && !species.getFamily().isEmpty()) {
            families.add(species.getFamily());
        }
        if (species.getConservationStatus() != null) {
            conservationStatuses.add(species.getConservationStatus());
        }
    }
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
                <button onclick="openAddModal()" 
                            class="btn btn-success gap-2 text-white"
                            <%= RoleCheck.evaluteAdd(roleId) ? "" : "disabled" %>>
                      <i class="fas fa-plus text-white"></i>
                    <p class="text-white">Nueva Especie</p>
                </button>
            </div>

            <!-- Filter and Search -->
            <div class="bg-white p-4 rounded-lg shadow mb-6">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <div class="md:col-span-2">
                        <label class="label">
                            <span class="label-text">Buscar por nombre</span>
                        </label>
                        <input type="text" id="search-name" placeholder="Científico o común..." 
                               class="input input-bordered w-full" oninput="filterSpecies()">
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Familia</span>
                        </label>
                        <select id="filter-family" class="select select-bordered w-full" onchange="filterSpecies()">
                            <option value="">Todas</option>
                            <% for (String family : families) { %>
                                <option value="<%= family %>"><%= family %></option>
                            <% } %>
                        </select>
                    </div>
                    <div>
                        <label class="label">
                            <span class="label-text">Estado de Conservación</span>
                        </label>
                        <select id="filter-status" class="select select-bordered w-full" onchange="filterSpecies()">
                            <option value="">Todos</option>
                            <% for (String status : conservationStatuses) { %>
                                <option value="<%= status %>"><%= getConservationStatusName(status) %></option>
                            <% } %>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Species Table -->
            <div class="bg-white rounded-lg shadow overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="table">
                        <thead>
                            <tr class="bg-[#659378] text-lg text-center font-bold text-white">
                                <th>Nombre Científico</th>
                                <th>Nombre Común</th>
                                <th>Familia</th>
                                <th>Vida Promedio</th>
                                <th>Estado de Conservación</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="species-table-body">
                            <% for (TreeSpecies species : speciesList) { %>
                            <tr class="species-row" 
                                data-scientific="<%= species.getScientificName().toLowerCase() %>"
                                data-common="<%= species.getCommonName() != null ? species.getCommonName().toLowerCase() : "" %>"
                                data-family="<%= species.getFamily() != null ? species.getFamily() : "" %>"
                                data-status="<%= species.getConservationStatus() != null ? species.getConservationStatus() : "" %>">
                                <td><em><%= species.getScientificName() %></em></td>
                                <td><%= species.getCommonName() != null ? species.getCommonName() : "N/A" %></td>
                                <td><%= species.getFamily() != null ? species.getFamily() : "N/A" %></td>
                                <td><%= species.getAverageLifespan() != null ? species.getAverageLifespan() + " años" : "N/A" %></td>
                                <td class="flex justify-center">
                                    <span class="inline-flex items-center py-[0.45em] px-[0.75em] text-xs font-semibold leading-none text-center whitespace-nowrap align-baseline rounded-[0.375rem] border <%= getConservationStatusBadge(species.getConservationStatus()) %>">
                                        <%= getConservationStatusName(species.getConservationStatus()) %>
                                    </span>
                                </td>
                                <td>
                                    <div class="flex space-x-2 justify-center">
                                        <button onclick="openEditModal(<%= species.getSpeciesId() %>)" 
                                                class="btn btn-sm btn-info" <%= RoleCheck.evaluteEdit(roleId) ? "" : "disabled" %>>
                                        <i class="fas fa-edit text-white"></i>
                                        <p class="text-white">Editar</p>
                                        </button>
                                        <button onclick="confirmDelete(<%= species.getSpeciesId() %>)" 
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

        <!-- Add Species Modal -->
        <dialog id="base-modal-form" class="modal">
            <div class="modal-box w-11/12 max-w-4xl">
                <h3 id="form-title" class="font-bold text-lg">Title</h3>
                <form action="TreeSpeciesServlet" method="POST" class="mt-4" id="frm-send">
                    <input id="input-action" type="hidden" name="action" value="add">
                    <input id="input-speciesId" type="hidden" name="speciesId" />
                    <div id="frm-input-wrapper" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="label">
                                <span class="label-text">Nombre Científico*</span>
                            </label>
                            <input id="input-scientificName" type="text" name="scientificName" placeholder="Ej: Quercus costaricensis" 
                                   class="input input-bordered w-full" required>
                        </div>
                        <div>
                            <label class="label">
                                <span class="label-text">Nombre Común</span>
                            </label>
                            <input id="input-commonName" type="text" name="commonName" placeholder="Ej: Roble" 
                                   class="input input-bordered w-full">
                        </div>
                        <div>
                            <label class="label">
                                <span class="label-text">Familia</span>
                            </label>
                            <input id="input-family" type="text" name="family" placeholder="Ej: Fagaceae" 
                                   class="input input-bordered w-full">
                        </div>
                        <div>
                            <label class="label">
                                <span class="label-text">Vida Promedio (años)</span>
                            </label>
                            <input id="input-averageLifespan" type="number" name="averageLifespan" min="1" 
                                   placeholder="Ej: 120" class="input input-bordered w-full">
                        </div>
                        <div class="md:col-span-2">
                            <label class="label">
                                <span class="label-text">Estado de Conservación*</span>
                            </label>
                            <select id="select-conservationStatus" name="conservationStatus" class="select select-bordered w-full" required>
                                <option value="">Seleccione...</option>
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
                        <button type="button" onclick="document.getElementById('base-modal-form').close()" 
                                class="btn btn-ghost">Cancelar</button>
                        <button type="submit" class="btn btn-success">Guardar</button>
                    </div>
                </form>
            </div>
        </dialog>

        <%!
            private String getConservationStatusBadge(String status) {
                if (status == null) return "text-[#1d77cd] bg-[rgba(29,119,205,0.1)] border-[rgba(29,119,205,0.2)]";
                switch (status) {
                    case "Critically Endangered": return "border text-[#0f0f0f] bg-[rgba(15,15,15,0.1)] border-[rgba(15,15,15,0.2)]";
                    case "Endangered": return "text-[#e63946] bg-[rgba(230,57,70,0.1)] border-[rgba(230,57,70,0.2)]";
                    case "Vulnerable": return "text-[#e77313] bg-[rgba(231,115,19,0.1)] border-[rgba(231,115,19,0.2)]";
                    case "Near Threatened": return "text-[#f1db1b] bg-[rgba(241,219,27,0.1)] border-[rgba(241,219,27,0.2)]";
                    case "Least Concern": return "text-[#00b179] bg-[rgba(42,157,143,0.1)] border-[rgba(0,177,121,0.2)]";
                    case "Data Deficient": return "border text-[#894217] bg-[rgba(137,66,23,0.1)] border-[rgba(137,66,23,0.2)]";
                    default: return "text-[#1d77cd] bg-[rgba(29,119,205,0.1)] border-[rgba(29,119,205,0.2)]";
                }
            }

            private String getConservationStatusName(String status) {
                if (status == null) return "N/A";
                switch (status) {
                    case "Critically Endangered": return "En Peligro Crítico";
                    case "Endangered": return "En Peligro";
                    case "Vulnerable": return "Vulnerable";
                    case "Near Threatened": return "Casi Amenazado";
                    case "Least Concern": return "Preocupación Menor";
                    case "Data Deficient": return "Datos Insuficientes";
                    default: return "N/A";
                }
            }
        %>

        <script src="scripts/tree_species_script.js"></script>
    </body>
</html>