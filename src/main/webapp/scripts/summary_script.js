let currentZone = null;
let currentSpecies = null;
let currentActivities = null;

async function loadZoneData(zoneId) {
    try {
        const reqString = "/zonarbol/SummaryServerlet?action=getZoneData&zoneId=" + zoneId;
        const response = await fetch(reqString);
        currentZone = await response.json();
    
        updateZoneInfo(currentZone);
    } catch (error) {
        console.error('Error:', error);
    }
}

function updateZoneInfo(zone) {
  document.getElementById('zone-info-wrapper').innerHTML = `
		<div class="my-8">
			<label class="text-black">
				<span class="font-semibold">Provincia:</span>
				<span> ${zone.province} </span>
			</label>
		</div>
		<div class="my-8">
			<label class="text-black">
				<span class="font-semibold">Cantón:</span>
				<span> ${zone.canton} </span>
			</label>
		</div>
		<div class="my-8">
			<label class="text-black">
				<span class="font-semibold">Tipo de bosque:</span>
				<span> ${zone.forestType} </span>
			</label>
		</div>
		<div class="my-8">
			<label class="text-black">
				<span class="font-semibold">Extensión:</span>
				<span> ${zone.totalAreaHectares} hectareas</span>
			</label>
		</div>
	`;

	loadGroupButtons();
}

function loadGroupButtons() {
	document.getElementById('zone-info-wrapper').innerHTML += `
		<button onclick="openAddTreeModal()" class="text-white border-2 border-lime-500 rounded-xl w-full bg-lime-500 p-4 my-2">
      <i class="fas fa-plus"></i>
      Agregar árbol
    </button>
    <button onclick="openAddActivityModal()" class="text-white border-2 border-green-600 rounded-xl w-full bg-green-600 p-4 my-2">
       <i class="fas fa-plus"></i>
       Agregar actividad
    </button>
	`;
}

async function getPopulationFromTree(specieId){
	try {
        const reqString = `/zonarbol/SummaryServerlet?action=getTreePopulation&zoneId=${currentZone.zoneId}&specieId=${specieId}`;
        const response = await fetch(reqString);
        const text = await response.text();

        return parseInt(text);
    } catch (error) {
        console.error('Error:', error);
    }
}


async function updateSpecieInfo(specie) {
  const treePopulation = await getPopulationFromTree(specie.speciesId);

	return `
		<div class="my-4 border-2 border-lime-500 rounded-xl p-4">
      <div class="rounded-sm text-center font-bold">
          ${specie.commonName}
      </div>
      <div class="grid grid-cols-[1fr_1fr] gap-4 w-full text-center">
          <div>
              <div class="m-2">
                  <label class="text-black">
                      <span class="font-semibold">Nombre Científico:</span>
                      <span>${specie.scientificName}</span>
                  </label>
              </div>
              <div class="m-2">
                  <label class="text-black">
                      <span class="font-semibold">Familia:</span>
                      <span>${specie.family}</span>
                  </label>
              </div>
              <div class="m-2">
                  <label class="text-black">
                      <span class="font-semibold">Vida Promedio:</span>
                      <span>${specie.averageLifespan} años</span>
                  </label>
              </div>
          </div>
          <div>
              <div class="m-4">
                  <label class="text-black">
                      <span class="font-semibold">Estado de conservación:</span>
                      <span>${specie.conservationStatus}</span>
                  </label>
              </div>
              <div class="m-6"> 
                  <label class="text-black">
                      <span class="font-semibold">Población estimada:</span>
                      <span>${treePopulation}</span>
                  </label>
              </div>
          </div>
      </div>
      <div class="flex space-x-2 justify-end">
        <button onclick="openEditTreeModal(${specie.speciesId})" 
                class="btn btn-sm btn-info">
            <i class="fas fa-edit text-white"></i>
            <p class="text-white">Editar</p>
        </button>
        <button onclick="confirmRemoveTreeFromZone(${specie.speciesId})" 
                class="btn btn-sm btn-error ml-2">
            <i class="fas fa-trash text-white"></i>
            <p class="text-white">Quitar</p>
        </button>
      </div>
		</div>	
	`
}

