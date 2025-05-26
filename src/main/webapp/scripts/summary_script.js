let currentZoneData = null;
let currentSpecies = null;

async function loadZoneData(zoneId) {
    try {
        const reqString = "/zonarbol/SummaryServerlet?action=getZoneData&zoneId=" + zoneId;
        const response = await fetch(reqString);
        currentZoneData = await response.json();
    
        updateZoneInfo(currentZoneData);
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
				<span> ${zone.totalAreaHectares} hectareas</span></label></div>
	`;
}

function updateSpecieInfo(specie) {
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
                      <span>AGREGAR VALOR</span>
                  </label>
              </div>
          </div>
      </div>
		</div>	
	`
}

async function loadSpeciesFromZone(zoneId) {
    try {
        const reqString = "/zonarbol/SummaryServerlet?action=getZoneSpecies&zoneId=" + zoneId;
        const response = await fetch(reqString);
                      
        const speciesContainers = await response.json();

				const speciesWrapper = document.getElementById("species-wrapper");

				if(speciesContainers.length === 0){
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

				speciesContainers.forEach(specie => {
					const containerHtml = updateSpecieInfo(specie);
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
                      
        const activitiesContainers = await response.json();

				const activitiesWrapper = document.getElementById("activities-wrapper");

				if(activitiesContainers.length === 0){
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

				activitiesContainers.forEach(activity => {
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

document.getElementById('zoneName').addEventListener('change', function() {              
    const index = this.selectedIndex;
    
    if(index != 0){
      const selectedOption = this.options[index];
      const zoneId = selectedOption.getAttribute("related-zone-id");
      loadZoneData(zoneId);
      loadSpeciesFromZone(zoneId);
			loadActivitiesFromZone(zoneId);
    } else {
      resetWrappers();
      currentZoneData = null;
    }
});