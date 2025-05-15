package com.espe.zonarbol.dao;

import com.espe.zonarbol.model.ForestZone;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ForestZoneDAO {
    private Connection connection ;

    public ForestZoneDAO() {
        try {
//            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = ConnectionBDD.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<ForestZone> getAllForestZones() {
        List<ForestZone> zones = new ArrayList<>();
        String sql = "SELECT * FROM forest_zones ORDER BY zone_name";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                zones.add(new ForestZone(
                    rs.getInt("zone_id"),
                    rs.getString("zone_name"),
                    rs.getString("province"),
                    rs.getString("canton"),
                    rs.getDouble("total_area_hectares"),
                    rs.getString("forest_type"),
                    rs.getTimestamp("created_at"),
                    rs.getString("state")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return zones;
    }

    public ForestZone getForestZoneById(int zoneId) {
        String sql = "SELECT * FROM forest_zones WHERE zone_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, zoneId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return new ForestZone(
                    rs.getInt("zone_id"),
                    rs.getString("zone_name"),
                    rs.getString("province"),
                    rs.getString("canton"),
                    rs.getDouble("total_area_hectares"),
                    rs.getString("forest_type"),
                    rs.getTimestamp("created_at"),
                    rs.getString("state")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Add methods for insert, update, delete
}