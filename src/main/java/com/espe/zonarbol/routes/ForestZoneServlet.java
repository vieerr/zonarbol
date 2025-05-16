package com.espe.zonarbol.routes;

import com.espe.zonarbol.dao.ForestZoneDAO;
import com.espe.zonarbol.model.ForestZone;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ForestZoneServlet")
public class ForestZoneServlet extends HttpServlet {
    private ForestZoneDAO zoneDAO;

    @Override
    public void init() {
        zoneDAO = new ForestZoneDAO();
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
            
            // Add to database (implementation needed in DAO)
            // zoneDAO.addForestZone(newZone);
            
            // Redirect to prevent duplicate submissions
            response.sendRedirect("forest-zones.jsp");
        }
        // Add other actions (update, delete)
    }
    

}