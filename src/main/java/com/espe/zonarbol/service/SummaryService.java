
package com.espe.zonarbol.service;

import com.espe.zonarbol.dao.ZoneSpeciesDAO;
import com.espe.zonarbol.model.ZoneSpecies;
import jakarta.servlet.http.HttpServletRequest;

public class SummaryService {
    private ZoneSpeciesDAO zoneSpecieDAO;
    
    public SummaryService(){
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
    
    public void handleUpdateTreeToZone(HttpServletRequest request) {
        ZoneSpecies newZoneSpecie = buildZoneSpecieFromRequest(request);
        
        if (zoneSpecieDAO.updateZoneSpecie(newZoneSpecie)) {
            request.getSession().setAttribute("successMessage", "Población de árbol actualziada exitosamente");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al actualizar la población de árbol");
        }
    }
    
    public void handleDeleteTreeToZone(HttpServletRequest request) {
        int zoneId = Integer.parseInt(request.getParameter("zoneId"));
        int speciesId = Integer.parseInt(request.getParameter("speciesId"));
        
        if (zoneSpecieDAO.deleteZoneSpecie(zoneId, speciesId)) {
            request.getSession().setAttribute("successMessage", "Especie eliminada exitosamente");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al eliminar la especie");
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
