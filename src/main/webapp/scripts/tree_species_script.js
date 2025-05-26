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