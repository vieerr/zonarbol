const formModal = document.getElementById('base-modal-form');

function openAddModal() {
    document.getElementById('form-title').innerHTML = 'Registrar Nueva Especie de Árbol';
    
    document.getElementById('input-action').value = "add";
    document.getElementById('input-speciesId').value = "0";

    document.getElementById('input-scientificName').value = "";
    document.getElementById('input-commonName').value = "";
    document.getElementById('input-family').value = "";
    document.getElementById('input-averageLifespan').value = "";
    document.getElementById('select-conservationStatus').value = "";

    formModal.show();
}

// function to handle edit form mode        
async function openEditModal(speciesId) {
    const url = `/zonarbol/TreeSpeciesServlet?action=search&id=` + speciesId;

    try {
        const response = await fetch(url);
        const data = await response.json();
        placeDataInForm(data);
        formModal.show();
    } catch (error) {
        console.error('Error:', error);
    }
}

function placeDataInForm(data){
    document.getElementById('form-title').innerHTML = 'Editar Especie de Árbol';
    
    document.getElementById('input-action').value = "update";
    document.getElementById('input-speciesId').value = data.speciesId;

    document.getElementById('input-scientificName').value = data.scientificName;
    document.getElementById('input-commonName').value = data.commonName;
    document.getElementById('input-family').value = data.family;
    document.getElementById('input-averageLifespan').value = data.averageLifespan;
    document.getElementById('select-conservationStatus').value = data.conservationStatus;
}

function confirmDelete(speciesId) {
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

  const scientificNameInput = document.getElementById('input-scientificName').value;
  if(scientificNameInput.trim() === '')
    return "No pueden haber espacios en blanco en el nombre científico.";

  if (patronSQL.test(scientificNameInput))
    return "Entrada de texto sospechaosa.";
  
  const commonNameInput = document.getElementById('input-commonName').value;
  if(commonNameInput.trim() === '')
    return "No pueden haber espacios en blanco en el nombre común.";

  if (patronSQL.test(commonNameInput))
    return "Entrada de texto sospechaosa.";

  const familyInput = document.getElementById('input-family').value;
  if(familyInput.trim() === '')
    return "No pueden haber espacios en blanco en la familia.";

  if (patronSQL.test(familyInput))
    return "Entrada de texto sospechaosa.";

  if(Number(document.getElementById('input-averageLifespan').value) <= 0)
    return "No puede colocar valores negativos en la hectareas.";

  if(document.getElementById('select-conservationStatus').value === ' ')
    return "Debe seleccionar una provincia de la lista.";

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
  errorDiv.className = "flex items-start p-4 rounded-md mb-6 relative bg-[rgba(230,57,70,0.1)] border-l-4 border-[#e63946] text-[#e63946] col-span-2";
  errorDiv.innerHTML = msgAlert;

  const inputWrapper = document.getElementById('frm-input-wrapper');
  inputWrapper.appendChild(errorDiv);

  setTimeout(() => {
    inputWrapper.removeChild(errorDiv);
  }, 3000);

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