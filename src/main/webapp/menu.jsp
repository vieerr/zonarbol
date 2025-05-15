<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard - ZonArbol</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@latest/dist/full.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body class="min-h-screen bg-gray-50 flex">

    <!-- Sidebar -->
    <aside class="w-64 bg-white shadow-lg flex flex-col hidden md:flex">
        <div class="p-6 border-b border-gray-200">
            <div class="flex items-center space-x-3">
                <div class="text-3xl text-green-600">
                    <i class="fas fa-tree"></i>
                </div>
                <h1 class="text-2xl font-bold text-green-700">ZonArbol</h1>
            </div>
            <p class="text-sm text-gray-600 mt-2">Usuario: <strong><%= username %></strong></p>
        </div>
        <nav class="flex-grow p-4 space-y-1">
            <a href="menu.jsp" class="flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-green-50 hover:text-green-600 transition-all">
                <i class="fas fa-home w-5 text-center"></i>
                <span class="font-medium">Inicio</span>
            </a>
            <a href="forest-zones.jsp" class="flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-green-50 hover:text-green-600 transition-all">
                <i class="fas fa-map-marked-alt w-5 text-center"></i>
                <span class="font-medium">Zonas Forestales</span>
            </a>
            <a href="tree-species.jsp" class="flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-green-50 hover:text-green-600 transition-all">
                <i class="fas fa-leaf w-5 text-center"></i>
                <span class="font-medium">Especies de Árboles</span>
            </a>
            <a href="conservation-activities.jsp" class="flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-green-50 hover:text-green-600 transition-all">
                <i class="fas fa-hands-helping w-5 text-center"></i>
                <span class="font-medium">Actividades de Conservación</span>
            </a>
            <a href="reports.jsp" class="flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-green-50 hover:text-green-600 transition-all">
                <i class="fas fa-chart-bar w-5 text-center"></i>
                <span class="font-medium">Reportes</span>
            </a>
        </nav>
        <form action="logout" method="post" class="p-6 border-t border-gray-200">
            <button type="submit" class="btn btn-error btn-block gap-2">
                <i class="fas fa-sign-out-alt"></i>
                Cerrar sesión
            </button>
        </form>
    </aside>

    <!-- Main content -->
    <main class="flex-grow p-4 md:p-8">
        <!-- Mobile header -->
        <div class="md:hidden flex justify-between items-center mb-6 p-4 bg-white rounded-lg shadow">
            <button id="menu-toggle" class="text-gray-600">
                <i class="fas fa-bars text-xl"></i>
            </button>
            <h1 class="text-xl font-bold text-green-700">ZonArbol</h1>
            <div class="w-6"></div> <!-- Spacer for balance -->
        </div>

        <div class="flex justify-between items-center mb-6">
            <h2 class="text-2xl md:text-3xl font-bold text-green-700">Bienvenido, <%= username %></h2>
            <div class="relative">
                <input type="text" placeholder="Buscar..." class="input input-bordered w-full md:w-64 pl-10" />
                <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <!-- Card: Total Forest Zones -->
            <div class="card bg-white shadow-md rounded-lg overflow-hidden">
                <div class="p-6">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Zonas Forestales</p>
                            <h3 class="text-3xl font-bold mt-1 text-green-600">42</h3>
                        </div>
                        <div class="p-3 rounded-full bg-green-100 text-green-600">
                            <i class="fas fa-map-marked-alt"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <span class="text-green-600 text-sm font-medium">+3 este mes</span>
                    </div>
                </div>
            </div>

            <!-- Card: Total Tree Species -->
            <div class="card bg-white shadow-md rounded-lg overflow-hidden">
                <div class="p-6">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Especies de Árboles</p>
                            <h3 class="text-3xl font-bold mt-1 text-blue-600">128</h3>
                        </div>
                        <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                            <i class="fas fa-leaf"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <span class="text-blue-600 text-sm font-medium">+5 este mes</span>
                    </div>
                </div>
            </div>

            <!-- Card: Conservation Activities -->
            <div class="card bg-white shadow-md rounded-lg overflow-hidden">
                <div class="p-6">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Actividades</p>
                            <h3 class="text-3xl font-bold mt-1 text-purple-600">24</h3>
                        </div>
                        <div class="p-3 rounded-full bg-purple-100 text-purple-600">
                            <i class="fas fa-hands-helping"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <span class="text-purple-600 text-sm font-medium">2 programadas</span>
                    </div>
                </div>
            </div>

            <!-- Card: Protected Areas -->
            <div class="card bg-white shadow-md rounded-lg overflow-hidden">
                <div class="p-6">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Áreas Protegidas</p>
                            <h3 class="text-3xl font-bold mt-1 text-amber-600">18</h3>
                        </div>
                        <div class="p-3 rounded-full bg-amber-100 text-amber-600">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <span class="text-amber-600 text-sm font-medium">+1 este trimestre</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content Grid -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Recent Activities -->
            <div class="lg:col-span-2">
                <div class="card bg-white shadow-md rounded-lg overflow-hidden">
                    <div class="p-6 border-b border-gray-200">
                        <h3 class="text-xl font-semibold">Actividades Recientes</h3>
                    </div>
                    <div class="p-6">
                        <div class="space-y-4">
                            <div class="flex items-start">
                                <div class="p-2 rounded-full bg-green-100 text-green-600 mr-4">
                                    <i class="fas fa-plus"></i>
                                </div>
                                <div>
                                    <p class="font-medium">Nueva especie añadida</p>
                                    <p class="text-sm text-gray-500">Pino (Pinus sylvestris)</p>
                                    <p class="text-xs text-gray-400 mt-1">Hace 2 días</p>
                                </div>
                            </div>
                            <div class="flex items-start">
                                <div class="p-2 rounded-full bg-blue-100 text-blue-600 mr-4">
                                    <i class="fas fa-edit"></i>
                                </div>
                                <div>
                                    <p class="font-medium">Actualización de zona</p>
                                    <p class="text-sm text-gray-500">Reserva El Bosque</p>
                                    <p class="text-xs text-gray-400 mt-1">Hace 5 días</p>
                                </div>
                            </div>
                            <div class="flex items-start">
                                <div class="p-2 rounded-full bg-purple-100 text-purple-600 mr-4">
                                    <i class="fas fa-calendar-check"></i>
                                </div>
                                <div>
                                    <p class="font-medium">Actividad programada</p>
                                    <p class="text-sm text-gray-500">Reforestación en zona norte</p>
                                    <p class="text-xs text-gray-400 mt-1">Programada para 2025-06-01</p>
                                </div>
                            </div>
                        </div>
                        <button class="btn btn-ghost btn-sm mt-4 text-green-600">Ver todas las actividades</button>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div>
                <div class="card bg-white shadow-md rounded-lg overflow-hidden">
                    <div class="p-6 border-b border-gray-200">
                        <h3 class="text-xl font-semibold">Acciones Rápidas</h3>
                    </div>
                    <div class="p-6 space-y-3">
                        <button class="btn btn-outline btn-block justify-start gap-2">
                            <i class="fas fa-plus"></i>
                            Añadir Zona Forestal
                        </button>
                        <button class="btn btn-outline btn-block justify-start gap-2">
                            <i class="fas fa-plus"></i>
                            Registrar Especie
                        </button>
                        <button class="btn btn-outline btn-block justify-start gap-2">
                            <i class="fas fa-calendar-plus"></i>
                            Programar Actividad
                        </button>
                        <button class="btn btn-outline btn-block justify-start gap-2">
                            <i class="fas fa-file-export"></i>
                            Generar Reporte
                        </button>
                    </div>
                </div>

                <!-- Upcoming Events -->
                <div class="card bg-white shadow-md rounded-lg overflow-hidden mt-6">
                    <div class="p-6 border-b border-gray-200">
                        <h3 class="text-xl font-semibold">Próximos Eventos</h3>
                    </div>
                    <div class="p-6">
                        <div class="space-y-4">
                            <div class="flex items-start">
                                <div class="text-center mr-4">
                                    <div class="bg-green-100 text-green-800 px-2 py-1 rounded">
                                        <p class="font-bold">01</p>
                                        <p class="text-xs">JUN</p>
                                    </div>
                                </div>
                                <div>
                                    <p class="font-medium">Reforestación zona norte</p>
                                    <p class="text-sm text-gray-500">09:00 - 14:00</p>
                                </div>
                            </div>
                            <div class="flex items-start">
                                <div class="text-center mr-4">
                                    <div class="bg-blue-100 text-blue-800 px-2 py-1 rounded">
                                        <p class="font-bold">15</p>
                                        <p class="text-xs">JUN</p>
                                    </div>
                                </div>
                                <div>
                                    <p class="font-medium">Taller de conservación</p>
                                    <p class="text-sm text-gray-500">10:00 - 12:00</p>
                                </div>
                            </div>
                        </div>
                        <button class="btn btn-ghost btn-sm mt-4 text-green-600">Ver calendario completo</button>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Mobile sidebar overlay -->
    <div id="mobile-sidebar-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-40 hidden"></div>

    <script>
        // Toggle mobile sidebar
        document.getElementById('menu-toggle').addEventListener('click', function() {
            const sidebar = document.querySelector('aside');
            const overlay = document.getElementById('mobile-sidebar-overlay');
            
            sidebar.classList.toggle('hidden');
            sidebar.classList.toggle('absolute');
            sidebar.classList.toggle('z-50');
            sidebar.classList.toggle('h-full');
            overlay.classList.toggle('hidden');
        });

        // Close sidebar when clicking overlay
        document.getElementById('mobile-sidebar-overlay').addEventListener('click', function() {
            const sidebar = document.querySelector('aside');
            const overlay = document.getElementById('mobile-sidebar-overlay');
            
            sidebar.classList.add('hidden');
            overlay.classList.add('hidden');
        });
    </script>
</body>
</html>