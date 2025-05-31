const formModal = document.getElementById('base-modal-form');
const hasEndateCheck = document.getElementById('check-is-in-course');

hasEndateCheck.addEventListener('change', function() {
  document.getElementById('input-endDate').disabled = this.checked;
});

function openAddModal() {
    document.getElementById('form-title').innerHTML = 'Registrar Nueva Actividad de Conservación';
    
    document.getElementById('input-action').value = "add";
    document.getElementById('input-activityId').value = "0";

    document.getElementById('select-zoneId').value = "";
    document.getElementById('input-activityType').value = "";
    document.getElementById('input-startDate').value = "";
    document.getElementById('input-endDate').value = "";
    document.getElementById('input-responsibleEntity').value = "";
    document.getElementById('input-estimatedBudget').value = "";
    document.getElementById('input-description').value = "";

    hasEndateCheck.checked = false;
    document.getElementById('input-endDate').disabled = false;

    formModal.show();
}

// function to handle edit form mode        
async function openEditModal(activityId) {
    const url = `/zonarbol/ConservationActivityServlet?action=search&id=` + activityId;

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
    document.getElementById('form-title').innerHTML = 'Editar Actividad de Conservación';
    
    document.getElementById('input-action').value = "update";
    document.getElementById('input-activityId').value = data.activityId;

    document.getElementById('select-zoneId').value = data.zoneId;
    document.getElementById('input-activityType').value = data.activityType;
    document.getElementById('input-startDate').value = data.startDate;
    document.getElementById('input-endDate').value = data.endDate;
    document.getElementById('input-responsibleEntity').value = data.responsibleEntity;
    document.getElementById('input-estimatedBudget').value = data.estimatedBudget;
    document.getElementById('input-description').value = data.description;

    if(!data.endDate){
      hasEndateCheck.checked = true;
      document.getElementById('input-endDate').disabled = true;
    }
}


function confirmDelete(activityId) {
    if (!confirm("¿Está seguro que desea eliminar esta actividad de conservación?"))
        return;

    const form = document.createElement("form");
    form.method = "POST";
    form.action = "ConservationActivityServlet";

    const inputAction = document.createElement("input");
    inputAction.type = "hidden";
    inputAction.name = "action";
    inputAction.value = "delete";
    form.appendChild(inputAction);

    const inputId = document.createElement("input");
    inputId.type = "hidden";
    inputId.name = "activityId";
    inputId.value = activityId;
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

  if(document.getElementById('select-zoneId').value === ' ')
    return "Debe seleccionar una zona de la lista.";

  const activityTypeInput = document.getElementById('input-activityType').value;
  if(activityTypeInput.trim() === '')
    return "No pueden haber espacios en blanco en el tipo de actividad.";

  if (patronSQL.test(activityTypeInput))
    return "Entrada de texto sospechaosa.";

  const startDateInput = document.getElementById('input-startDate').value;
  if( startDateInput === "")
    return "Seleccione una fecha de inicio.";

  const endDateInput = document.getElementById('input-endDate').value
  if (endDateInput !== ''  && new Date(startDateInput) > new Date(endDateInput)) {
    return "La fecha de inicio no puede estar después que la fecha de finalización.";
  }
  
  const responsibleEntityInput = document.getElementById('input-responsibleEntity').value;
  if(responsibleEntityInput.trim() === '')
    return "No pueden haber espacios en la entidad responsable.";

  if (patronSQL.test(responsibleEntityInput))
    return "Entrada de texto sospechaosa.";

  if(Number(document.getElementById('input-estimatedBudget').value) <= 0)
    return "No puede colocar valores negativos en el presupuesto estimado."
  
  const descriptionInput = document.getElementById('input-description').value;
  if(descriptionInput.trim() === '')
    return "No pueden haber espacios en blanco en la descripción.";

  if (patronSQL.test(descriptionInput))
    return "Entrada de texto sospechaosa.";

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



function viewActivityDetails(type, description) {
  document.getElementById('detailType').innerText = type;
  document.getElementById('detailDescription').innerText = description || '—';
  document.getElementById('detail-activity-modal').showModal();
}