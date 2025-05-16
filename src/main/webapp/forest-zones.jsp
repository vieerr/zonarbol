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
            <button onclick="openAddModal()" 
                    class="btn btn-soft btn-success">
                <i class="fas fa-plus"></i>
                Nueva Zona
            </button>
        </div>

        <!-- Filter and Search -->
<!--        <div class="bg-white p-4 rounded-lg shadow mb-6">
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
        </div>-->

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
                    <tbody>
                        <% for (ForestZone zone : zones) { %>
                        <tr>
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

    <script>
        const zoneLocation = {
  "Azuay": ["Girón", "Cuenca", "Gualaceo", "Paute", "Santa Isabel", "Pucará", "San Fernando", "Chordeleg", "El Pan", "Sevilla de Oro", "Guachapala", "Sigsig", "Oña", "Nabón", "Ponce Enríquez"],
  "Bolívar": ["Guaranda", "Chillanes", "Chimbo", "Echeandía", "San Miguel", "Caluma", "Las Naves"],
  "Cañar": ["Azogues", "Biblián", "Cañar", "La Troncal", "El Tambo", "Déleg", "Suscal"],
  "Carchi": ["Tulcán", "Bolívar", "Espejo", "Mira", "Montúfar", "San Pedro de Huaca"],
  "Chimborazo": ["Riobamba", "Alausí", "Colta", "Chambo", "Chunchi", "Guamote", "Guano", "Pallatanga", "Penipe", "Cumandá"],
  "Cotopaxi": ["Latacunga", "La Maná", "Pangua", "Pujilí", "Salcedo", "Saquisilí", "Sigchos"],
  "El Oro": ["Machala", "Arenillas", "Atahualpa", "Balsas", "Chilla", "El Guabo", "Huaquillas", "Marcabelí", "Pasaje", "Piñas", "Portovelo", "Santa Rosa", "Zaruma", "Las Lajas"],
  "Esmeraldas": ["Esmeraldas", "Eloy Alfaro", "Muisne", "Quinindé", "San Lorenzo", "Atacames", "Río Verde", "La Concordia"],
  "Galápagos": ["San Cristóbal", "Santa Cruz", "Isabela"],
  "Guayas": ["Guayaquil", "Alfredo Baquerizo Moreno", "Balao", "Balzar", "Colimes", "Coronel Marcelino Maridueña", "Daule", "Durán", "El Empalme", "El Triunfo", "General Antonio Elizalde", "Isidro Ayora", "Lomas de Sargentillo", "Milagro", "Naranjal", "Naranjito", "Nobol", "Palestina", "Pedro Carbo", "Playas", "Salitre", "Samborondón", "Santa Lucía", "Simón Bolívar", "Yaguachi"],
  "Imbabura": ["Ibarra", "Antonio Ante", "Cotacachi", "Otavalo", "Pimampiro", "San Miguel de Urcuquí"],
  "Loja": ["Loja", "Calvas", "Catamayo", "Celica", "Chaguarpamba", "Espíndola", "Gonzanamá", "Macará", "Olmedo", "Paltas", "Puyango", "Quilanga", "Saraguro", "Sozoranga", "Zapotillo", "Pindal"],
  "Los Ríos": ["Babahoyo", "Baba", "Montalvo", "Puebloviejo", "Quevedo", "Urdaneta", "Ventanas", "Vínces", "Palenque", "Buena Fé", "Valencia", "Mocache", "Quinsaloma"],
  "Manabí": ["Portoviejo", "Bolívar", "Chone", "El Carmen", "Flavio Alfaro", "Jama", "Jaramijó", "Jipijapa", "Junín", "Manta", "Montecristi", "Olmedo", "Paján", "Pedernales", "Pichincha", "Puerto López", "Rocafuerte", "San Vicente", "Santa Ana", "Sucre", "Tosagua", "Veinticuatro de Mayo"],
  "Morona Santiago": ["Macas", "Gualaquiza", "Limón Indanza", "Palora", "Santiago", "Sucúa", "Huamboya", "San Juan Bosco", "Taisha", "Logroño", "Pablo Sexto", "Tiwintza"],
  "Napo": ["Tena", "Archidona", "El Chaco", "Quijos", "Carlos Julio Arosemena Tola"],
  "Orellana": ["Francisco de Orellana", "Aguarico", "La Joya de los Sachas", "Loreto"],
  "Pastaza": ["Puyo", "Arajuno", "Mera", "Santa Clara"],
  "Pichincha": ["Quito", "Cayambe", "Mejía", "Pedro Moncayo", "Rumiñahui", "San Miguel de los Bancos", "Pedro Vicente Maldonado", "Puerto Quito"],
  "Santa Elena": ["Santa Elena", "La Libertad", "Salinas"],
  "Santo Domingo de los Tsáchilas": ["Santo Domingo", "La Concordia"],
  "Sucumbíos": ["Nueva Loja", "Cascales", "Cuyabeno", "Gonzalo Pizarro", "Lago Agrio", "Putumayo", "Shushufindi"],
  "Tungurahua": ["Ambato", "Baños de Agua Santa", "Cevallos", "Mocha", "Patate", "Pelileo", "Píllaro", "Quero", "Tisaleo"],
  "Zamora Chinchipe": ["Zamora", "Chinchipe", "Nangaritza", "Yacuambi", "Yantzaza", "El Pangui", "Centinela del Cóndor", "Palanda", "Paquisha"]
};

        const provinceSelect = document.getElementById('province');
        const cantonSelect   = document.getElementById('canton');

        function loadProvinces() {
            const provinces = Object.keys(zoneLocation).sort();

            provinces.forEach(province => {
                const optionElement = document.createElement('option');
                optionElement.value = province;
                optionElement.textContent = province;

                provinceSelect.appendChild(optionElement);
            });
        }
        
        function loadCantones(province){
            cantonSelect.innerHTML = '<option value="">Seleccione...</option>';
      
            const cantones = zoneLocation[province].sort();

		cantones.forEach(canton => {
                const optionElement = document.createElement('option');
                optionElement.value = canton;
                optionElement.textContent = canton;
                cantonSelect.appendChild(optionElement);
            });
        }

        provinceSelect.addEventListener('change', () => {
            const province = provinceSelect.value;

            if (!province) {
                cantonSelect.innerHTML = '<option value="">Seleccione...</option>';
                cantonSelect.disabled = true;
                return;
            }

            cantonSelect.disabled = false;
            loadCantones(province);
        });

        loadProvinces();
        
        const formModal = document.getElementById('base-modal-form');
        
        function openAddModal() {
            document.getElementById('form-title').innerHTML = 'Registrar Nueva Zona Forestal';
            
            document.getElementById('input-action').value = "add";
            document.getElementById('input-zoneId').value = "0";
            document.getElementById('input-zoneName').value = "";
            document.getElementById('input-forestType').value = "";
            document.getElementById('province').value = "";
            document.getElementById('canton').value = "";
            document.getElementById('input-totalAreaHectares').value = "";
            
            document.getElementById('canton').disabled = true;
            formModal.show();
        }
        
        // function to handle edit form mode        
        async function openEditModal(zoneId) {
            const urlString = `/zonarbol/ForestZoneServlet?action=search&zoneId=` + zoneId;
            
            try {
                const response = await fetch(urlString);
                const data = await response.json();
                console.log(data);
                placeDataInForm(data);
                formModal.show();
            } catch (error) {
                console.error('Error:', error);
            }
        }
        
        function placeDataInForm(data){
            document.getElementById('form-title').innerHTML = 'Actualizar Zona Forestal';
            
            document.getElementById('input-action').value = "update";
            document.getElementById('input-zoneId').value = data.zoneId;
            document.getElementById('input-zoneName').value = data.zoneName;
            document.getElementById('input-forestType').value = data.forestType;
            
            selectOption(provinceSelect, data.province);
            loadCantones(data.province);
            selectOption(cantonSelect, data.canton);
            
            document.getElementById('input-totalAreaHectares').value = data.totalAreaHectares;
            
            document.getElementById('canton').disabled = false;
        }
        
        function selectOption(selectInput, targetValue){
            const options = selectInput.options;
    
            for (let i = 0; i < options.length; i++) {
                if (options[i].value === targetValue) {
                    options[i].selected = true;
                    break;
                }
            }
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