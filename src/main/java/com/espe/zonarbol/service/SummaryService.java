
package com.espe.zonarbol.service;

import com.espe.zonarbol.dao.ForestZoneDAO;
import com.espe.zonarbol.dao.TreeSpeciesDAO;
import com.espe.zonarbol.dao.ZoneSpeciesDAO;
import com.espe.zonarbol.model.ZoneSpecies;
import jakarta.servlet.http.HttpServletRequest;

public class SummaryService {
    private TreeSpeciesDAO treeSpeciesDAO;
    private ForestZoneDAO forestZoneDAO;
    private ZoneSpeciesDAO zoneSpecieDAO;
    
    public SummaryService(){
        treeSpeciesDAO = new TreeSpeciesDAO();
        forestZoneDAO = new ForestZoneDAO();
        zoneSpecieDAO = new ZoneSpeciesDAO();
    }
    
    public int getTreePopulationFromZone(int zoneId, int specieId){
        return zoneSpecieDAO.getTreePopulationFromZone(zoneId,specieId);
    }
    
    public void handleAddTreeToZone(HttpServletRequest request) {
        ZoneSpecies newZoneSpecie = buildZoneSpecieFromRequest(request);
        
        if (zoneSpecieDAO.addZoneSpecie(newZoneSpecie)) {
            request.getSession().setAttribute("successMessage", "Árbol añadido exitosamente a la zona");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al añadir el árbol a la zona");
        }
    }
    
    private ZoneSpecies buildZoneSpecieFromRequest(HttpServletRequest request) {
        ZoneSpecies zoneSpecie = new ZoneSpecies();
        zoneSpecie.setZoneId(Integer.parseInt(request.getParameter("zoneId")));
        zoneSpecie.setSpeciesId(Integer.parseInt(request.getParameter("specieId")));
        zoneSpecie.setPopulationEstimate(Integer.parseInt(request.getParameter("populationEstimate")));
        
        System.out.println(zoneSpecie.getZoneId());
        System.out.println(zoneSpecie.getSpeciesId());
        System.out.println(zoneSpecie.getPopulationEstimate());
        
        return zoneSpecie;
    }
}
