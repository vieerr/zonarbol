
package com.espe.zonarbol.service;

import com.espe.zonarbol.dao.ForestZoneDAO;
import com.espe.zonarbol.dao.TreeSpeciesDAO;


public class SummaryService {
    private TreeSpeciesDAO treeSpeciesDAO;
    private ForestZoneDAO forestZoneDAO;
    
    public SummaryService(){
        treeSpeciesDAO = new TreeSpeciesDAO();
        forestZoneDAO = new ForestZoneDAO();
    }
}
