package com.espe.zonarbol.routes;

import com.espe.zonarbol.dao.ForestZoneDAO;
import com.espe.zonarbol.model.ForestZone;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;

@WebServlet("/ForestZoneServlet")
public class ForestZoneServlet extends HttpServlet {
    private ForestZoneDAO zoneDAO;

    @Override
    public void init() {
        zoneDAO = new ForestZoneDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("forest-zones.jsp");
            return;
        }

        if ("search".equals(action)) {
            int zoneId = Integer.parseInt(request.getParameter("zoneId"));
            
            ForestZone matchedZone = zoneDAO.getForestZoneById(zoneId);
            
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            
            try (PrintWriter out = response.getWriter()) {
                Gson gson = new GsonBuilder()
                .disableHtmlEscaping()
                .create();
                out.print(gson.toJson(matchedZone));
            }
            
        } else {
            response.sendRedirect("forest-zones.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            // Get parameters from request
            String zoneName = request.getParameter("zoneName");
            String province = request.getParameter("province");
            String canton = request.getParameter("canton");
            double totalArea = Double.parseDouble(request.getParameter("totalAreaHectares"));
            String forestType = request.getParameter("forestType");
            String state = "ACTIVE";
            
            // Create new zone object
            ForestZone newZone = new ForestZone();
            newZone.setZoneName(zoneName);
            newZone.setProvince(province);
            newZone.setCanton(canton);
            newZone.setTotalAreaHectares(totalArea);
            newZone.setForestType(forestType);
            newZone.setState(state);
            
            if (zoneDAO.addForestZone(newZone)) {
                request.getSession().setAttribute("successMessage", "Zona añadida exitosamente");
            } else {
                request.getSession().setAttribute("errorMessage", "Error al añadir la zona");
            }
            
            // Redirect to prevent duplicate submissions
            response.sendRedirect("forest-zones.jsp");
        }
        
        if("update".equals(action)) {
            //Get parameters from request
            int zoneId = Integer.parseInt(request.getParameter("zoneId"));
            String zoneName = request.getParameter("zoneName");
            String province = request.getParameter("province");
            String canton = request.getParameter("canton");
            double totalArea = Double.parseDouble(request.getParameter("totalAreaHectares"));
            String forestType = request.getParameter("forestType");
            String state = request.getParameter("state");
            
            // Create new zone object
            ForestZone newZone = new ForestZone();
            newZone.setZoneId(zoneId);
            newZone.setZoneName(zoneName);
            newZone.setProvince(province);
            newZone.setCanton(canton);
            newZone.setTotalAreaHectares(totalArea);
            newZone.setForestType(forestType);
            newZone.setState(state);            
            
            if (zoneDAO.updateForestZone(newZone)) {
                request.getSession().setAttribute("successMessage", "Zona actualizada exitosamente");
            } else {
                request.getSession().setAttribute("errorMessage", "Error al actualizar la zona");
            }
            
            // Redirect to prevent duplicate submissions
            response.sendRedirect("forest-zones.jsp");
        }
        
        if("delete".equals(action)) {
            int activityId = Integer.parseInt(request.getParameter("zoneId"));
        
            if (zoneDAO.deleteForestZone(activityId)) {
                request.getSession().setAttribute("successMessage", "Actividad eliminada exitosamente");
            } else {
                request.getSession().setAttribute("errorMessage", "Error al eliminar la actividad");
            }
        
            response.sendRedirect("forest-zones.jsp");
        }
    }
    

}