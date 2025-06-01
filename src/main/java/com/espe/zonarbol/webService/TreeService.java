package com.espe.zonarbol.webService;

import com.espe.zonarbol.dao.TreeSpeciesDAO;
import com.espe.zonarbol.model.TreeSpecies;
import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;

@WebService(serviceName = "TreeService")
public class TreeService {

 private TreeSpeciesDAO dao = new TreeSpeciesDAO();

    @WebMethod
    public List<TreeSpecies> getAllTreeSpecies() {
        return dao.getAllTreeSpecies();
    }

    @WebMethod
    public TreeSpecies getTreeSpeciesById(@WebParam(name = "speciesId") int speciesId) {
        return dao.getTreeSpeciesById(speciesId);
    }

    @WebMethod
    public boolean addTreeSpecies(@WebParam(name = "species") TreeSpecies species) {
        return dao.addTreeSpecies(species);
    }

    @WebMethod
    public boolean updateTreeSpecies(@WebParam(name = "species") TreeSpecies species) {
        return dao.updateTreeSpecies(species);
    }

    @WebMethod
    public boolean deleteTreeSpecies(@WebParam(name = "speciesId") int speciesId) {
        return dao.deleteTreeSpecies(speciesId);
    }

    @WebMethod
    public List<TreeSpecies> searchTreeSpecies(@WebParam(name = "query") String query) {
        return dao.searchTreeSpecies(query);
    }

    @WebMethod
    public int getTreeSpeciesCount() {
        return dao.getTreeSpeciesCount();
    }

    @WebMethod
    public int getSpeciesAddedThisMonth() {
        return dao.getSpeciesAddedThisMonth();
    }

    @WebMethod
    public List<TreeSpecies> getTreeSpeciesByZone(@WebParam(name = "zoneId") int zoneId) {
        return dao.getTreeSpeciesByZone(zoneId);
    }

    @WebMethod
    public List<TreeSpecies> getTreeSpeciesByActivity(@WebParam(name = "activityId") int activityId) throws SQLException {
        return dao.getTreeSpeciesByActivity(activityId);
    }

    @WebMethod
    public Integer getTreeSpeciesQuantityByActivity(
            @WebParam(name = "activityId") int activityId,
            @WebParam(name = "speciesId") int speciesId) throws SQLException {
        return dao.getTreeSpeciesQuantityByActivity(activityId, speciesId);
    }

    @WebMethod
    public Integer getTreeSpeciesPopulationByZone(
            @WebParam(name = "zoneId") int zoneId,
            @WebParam(name = "speciesId") int speciesId) throws SQLException {
        return dao.getTreeSpeciesPopulationByZone(zoneId, speciesId);
    }
}
