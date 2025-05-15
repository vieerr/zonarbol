package com.espe.zonarbol.routes;

import com.espe.zonarbol.dao.ConservationActivityDAO;
import com.espe.zonarbol.dao.ForestZoneDAO;
import com.espe.zonarbol.model.ConservationActivity;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/ConservationActivityServlet")
public class ConservationActivityServlet extends HttpServlet {
    private ConservationActivityDAO activityDAO;
    private ForestZoneDAO zoneDAO;

    @Override
    public void init() {
        activityDAO = new ConservationActivityDAO();
        zoneDAO = new ForestZoneDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("conservation-activities.jsp");
            return;
        }

        switch (action) {
            case "add":
                addConservationActivity(request, response);
                break;
            case "update":
                updateConservationActivity(request, response);
                break;
            case "delete":
                deleteConservationActivity(request, response);
                break;
            default:
                response.sendRedirect("conservation-activities.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("conservation-activities.jsp");
            return;
        }

        if ("filter".equals(action)) {
            String zoneId = request.getParameter("zoneId");
            String activityType = request.getParameter("activityType");
            String state = request.getParameter("state");
            
            // Implement filtering logic here
            // You would create a method in DAO to handle filtered queries
            // For now, just redirect back
            response.sendRedirect("conservation-activities.jsp");
        } else {
            response.sendRedirect("conservation-activities.jsp");
        }
    }

    private void addConservationActivity(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
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
        
        activity.setState(request.getParameter("state"));
        
        if (activityDAO.addConservationActivity(activity)) {
            request.getSession().setAttribute("successMessage", "Actividad añadida exitosamente");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al añadir la actividad");
        }
        
        response.sendRedirect("conservation-activities.jsp");
    }

    private void updateConservationActivity(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        ConservationActivity activity = new ConservationActivity();
        activity.setActivityId(Integer.parseInt(request.getParameter("activityId")));
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
            activity.setEstimatedBudget(Double.valueOf(budget));
        }
        
        activity.setState(request.getParameter("state"));
        
        if (activityDAO.updateConservationActivity(activity)) {
            request.getSession().setAttribute("successMessage", "Actividad actualizada exitosamente");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al actualizar la actividad");
        }
        
        response.sendRedirect("conservation-activities.jsp");
    }

    private void deleteConservationActivity(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int activityId = Integer.parseInt(request.getParameter("activityId"));
        
        if (activityDAO.deleteConservationActivity(activityId)) {
            request.getSession().setAttribute("successMessage", "Actividad eliminada exitosamente");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al eliminar la actividad");
        }
        
        response.sendRedirect("conservation-activities.jsp");
    }
}