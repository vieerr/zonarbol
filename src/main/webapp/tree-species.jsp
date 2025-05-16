<%@page import="com.espe.zonarbol.dao.TreeSpeciesDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.espe.zonarbol.model.TreeSpecies" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%
    TreeSpeciesDAO speciesDAO = new TreeSpeciesDAO();
    List<TreeSpecies> speciesList = speciesDAO.getAllTreeSpecies();
    
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
                <button onclick="document.getElementById('add-species-modal').showModal()" 
                        class="btn btn-success gap-2">
                    <i class="fas fa-plus"></i>
                    Nueva Especie
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
                                <option value="<%= status %>"><%= status %></option>
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
                            <tr>
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
                                <td>
                                    <span class="badge <%= getConservationStatusBadge(species.getConservationStatus()) %>">
                                        <%= species.getConservationStatus() != null ? species.getConservationStatus() : "N/A" %>
                                    </span>
                                </td>
                                <td>
                                    <div class="flex space-x-2">
                                        <button onclick="openEditSpeciesModal(<%= species.getSpeciesId() %>)" 
                                                class="btn btn-sm btn-info">
                                        <i class="fas fa-edit text-white"></i>
                                        <p class="text-white">Editar</p>
                                        </button>
                                        <button onclick="confirmDeleteSpecies(<%= species.getSpeciesId() %>)" 
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

        <!-- Edit Species Modal -->
        <dialog id="edit-species-modal" class="modal">
            <div class="modal-box w-11/12 max-w-4xl">
                <h3 class="font-bold text-lg">Editar Especie de Árbol</h3>
                <form action="TreeSpeciesServlet" method="POST" class="mt-4">
                    <input type="hidden" name="action" value="update" />
                    <input id="edit-speciesId" type="hidden" name="speciesId" />
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="label"><span class="label-text">Nombre Científico*</span></label>
                            <input id="edit-scientificName" type="text" name="scientificName" class="input input-bordered w-full" required />
                        </div>
                        <div>
                            <label class="label"><span class="label-text">Nombre Común</span></label>
                            <input id="edit-commonName" type="text" name="commonName" class="input input-bordered w-full" />
                        </div>
                        <div>
                            <label class="label"><span class="label-text">Familia</span></label>
                            <input id="edit-family" type="text" name="family" class="input input-bordered w-full" />
                        </div>
                        <div>
                            <label class="label"><span class="label-text">Vida Promedio (años)</span></label>
                            <input id="edit-averageLifespan" type="number" name="averageLifespan" class="input input-bordered w-full" />
                        </div>
                        <div class="md:col-span-2">
                            <label class="label"><span class="label-text">Estado de Conservación*</span></label>
                            <select id="edit-conservationStatus" name="conservationStatus" class="select select-bordered w-full" required>
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
                        <button type="button" onclick="document.getElementById('edit-species-modal').close()" class="btn btn-ghost">Cancelar</button>
                        <button type="submit" class="btn btn-success">Guardar Cambios</button>
                    </div>
                </form>
            </div>
        </dialog>

        <%!
            private String getConservationStatusBadge(String status) {
                if (status == null) return "badge-ghost";
                switch (status) {
                    case "Critically Endangered": return "badge-outline badge-secondary";
                    case "Endangered": return "badge-outline badge-error";
                    case "Vulnerable": return "badge-outline badge-warning";
                    case "Near Threatened": return "badge-outline badge-info";
                    case "Least Concern": return "badge-outline badge-success";
                    case "Data Deficient": return "badge-outline badge-info";
                    default: return "badge-ghost";
                }
            }
        %>

        <script>
            async function openEditSpeciesModal(speciesId) {
                try {
                    const url = `/zonarbol/TreeSpeciesServlet?action=search&id=` + speciesId;

                    const response = await fetch(url);
                    const text = await response.text();

                    if (!text)
                        throw new Error("Respuesta vacía");

                    const species = JSON.parse(text);

                    document.getElementById('edit-speciesId').value = species.speciesId;
                    document.getElementById('edit-scientificName').value = species.scientificName || '';
                    document.getElementById('edit-commonName').value = species.commonName || '';
                    document.getElementById('edit-family').value = species.family || '';
                    document.getElementById('edit-averageLifespan').value = species.averageLifespan || '';
                    document.getElementById('edit-conservationStatus').value = species.conservationStatus || 'Not Evaluated';

                    document.getElementById('edit-species-modal').showModal();
                } catch (error) {
                    console.error("Error al obtener los datos de la especie:", error);
                    alert("No se pudo cargar la información de la especie.");
                }
            }

            function confirmDeleteSpecies(speciesId) {
                if (!confirm("¿Está seguro que desea eliminar esta especie de árbol?"))
                    return;

                const form = document.createElement("form");
                form.method = "POST";
                form.action = "TreeSpeciesServlet";

                const inputAction = document.createElement("input");
                inputAction.type = "hidden";
                inputAction.name = "action";
                inputAction.value = "delete";
                form.appendChild(inputAction);

                const inputId = document.createElement("input");
                inputId.type = "hidden";
                inputId.name = "speciesId";
                inputId.value = speciesId;
                form.appendChild(inputId);

                document.body.appendChild(form);
                form.submit();
            }
            
            // Filter functionality for species
            function filterSpecies() {
                const searchTerm = document.getElementById('search-name').value.toLowerCase();
                const familyFilter = document.getElementById('filter-family').value;
                const statusFilter = document.getElementById('filter-status').value;
                
                const rows = document.querySelectorAll('.species-row');
                
                rows.forEach(row => {
                    const scientific = row.getAttribute('data-scientific');
                    const common = row.getAttribute('data-common');
                    const family = row.getAttribute('data-family');
                    const status = row.getAttribute('data-status');
                    
                    // Name filter (matches either scientific or common name)
                    const nameMatch = searchTerm === '' || 
                                      scientific.includes(searchTerm) || 
                                      common.includes(searchTerm);
                    
                    // Family filter
                    const familyMatch = familyFilter === '' || family === familyFilter;
                    
                    // Status filter
                    const statusMatch = statusFilter === '' || status === statusFilter;
                    
                    if (nameMatch && familyMatch && statusMatch) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }
        </script>
    </body>
</html>