async function loadSpeciesFromZone(zoneId) {
    try {
        const reqString = "/zonarbol/SummaryServerlet?action=getZoneSpecies&zoneId=" + zoneId;
        const response = await fetch(reqString);
                      
        currentSpecies = await response.json();

				const speciesWrapper = document.getElementById("species-wrapper");

				if(currentSpecies.length === 0){
					speciesWrapper.innerHTML = `
						<div class="my-4 border-2 border-lime-500 rounded-xl p-4">
    					<div class="rounded-sm text-center font-bold">
    						Todavia no se ha agregado una especie a esta zona
    					</div>
   					</div>
					`;
					return;
				}

				speciesWrapper.innerHTML = "";

				currentSpecies.forEach(async specie => {
					const containerHtml = await updateSpecieInfo(specie);
					speciesWrapper.innerHTML += containerHtml;
				});
    } catch (error) {
        console.error('Error:', error);
    }
}

function updateActivityInfo(activity) {
	if(!activity.endDate) {
		activity.endDate = "En curso";
	}

	return `
		<div class="my-4 border-2 border-green-600 rounded-xl p-4">
      <div class="rounded-sm text-center font-bold">
          ${activity.activityType}
      </div>
      <div class="grid grid-cols-[1fr_1fr] gap-4 w-full text-center">
        <div>
          <div class="m-4">
            <label class="text-black">
              <span class="font-semibold">Responsable:</span>
              <span>${activity.responsibleEntity}</span>
            </label>
          </div>
          <div class="m-6">
            <label class="text-black">
              <span class="font-semibold">Fecha Inicio:</span>
              <span>${activity.startDate}</span>
            </label>
          </div>
        </div>
        <div>
          <div class="m-4">
            <label class="text-black">
              <span class="font-semibold">Presupuesto:</span>
              <span>$ ${activity.estimatedBudget}</span>
            </label>
          </div>
          <div class="m-6"> 
              <label class="text-black">
                <span class="font-semibold">Fecha Fin:</span>
                <span>${activity.endDate}</span>
              </label>
          </div>
        </div>
      </div>
      <div>
        <label class="text-black">
          <span class="font-semibold">Descripción:</span>
        </label>
        <p class="text-black">${activity.description}</p>
      </div>
    </div>
	`
}

async function loadActivitiesFromZone(zoneId) {
    try {
        const reqString = "/zonarbol/SummaryServerlet?action=getZoneActivities&zoneId=" + zoneId;
        const response = await fetch(reqString);
                      
        currentActivities = await response.json();

				const activitiesWrapper = document.getElementById("activities-wrapper");

				if(currentActivities.length === 0){
					activitiesWrapper.innerHTML = `
						<div class="my-4 border-2 border-green-600 rounded-xl p-4">
    					<div class="rounded-sm text-center font-bold">
    						Todavia no se ha asignado una actividad a esta zona
    					</div>
   					</div>
					`;
					return;
				}

				activitiesWrapper.innerHTML = "";

				currentActivities.forEach(activity => {
					const containerHtml = updateActivityInfo(activity);
					activitiesWrapper.innerHTML += containerHtml;
				});        
    } catch (error) {
        console.error('Error:', error);
    }
}

function resetWrappers() {
	document.getElementById('zone-info-wrapper').innerHTML = '';
	const activitiesWrapper = document.getElementById("activities-wrapper");
	const speciesWrapper = document.getElementById("species-wrapper");

	speciesWrapper.innerHTML = `
    <div class="my-4 border-2 border-lime-500 rounded-xl p-4">
      <div class="rounded-sm text-center font-bold">
        Seleccione una Zona
      </div>
    </div>
	`;

	activitiesWrapper.innerHTML = `
    <div class="my-4 border-2 border-green-600 rounded-xl p-4">
    	<div class="rounded-sm text-center font-bold">
    		Seleccione una Zona
    	</div>
    </div>
	`;
}

