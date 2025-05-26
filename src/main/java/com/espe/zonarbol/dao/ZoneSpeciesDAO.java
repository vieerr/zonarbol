package com.espe.zonarbol.dao;

import com.espe.zonarbol.model.ZoneSpecies;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;

public class ZoneSpeciesDAO {
    private Connection connection;
    
    public ZoneSpeciesDAO(){
        try {
            connection = ConnectionBDD.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public int getTreePopulationFromZone(int zoneId, int specieId){
        String sql = "SELECT population_estimate FROM zone_species WHERE zone_id = ? AND species_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, zoneId);
            stmt.setInt(2, specieId);
            
            try (ResultSet rs = stmt.executeQuery()){
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public boolean addZoneSpecie(ZoneSpecies zoneSpecies) {
        String sql = "INSERT INTO zone_species (zone_id, species_id, population_estimate) VALUES (?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, zoneSpecies.getZoneId());
            stmt.setInt(2, zoneSpecies.getSpeciesId());
            stmt.setInt(3, zoneSpecies.getPopulationEstimate());
            
            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                return false;
            }
            
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateZoneSpecie(ZoneSpecies zoneSpecies) {
        String sql = "UPDATE zone_species SET population_estimate = ? WHERE zone_id = ? AND species_id = ?;";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, zoneSpecies.getPopulationEstimate());
            stmt.setInt(2, zoneSpecies.getZoneId());
            stmt.setInt(3, zoneSpecies.getSpeciesId());   
            
            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                return false;
            }
            
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteZoneSpecie(int zoneId, int speciesId) {
        String sql = "DELETE FROM zone_species WHERE zone_id = ? AND species_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, zoneId);
            stmt.setInt(2, speciesId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
