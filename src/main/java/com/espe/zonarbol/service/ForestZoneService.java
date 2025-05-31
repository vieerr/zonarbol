package com.espe.zonarbol.service;

import com.espe.zonarbol.dao.ForestZoneDAO;
import com.espe.zonarbol.model.ForestZone;
import jakarta.servlet.http.HttpServletRequest;

public class ForestZoneService {
    private ForestZoneDAO zoneDAO;

    public ForestZoneService() {
        zoneDAO = new ForestZoneDAO();
    }

    public ForestZone getZoneById(int zoneId) {
        return zoneDAO.getForestZoneById(zoneId);
    }

    public void handleAddZone(HttpServletRequest request) {
        ForestZone newZone = buildZoneFromRequest(request);
        
        if (zoneDAO.addForestZone(newZone)) {
            request.getSession().setAttribute("successMessage", "Zona añadida exitosamente");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al añadir la zona");
        }
    }

    public void handleUpdateZone(HttpServletRequest request) {
        ForestZone updatedZone = buildZoneFromRequest(request);
        updatedZone.setZoneId(Integer.parseInt(request.getParameter("zoneId")));
        
        if (zoneDAO.updateForestZone(updatedZone)) {
            request.getSession().setAttribute("successMessage", "Zona actualizada exitosamente");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al actualizar la zona");
        }
    }

    public void handleDeleteZone(HttpServletRequest request) {
        int zoneId = Integer.parseInt(request.getParameter("zoneId"));
        
        if (zoneDAO.deleteForestZone(zoneId)) {
            request.getSession().setAttribute("successMessage", "Zona eliminada exitosamente");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al eliminar la zona");
        }
    }

    private ForestZone buildZoneFromRequest(HttpServletRequest request) {
        ForestZone zone = new ForestZone();
        zone.setZoneName(request.getParameter("zoneName"));
        zone.setProvince(request.getParameter("province"));
        zone.setCanton(request.getParameter("canton"));
        zone.setTotalAreaHectares(Double.parseDouble(request.getParameter("totalAreaHectares")));
        zone.setForestType(request.getParameter("forestType"));
        
        // For update operations, state comes from request
        String state = request.getParameter("state");
        zone.setState(state != null ? state : "ACTIVE");
        
        return zone;
    }
}