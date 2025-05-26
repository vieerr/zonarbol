function viewActivityDetails(type, description) {
  document.getElementById('detailType').innerText = type;
  document.getElementById('detailDescription').innerText = description || '—';
  document.getElementById('detail-activity-modal').showModal();
}

async function openEditActivityModal(activityId) {
  try {
    const url = `/zonarbol/ConservationActivityServlet?action=search&id=` + activityId;
    const response = await fetch(url);
    const text = await response.text();
    if (!text)
        throw new Error("Respuesta vacía");

    const data = JSON.parse(text);
    document.getElementById('editActivityId').value = data.activityId;
    document.getElementById('editZoneId').value = data.zoneId;
    document.getElementById('editActivityType').value = data.activityType;
    document.getElementById('editStartDate').value = data.startDate.split(' ')[0];
    document.getElementById('editEndDate').value = data.endDate ? data.endDate.split(' ')[0] : '';
    document.getElementById('editResponsibleEntity').value = data.responsibleEntity;
    document.getElementById('editEstimatedBudget').value = data.estimatedBudget;
    document.getElementById('editDescription').value = data.description;
    document.getElementById('edit-activity-modal').showModal();

  } catch (err) {
    alert("Error al cargar los datos");
    console.error(err);
  }
}

function confirmDeleteActivity(activityId) {
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