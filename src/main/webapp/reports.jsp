<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    String reportType = request.getParameter("reportType");
    String format = request.getParameter("format");
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");
    
    boolean reportGenerated = false;
    String downloadLink = "";
    
    if (reportType != null && format != null) {
        // In a real implementation, this would generate the report and return a download link
        reportGenerated = true;
        downloadLink = "ReportServlet?reportType=" + reportType + "&format=" + format + 
                      (startDate != null ? "&startDate=" + startDate : "") + 
                      (endDate != null ? "&endDate=" + endDate : "");
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Reportes - ZonArbol</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@latest/dist/full.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body class="min-h-screen bg-gray-50 flex">
    <jsp:include page="components/sidebar.jsp" />

    <main class="flex-grow p-4 md:p-8">
        <!-- Mobile header -->
        <div class="md:hidden flex justify-between items-center mb-6 p-4 bg-white rounded-lg shadow">
            <button id="menu-toggle" class="text-gray-600">
                <i class="fas fa-bars text-xl"></i>
            </button>
            <h1 class="text-xl font-bold text-green-700">Reportes</h1>
            <div class="w-6"></div>
        </div>

        <div class="flex justify-between items-center mb-6">
            <h2 class="text-2xl md:text-3xl font-bold text-green-700">Generar Reportes</h2>
        </div>

        <!-- Report Generation Form -->
        <div class="bg-white p-6 rounded-lg shadow mb-6">
            <form action="reports.jsp" method="get" id="reportForm">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <!-- Report Type Selection -->
                    <div>
                        <label class="label">
                            <span class="label-text">Tipo de Reporte*</span>
                        </label>
                        <select name="reportType" class="select select-bordered w-full" required>
                            <option value="">Seleccione un tipo</option>
                            <option value="zones" <%= "zones".equals(reportType) ? "selected" : "" %>>Zonas Forestales</option>
                            <option value="species" <%= "species".equals(reportType) ? "selected" : "" %>>Especies de Árboles</option>
                            <option value="activities" <%= "activities".equals(reportType) ? "selected" : "" %>>Actividades de Conservación</option>
                            <option value="inventory" <%= "inventory".equals(reportType) ? "selected" : "" %>>Inventario Completo</option>
                            <option value="protected" <%= "protected".equals(reportType) ? "selected" : "" %>>Áreas Protegidas</option>
                        </select>
                    </div>
                    
                    <!-- Format Selection -->
                    <div>
                        <label class="label">
                            <span class="label-text">Formato*</span>
                        </label>
                        <select name="format" class="select select-bordered w-full" required>
                            <option value="">Seleccione formato</option>
                            <option value="pdf" <%= "pdf".equals(format) ? "selected" : "" %>>PDF</option>
                            <option value="excel" <%= "excel".equals(format) ? "selected" : "" %>>Excel</option>
                            <option value="csv" <%= "csv".equals(format) ? "selected" : "" %>>CSV</option>
                        </select>
                    </div>
                    
                    <!-- Date Range -->
                    <div>
                        <label class="label">
                            <span class="label-text">Rango de Fechas</span>
                        </label>
                        <div class="flex space-x-2">
                            <input type="date" name="startDate" value="<%= startDate != null ? startDate : "" %>" 
                                   class="input input-bordered w-full" placeholder="Fecha inicio">
                            <input type="date" name="endDate" value="<%= endDate != null ? endDate : "" %>" 
                                   class="input input-bordered w-full" placeholder="Fecha fin">
                        </div>
                    </div>
                </div>
                
                <!-- Additional filters that appear based on report type -->
                <div id="additionalFilters" class="mt-6 hidden">
                    <!-- Zones specific filters -->
                    <div id="zonesFilters" class="report-filters hidden">
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div>
                                <label class="label">
                                    <span class="label-text">Provincia</span>
                                </label>
                                <select name="province" class="select select-bordered w-full">
                                    <option value="">Todas</option>
                                    <option>San José</option>
                                    <option>Alajuela</option>
                                    <option>Cartago</option>
                                    <option>Heredia</option>
                                    <option>Guanacaste</option>
                                    <option>Puntarenas</option>
                                    <option>Limón</option>
                                </select>
                            </div>
                            <div>
                                <label class="label">
                                    <span class="label-text">Tipo de Bosque</span>
                                </label>
                                <select name="forestType" class="select select-bordered w-full">
                                    <option value="">Todos</option>
                                    <option>Bosque húmedo tropical</option>
                                    <option>Bosque nuboso</option>
                                    <option>Bosque lluvioso montano</option>
                                </select>
                            </div>
                            <div>
                                <label class="label">
                                    <span class="label-text">Estado</span>
                                </label>
                                <select name="zoneState" class="select select-bordered w-full">
                                    <option value="">Todos</option>
                                    <option>ACTIVE</option>
                                    <option>INACTIVE</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Species specific filters -->
                    <div id="speciesFilters" class="report-filters hidden">
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div>
                                <label class="label">
                                    <span class="label-text">Familia</span>
                                </label>
                                <input type="text" name="family" placeholder="Filtrar por familia" 
                                       class="input input-bordered w-full">
                            </div>
                            <div>
                                <label class="label">
                                    <span class="label-text">Estado de Conservación</span>
                                </label>
                                <select name="conservationStatus" class="select select-bordered w-full">
                                    <option value="">Todos</option>
                                    <option>Critically Endangered</option>
                                    <option>Endangered</option>
                                    <option>Vulnerable</option>
                                    <option>Near Threatened</option>
                                    <option>Least Concern</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Activities specific filters -->
                    <div id="activitiesFilters" class="report-filters hidden">
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div>
                                <label class="label">
                                    <span class="label-text">Tipo de Actividad</span>
                                </label>
                                <input type="text" name="activityType" placeholder="Filtrar por tipo" 
                                       class="input input-bordered w-full">
                            </div>
                            <div>
                                <label class="label">
                                    <span class="label-text">Estado</span>
                                </label>
                                <select name="activityState" class="select select-bordered w-full">
                                    <option value="">Todos</option>
                                    <option>ACTIVE</option>
                                    <option>INACTIVE</option>
                                </select>
                            </div>
                            <div>
                                <label class="label">
                                    <span class="label-text">Entidad Responsable</span>
                                </label>
                                <input type="text" name="responsibleEntity" placeholder="Filtrar por entidad" 
                                       class="input input-bordered w-full">
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="mt-6 flex justify-end space-x-3">
                    <button type="reset" class="btn btn-outline">Limpiar</button>
                    <button type="submit" class="btn btn-success text-white">Generar Reporte</button>
                </div>
            </form>
        </div>

        <% if (reportGenerated) { %>
        <!-- Report Generated Successfully -->
        <div class="bg-white p-6 rounded-lg shadow mb-6">
            <div class="alert alert-success alert-soft">
                <div class="flex-1">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" 
                         class="w-6 h-6 mx-2 stroke-current text-white">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                              d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                    <label class="text-white">Reporte generado exitosamente. Listo para descargar.</label>
                </div>
            </div>
            
            <div class="mt-4 flex justify-center">
                <a href="<%= downloadLink %>" class="btn btn-accent gap-2">
                    <i class="fas fa-download text-white"></i>
                    <p class="text-white">Descargar Reporte</p>
                </a>
            </div>
            
            <!-- Report Preview (would be dynamic in real implementation) -->
            <div class="mt-6 border rounded-lg p-4">
                <h3 class="text-lg font-semibold mb-3">Vista Previa del Reporte</h3>
                <div class="overflow-x-auto">
                    <table class="table table-zebra w-full">
                        <thead>
                            <tr>
                                <% if ("zones".equals(reportType)) { %>
                                    <th>ID</th>
                                    <th>Nombre</th>
                                    <th>Ubicación</th>
                                    <th>Área (ha)</th>
                                <% } else if ("species".equals(reportType)) { %>
                                    <th>ID</th>
                                    <th>Nombre Científico</th>
                                    <th>Nombre Común</th>
                                    <th>Familia</th>
                                <% } else if ("activities".equals(reportType)) { %>
                                    <th>ID</th>
                                    <th>Tipo</th>
                                    <th>Fechas</th>
                                    <th>Descripción</th>
                                <% } else { %>
                                    <th>ID</th>
                                    <th>Tipo</th>
                                    <th>Detalles</th>
                                <% } %>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <% if ("zones".equals(reportType)) { %>
                                    <td>1</td>
                                    <td>Bosque Alto Talamanca</td>
                                    <td>Limón, Talamanca</td>
                                    <td>15,000.50</td>
                                <% } else if ("species".equals(reportType)) { %>
                                    <td>1</td>
                                    <td>Quercus costaricensis</td>
                                    <td>Roble</td>
                                    <td>Fagaceae</td>
                                <% } else if ("activities".equals(reportType)) { %>
                                    <td>1</td>
                                    <td>Reforestación</td>
                                    <td>2024-03-01 a 2024-05-15</td>
                                    <td>Campaña de reforestación con especies nativas</td>
                                <% } else { %>
                                    <td>1</td>
                                    <td><%= reportType.equals("protected") ? "Área Protegida" : "Registro" %></td>
                                    <td>Datos de muestra para vista previa</td>
                                <% } %>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="mt-3 text-sm text-gray-500">
                    <p>* La vista previa muestra solo una muestra del reporte. El archivo descargable contendrá todos los datos.</p>
                </div>
            </div>
        </div>
        <% } %>

        <!-- Saved Reports Section -->
        <div class="bg-white p-6 rounded-lg shadow">
            <h3 class="text-xl font-semibold mb-4">Reportes Guardados</h3>
            
            <div class="overflow-x-auto">
                <table class="table w-full">
                    <thead>
                        <tr>
                            <th>Nombre</th>
                            <th>Tipo</th>
                            <th>Formato</th>
                            <th>Fecha Generación</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Zonas_Activas_202405</td>
                            <td>Zonas Forestales</td>
                            <td>PDF</td>
                            <td>2024-05-15</td>
                            <td>
                                <div class="flex space-x-2">
                                    <button class="btn btn-sm btn-accent">
                                        <i class="fa-solid fa-download text-white"></i>
                                        <p class="text-white">Descargar</p>
                                    </button>
                                    <button class="btn btn-sm btn-error ml-2">
                                        <i class="fas fa-trash text-white"></i>
                                        <p class="text-white">Eliminar</p>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>Especies_En_Peligro</td>
                            <td>Especies de Árboles</td>
                            <td>Excel</td>
                            <td>2024-04-28</td>
                            <td>
                                <div class="flex space-x-2">
                                    <button class="btn btn-sm btn-accent">
                                        <i class="fa-solid fa-download text-white"></i>
                                        <p class="text-white">Descargar</p>
                                    </button>
                                    <button class="btn btn-sm btn-error ml-2">
                                        <i class="fas fa-trash text-white"></i>
                                        <p class="text-white">Eliminar</p>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

        <script src="scripts/reports_script.js"></script>
</body>
</html>