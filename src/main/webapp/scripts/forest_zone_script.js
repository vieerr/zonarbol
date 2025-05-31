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
  if (!confirm("¿Está seguro que desea eliminar esta zona forestal?")) {
      return;
  }

  const form = document.createElement("form");
  form.method = "POST";
  form.action = "ForestZoneServlet";
  const inputAction = document.createElement("input");
  inputAction.type = "hidden";
  inputAction.name = "action";
  inputAction.value = "delete";
  form.appendChild(inputAction);
  const inputId = document.createElement("input");
  inputId.type = "hidden";
  inputId.name = "zoneId";
  inputId.value = zoneId;
  form.appendChild(inputId);
  document.body.appendChild(form);
  form.submit();
}

// Form validation
const formContainer = document.getElementById('frm-send');

formContainer.addEventListener('submit', function(e) {
    e.preventDefault();

    const errorMsg = validateInputs();

    if(errorMsg !== ''){
      showErrorMsg(errorMsg);
      return;
    }
    
    this.submit();
  });

function validateInputs(){
  const patronSQL = /('|--|;|\b(SELECT|UPDATE|DELETE|INSERT|DROP|UNION|ALTER|CREATE|EXEC)\b)/i;

  const zoneNameInput = document.getElementById('input-zoneName').value;
  if(zoneNameInput.trim() === '')
    return "No pueden haber espacios en blanco en el nombre de la zona.";

  if (patronSQL.test(zoneNameInput))
    return "Entrada de texto sospechaosa.";
  
  const forestTypeInput = document.getElementById('input-forestType').value;
  if(forestTypeInput.trim() === '')
    return "No pueden haber espacios en blanco en el tipo de bosque.";

  if (patronSQL.test(forestTypeInput))
    return "Entrada de texto sospechaosa.";

  if(document.getElementById('province').value === ' ')
    return "Debe seleccionar una provincia de la lista.";

  if(document.getElementById('canton').value === ' ')
    return "Debe seleccionar un cantón de la lista.";

  if(Number(document.getElementById('input-totalAreaHectares').value) <= 0)
    return "No puede colocar valores negativos en la hectareas.";

  return "";
}

function showErrorMsg(errorMsg){
  const msgAlert = `
      <svg class="w-5 h-5 mr-3 shrink-0" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
      </svg>
      <div class="flex-grow text-[0.95rem]">
        <p><strong class="font-semibold">¡Error!</strong> ${errorMsg}</p>
      </div>
  `;

  const errorDiv = document.createElement('div');
  errorDiv.id = "err-msg";
  errorDiv.className = "flex items-start p-4 rounded-md mb-6 relative bg-[rgba(230,57,70,0.1)] border-l-4 border-[#e63946] text-[#e63946]";
  errorDiv.innerHTML = msgAlert;

  const inputWrapper = document.getElementById('frm-input-wrapper');
  inputWrapper.appendChild(errorDiv);

  setTimeout(() => {
    inputWrapper.removeChild(errorDiv);
  }, 3000);

}

// Filter functionality
function filterZones() {
  const provinceFilter = document.getElementById('filter-province').value.toLowerCase();
  const cantonFilter = document.getElementById('filter-canton').value.toLowerCase();
  const forestTypeFilter = document.getElementById('filter-forest-type').value.toLowerCase();
    
	const rows = document.querySelectorAll('.zone-row');

	rows.forEach(row => {
  	const province = row.getAttribute('data-province').toLowerCase();
  	const canton = row.getAttribute('data-canton').toLowerCase();
  	const forestType = row.getAttribute('data-forest-type').toLowerCase();
		
  	const provinceMatch = provinceFilter === '' || province === provinceFilter;
  	const cantonMatch = cantonFilter === '' || canton.includes(cantonFilter);
  	const forestTypeMatch = forestTypeFilter === '' || forestType === forestTypeFilter;
		
  	if (provinceMatch && cantonMatch && forestTypeMatch) {
  	    row.style.display = '';
  	} else {
  	    row.style.display = 'none';
  	}
  });
}