document.getElementById('zoneName').addEventListener('change', async function() {              
    const index = this.selectedIndex;
    
    if(index != 0){
      const selectedOption = this.options[index];
      const zoneId = selectedOption.getAttribute("related-zone-id");
      await loadZoneData(zoneId);
      await loadSpeciesFromZone(zoneId);
			loadActivitiesFromZone(zoneId);
    } else {
      resetWrappers();
      currentZone = null;
    }
});


//Form related stuff
const formModal = document.getElementById('base-modal-form');
const specieSelect = document.getElementById('commonName');

specieSelect.addEventListener('change', function() {
  const index = this.selectedIndex;
    
  if(index != 0){
    const selectedOption = this.options[index];
    const specieId = selectedOption.getAttribute("related-specie-id");
    document.getElementById('input-specieId').value = specieId;
  } else {
    document.getElementById('input-specieId').value = "0";
  }
});

function openAddTreeModal() {
    document.getElementById('form-title').innerHTML = `Añadir árbol a la zona ${currentZone.zoneName}`;
    document.getElementById('input-action').value = "add_specie";
		document.getElementById('input-zoneId').value = currentZone.zoneId;

    document.getElementById('commonName').value = "";
		document.getElementById('input-populationEstimate').value = "";

    document.getElementById('commonName').disabled = false;

    document.getElementById('btn-sumbit-action').innerText = "Añadir";
   
    formModal.show();
}

async function openEditTreeModal(specieId) {
  const urlSpecie = `/zonarbol/TreeSpeciesServlet?action=search&id=${specieId}`
  const urlPopulation = `/zonarbol/SummaryServerlet?action=getTreePopulation&zoneId=${currentZone.zoneId}&specieId=${specieId}`;

  try {
      const resSpecies = await fetch(urlSpecie);
      const dataSpecies = await resSpecies.json();
      const resPopulation = await fetch(urlPopulation);
      const dataPopulation = await resPopulation.text();

      const data = {
        specieId: dataSpecies.speciesId,
        commonName: dataSpecies.commonName,
        populationEstimate: dataPopulation
      }

      placeZoneSpecieDataInForm(data);
      
      formModal.show();
  } catch (error) {
      console.error('Error:', error);
  }
}

function placeZoneSpecieDataInForm(data){
    document.getElementById('form-title').innerHTML = 'Actualizar población de árbol';
    
    document.getElementById('input-action').value = "update_specie";
    document.getElementById('input-zoneId').value = currentZone.zoneId;
    document.getElementById('input-specieId').value = data.specieId; 
    selectOption(document.getElementById('commonName'), data.commonName);
    
    document.getElementById('input-populationEstimate').value = data.populationEstimate;
    
    document.getElementById('commonName').disabled = true;

    document.getElementById('btn-sumbit-action').innerText = "Actualizar";
}

function confirmRemoveTreeFromZone(specieId) {
  if (!confirm("¿Está seguro que desea quitar este árbol de esta zona forestal?")) {
      return;
  }

  const form = document.createElement("form");
  form.method = "POST";
  form.action = "SummaryServerlet";
  const inputAction = document.createElement("input");
  inputAction.type = "hidden";
  inputAction.name = "action";
  inputAction.value = "delete_specie";
  form.appendChild(inputAction);
  const inputZoneId = document.createElement("input");
  inputZoneId.type = "hidden";
  inputZoneId.name = "zoneId";
  inputZoneId.value = currentZone.zoneId;
  form.appendChild(inputZoneId);
  const inputActivityId = document.createElement("input");
  inputActivityId.type = "hidden";
  inputActivityId.name = "speciesId";
  inputActivityId.value = specieId;
  form.appendChild(inputActivityId);
  document.body.appendChild(form);
  form.submit();
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