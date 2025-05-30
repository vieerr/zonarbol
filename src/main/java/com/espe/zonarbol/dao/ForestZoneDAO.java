package com.espe.zonarbol.dao;

import com.espe.zonarbol.model.ForestZone;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ForestZoneDAO {

    private Connection connection;

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
        String sql = "SELECT * FROM forest_zones WHERE state='ACTIVE' ORDER BY zone_name;";

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

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

    public int getForestZonesCount() {
        String sql = "SELECT COUNT(*) FROM forest_zones WHERE state='ACTIVE' ";
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getForestZonesAddedThisMonth() {
        String sql = "SELECT COUNT(*) FROM forest_zones WHERE MONTH(created_at) = MONTH(CURRENT_DATE()) "
                + "AND YEAR(created_at) = YEAR(CURRENT_DATE()) AND state='ACTIVE'";
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getProtectedAreasCount() {
        String sql = "SELECT COUNT(*) FROM forest_zones WHERE forest_type LIKE '%Protegido%' "
                + "OR forest_type LIKE '%Reserva%' OR forest_type LIKE '%Parque%'";
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getProtectedAreasAddedThisQuarter() {
        String sql = "SELECT COUNT(*) FROM forest_zones "
                + "WHERE (forest_type LIKE '%Protegido%' OR forest_type LIKE '%Reserva%' OR forest_type LIKE '%Parque%') "
                + "AND QUARTER(created_at) = QUARTER(CURRENT_DATE()) "
                + "AND YEAR(created_at) = YEAR(CURRENT_DATE())";
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<ForestZone> getZonesForReport(String province, String forestType, String state,
            Date startDate, Date endDate) {
        List<ForestZone> zones = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM forest_zones WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (province != null && !province.isEmpty()) {
            sql.append(" AND province = ?");
            params.add(province);
        }

        if (forestType != null && !forestType.isEmpty()) {
            sql.append(" AND forest_type = ?");
            params.add(forestType);
        }

        if (state != null && !state.isEmpty()) {
            sql.append(" AND state = ?");
            params.add(state);
        }

        if (startDate != null) {
            sql.append(" AND created_at >= ?");
            params.add(new java.sql.Date(startDate.getTime()));
        }

        if (endDate != null) {
            sql.append(" AND created_at <= ?");
            params.add(new java.sql.Date(endDate.getTime()));
        }

        sql.append(" ORDER BY zone_name");

        try (PreparedStatement stmt = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                zones.add(extractForestZoneFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return zones;
    }
    
    public boolean addForestZone(ForestZone forestZone){       
        String sql = "INSERT INTO forest_zones (zone_name, province, canton, total_area_hectares, forest_type)"
                + "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, forestZone.getZoneName());
            stmt.setString(2, forestZone.getProvince());
            stmt.setString(3, forestZone.getCanton());
            stmt.setDouble(4, forestZone.getTotalAreaHectares());
            stmt.setString(5, forestZone.getForestType());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                return false;
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    forestZone.setZoneId(generatedKeys.getInt(1));
                }
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Update tree species
    public boolean updateForestZone(ForestZone forestZone) {
        String sql = "UPDATE forest_zones SET zone_name = ?, province = ?, "
                + "canton = ?, total_area_hectares = ?, forest_type = ? "
                + "WHERE zone_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, forestZone.getZoneName());
            stmt.setString(2, forestZone.getProvince());
            stmt.setString(3, forestZone.getCanton());
            stmt.setDouble(4, forestZone.getTotalAreaHectares());
            stmt.setString(5, forestZone.getForestType());
            
            stmt.setInt(6, forestZone.getZoneId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete forest zone
    public boolean deleteForestZone(int zoneId) {
        String sql = "UPDATE forest_zones SET state='INACTIVE' WHERE zone_id = ?;";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, zoneId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private ForestZone extractForestZoneFromResultSet(ResultSet rs) throws SQLException {
        ForestZone zone = new ForestZone();
        zone.setZoneId(rs.getInt("zone_id"));
        zone.setZoneName(rs.getString("zone_name"));
        zone.setProvince(rs.getString("province"));
        zone.setCanton(rs.getString("canton"));
        zone.setTotalAreaHectares(rs.getDouble("total_area_hectares"));
        zone.setForestType(rs.getString("forest_type"));
        zone.setCreatedAt(rs.getTimestamp("created_at"));
        zone.setState(rs.getString("state"));
        return zone;
    }
}
