package com.espe.zonarbol.service;

import com.espe.zonarbol.dao.TreeSpeciesDAO;
import com.espe.zonarbol.model.TreeSpecies;
import jakarta.servlet.http.HttpServletRequest;
import java.sql.SQLException;
import java.util.List;

public class TreeSpeciesService {
    private TreeSpeciesDAO speciesDAO;

    public TreeSpeciesService() {
        speciesDAO = new TreeSpeciesDAO();
    }

    public TreeSpecies getSpeciesById(int id) {
        return speciesDAO.getTreeSpeciesById(id);
    }

    public List<TreeSpecies> searchSpecies(String query) {
        return speciesDAO.searchTreeSpecies(query);
    }
    
    public List<TreeSpecies> getSpeciesByZone(int zoneId) {
        return speciesDAO.getTreeSpeciesByZone(zoneId);
    }

    public void handleAddSpecies(HttpServletRequest request) {
        TreeSpecies species = buildSpeciesFromRequest(request);
        
        if (speciesDAO.addTreeSpecies(species)) {
            request.getSession().setAttribute("successMessage", "Especie añadida exitosamente");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al añadir la especie");
        }
    }

    public void handleUpdateSpecies(HttpServletRequest request) {
        TreeSpecies species = buildSpeciesFromRequest(request);
        species.setSpeciesId(Integer.parseInt(request.getParameter("speciesId")));
        
        if (speciesDAO.updateTreeSpecies(species)) {
            request.getSession().setAttribute("successMessage", "Especie actualizada exitosamente");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al actualizar la especie");
        }
    }

    public void handleDeleteSpecies(HttpServletRequest request) {
        int speciesId = Integer.parseInt(request.getParameter("speciesId"));
        
        if (speciesDAO.deleteTreeSpecies(speciesId)) {
            request.getSession().setAttribute("successMessage", "Especie eliminada exitosamente");
        } else {
            request.getSession().setAttribute("errorMessage", "Error al eliminar la especie");
        }
    }

    private TreeSpecies buildSpeciesFromRequest(HttpServletRequest request) {
        TreeSpecies species = new TreeSpecies();
        species.setScientificName(request.getParameter("scientificName"));
        species.setCommonName(request.getParameter("commonName"));
        species.setFamily(request.getParameter("family"));
        species.setConservationStatus(request.getParameter("conservationStatus"));

        String lifespan = request.getParameter("averageLifespan");
        if (lifespan != null && !lifespan.isEmpty()) {
            species.setAverageLifespan(Integer.parseInt(lifespan));
        }

        return species;
    }
}