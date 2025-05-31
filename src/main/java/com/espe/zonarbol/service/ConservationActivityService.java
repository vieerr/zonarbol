package com.espe.zonarbol.service;

import com.espe.zonarbol.dao.ConservationActivityDAO;
import com.espe.zonarbol.dao.ForestZoneDAO;
import com.espe.zonarbol.model.ConservationActivity;
import jakarta.servlet.http.HttpServletRequest;
import java.sql.Date;
import java.util.List;

public class ConservationActivityService {
    private ConservationActivityDAO activityDAO;
    private ForestZoneDAO zoneDAO;

    public ConservationActivityService() {
        activityDAO = new ConservationActivityDAO();
        zoneDAO = new ForestZoneDAO();
    }

    public ConservationActivity getActivityById(int id) {
        return activityDAO.getConservationActivityById(id);
    }
    
    public List<ConservationActivity> getActivitiesByZone(int zoneId) {
        return activityDAO.getActivitiesByZone(zoneId);
    }

    public void handleAddActivity(HttpServletRequest request) {
        ConservationActivity activity = buildActivityFromRequest(request);
        
        if (activityDAO.addConservationActivity(activity)) {
            request.getSession().setAttribute("successMessage", "Actividad añadida exitosamente");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al añadir la actividad");
        }
    }

    public void handleUpdateActivity(HttpServletRequest request) {
        ConservationActivity activity = buildActivityFromRequest(request);
        activity.setActivityId(Integer.parseInt(request.getParameter("activityId")));
        
        if (activityDAO.updateConservationActivity(activity)) {
            request.getSession().setAttribute("successMessage", "Actividad actualizada exitosamente");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al actualizar la actividad");
        }
    }

    public void handleDeleteActivity(HttpServletRequest request) {
        int activityId = Integer.parseInt(request.getParameter("activityId"));
        
        if (activityDAO.deleteConservationActivity(activityId)) {
            request.getSession().setAttribute("successMessage", "Actividad eliminada exitosamente");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al eliminar la actividad");
        }
    }

    private ConservationActivity buildActivityFromRequest(HttpServletRequest request) {
        ConservationActivity activity = new ConservationActivity();
        activity.setZoneId(Integer.parseInt(request.getParameter("zoneId")));
        activity.setActivityType(request.getParameter("activityType"));
        activity.setStartDate(Date.valueOf(request.getParameter("startDate")));

        String endDate = request.getParameter("endDate");
        if (endDate != null && !endDate.isEmpty()) {
            activity.setEndDate(Date.valueOf(endDate));
        }

        activity.setDescription(request.getParameter("description"));
        activity.setResponsibleEntity(request.getParameter("responsibleEntity"));

        String budget = request.getParameter("estimatedBudget");
        if (budget != null && !budget.isEmpty()) {
            activity.setEstimatedBudget(Double.parseDouble(budget));
        }

        activity.setState("ACTIVE");
        return activity;
    }
}