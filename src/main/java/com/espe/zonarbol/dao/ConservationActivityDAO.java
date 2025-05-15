package com.espe.zonarbol.dao;

import com.espe.zonarbol.model.ConservationActivity;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConservationActivityDAO {
    private Connection connection;

    public ConservationActivityDAO() {
        try {
            connection = ConnectionBDD.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all conservation activities
    public List<ConservationActivity> getAllConservationActivities() {
        List<ConservationActivity> activities = new ArrayList<>();
        String sql = "SELECT * FROM conservation_activities ORDER BY start_date DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                activities.add(extractConservationActivityFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return activities;
    }

    // Get activity by ID
    public ConservationActivity getConservationActivityById(int activityId) {
        String sql = "SELECT * FROM conservation_activities WHERE activity_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, activityId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractConservationActivityFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Add new conservation activity
    public boolean addConservationActivity(ConservationActivity activity) {
        String sql = "INSERT INTO conservation_activities (zone_id, activity_type, " +
                     "start_date, end_date, description, responsible_entity, " +
                     "estimated_budget, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, activity.getZoneId());
            stmt.setString(2, activity.getActivityType());
            stmt.setDate(3, activity.getStartDate());
            
            if (activity.getEndDate() != null) {
                stmt.setDate(4, activity.getEndDate());
            } else {
                stmt.setNull(4, Types.DATE);
            }
            
            stmt.setString(5, activity.getDescription());
            stmt.setString(6, activity.getResponsibleEntity());
            
            if (activity.getEstimatedBudget() != null) {
                stmt.setDouble(7, activity.getEstimatedBudget());
            } else {
                stmt.setNull(7, Types.DECIMAL);
            }
            
            stmt.setString(8, activity.getState());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                return false;
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    activity.setActivityId(generatedKeys.getInt(1));
                }
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update conservation activity
    public boolean updateConservationActivity(ConservationActivity activity) {
        String sql = "UPDATE conservation_activities SET zone_id = ?, activity_type = ?, " +
                     "start_date = ?, end_date = ?, description = ?, responsible_entity = ?, " +
                     "estimated_budget = ?, state = ? WHERE activity_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, activity.getZoneId());
            stmt.setString(2, activity.getActivityType());
            stmt.setDate(3, activity.getStartDate());
            
            if (activity.getEndDate() != null) {
                stmt.setDate(4, activity.getEndDate());
            } else {
                stmt.setNull(4, Types.DATE);
            }
            
            stmt.setString(5, activity.getDescription());
            stmt.setString(6, activity.getResponsibleEntity());
            
            if (activity.getEstimatedBudget() != null) {
                stmt.setDouble(7, activity.getEstimatedBudget());
            } else {
                stmt.setNull(7, Types.DECIMAL);
            }
            
            stmt.setString(8, activity.getState());
            stmt.setInt(9, activity.getActivityId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete conservation activity
    public boolean deleteConservationActivity(int activityId) {
        String sql = "DELETE FROM conservation_activities WHERE activity_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, activityId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get activities by zone
    public List<ConservationActivity> getActivitiesByZone(int zoneId) {
        List<ConservationActivity> activities = new ArrayList<>();
        String sql = "SELECT * FROM conservation_activities WHERE zone_id = ? ORDER BY start_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, zoneId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                activities.add(extractConservationActivityFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return activities;
    }

    // Helper method to extract ConservationActivity from ResultSet
    private ConservationActivity extractConservationActivityFromResultSet(ResultSet rs) throws SQLException {
        ConservationActivity activity = new ConservationActivity();
        activity.setActivityId(rs.getInt("activity_id"));
        activity.setZoneId(rs.getInt("zone_id"));
        activity.setActivityType(rs.getString("activity_type"));
        activity.setStartDate(rs.getDate("start_date"));
        activity.setEndDate(rs.getDate("end_date"));
        activity.setDescription(rs.getString("description"));
        activity.setResponsibleEntity(rs.getString("responsible_entity"));
        activity.setEstimatedBudget(rs.getDouble("estimated_budget"));
        if (rs.wasNull()) {
            activity.setEstimatedBudget(null);
        }
        activity.setCreatedAt(rs.getTimestamp("created_at"));
        activity.setState(rs.getString("state"));
        return activity;
    }
}