package com.espe.zonarbol.dao;

import com.espe.zonarbol.model.TreeSpecies;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TreeSpeciesDAO {

    private Connection connection;

    public TreeSpeciesDAO() {
        try {
            connection = ConnectionBDD.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get all tree species
    public List<TreeSpecies> getAllTreeSpecies() {
        List<TreeSpecies> speciesList = new ArrayList<>();
        String sql = "SELECT * FROM tree_species ORDER BY scientific_name";

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                speciesList.add(extractTreeSpeciesFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return speciesList;
    }

    // Get tree species by ID
    public TreeSpecies getTreeSpeciesById(int speciesId) {
        String sql = "SELECT * FROM tree_species WHERE species_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, speciesId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractTreeSpeciesFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Add new tree species
    public boolean addTreeSpecies(TreeSpecies species) {
        String sql = "INSERT INTO tree_species (scientific_name, common_name, family, "
                + "average_lifespan, conservation_status) VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, species.getScientificName());
            stmt.setString(2, species.getCommonName());
            stmt.setString(3, species.getFamily());

            if (species.getAverageLifespan() != null) {
                stmt.setInt(4, species.getAverageLifespan());
            } else {
                stmt.setNull(4, Types.INTEGER);
            }

            stmt.setString(5, species.getConservationStatus());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                return false;
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    species.setSpeciesId(generatedKeys.getInt(1));
                }
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update tree species
    public boolean updateTreeSpecies(TreeSpecies species) {
        String sql = "UPDATE tree_species SET scientific_name = ?, common_name = ?, "
                + "family = ?, average_lifespan = ?, conservation_status = ? "
                + "WHERE species_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, species.getScientificName());
            stmt.setString(2, species.getCommonName());
            stmt.setString(3, species.getFamily());

            if (species.getAverageLifespan() != null) {
                stmt.setInt(4, species.getAverageLifespan());
            } else {
                stmt.setNull(4, Types.INTEGER);
            }

            stmt.setString(5, species.getConservationStatus());
            stmt.setInt(6, species.getSpeciesId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete tree species
    public boolean deleteTreeSpecies(int speciesId) {
        String sql = "DELETE FROM tree_species WHERE species_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, speciesId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Search tree species by name
    public List<TreeSpecies> searchTreeSpecies(String query) {
        List<TreeSpecies> speciesList = new ArrayList<>();
        String sql = "SELECT * FROM tree_species WHERE scientific_name LIKE ? OR common_name LIKE ? "
                + "ORDER BY scientific_name";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + query + "%");
            stmt.setString(2, "%" + query + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                speciesList.add(extractTreeSpeciesFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return speciesList;
    }

    // Helper method to extract TreeSpecies from ResultSet
    private TreeSpecies extractTreeSpeciesFromResultSet(ResultSet rs) throws SQLException {
        TreeSpecies species = new TreeSpecies();
        species.setSpeciesId(rs.getInt("species_id"));
        species.setScientificName(rs.getString("scientific_name"));
        species.setCommonName(rs.getString("common_name"));
        species.setFamily(rs.getString("family"));
        species.setAverageLifespan(rs.getInt("average_lifespan"));
        if (rs.wasNull()) {
            species.setAverageLifespan(null);
        }
        species.setConservationStatus(rs.getString("conservation_status"));
        species.setFirstRegistered(rs.getTimestamp("first_registered"));
        return species;
    }

    public int getTreeSpeciesCount() {
        String sql = "SELECT COUNT(*) FROM tree_species";
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getSpeciesAddedThisMonth() {
        String sql = "SELECT COUNT(*) FROM tree_species WHERE MONTH(first_registered) = MONTH(CURRENT_DATE()) "
                + "AND YEAR(first_registered) = YEAR(CURRENT_DATE())";
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<TreeSpecies> getSpeciesForReport(String family, String conservationStatus,
            Date startDate, Date endDate) {
        List<TreeSpecies> speciesList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM tree_species WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (family != null && !family.isEmpty()) {
            sql.append(" AND family = ?");
            params.add(family);
        }

        if (conservationStatus != null && !conservationStatus.isEmpty()) {
            sql.append(" AND conservation_status = ?");
            params.add(conservationStatus);
        }

        if (startDate != null) {
            sql.append(" AND first_registered >= ?");
            params.add(new java.sql.Date(startDate.getTime()));
        }

        if (endDate != null) {
            sql.append(" AND first_registered <= ?");
            params.add(new java.sql.Date(endDate.getTime()));
        }

        sql.append(" ORDER BY scientific_name");

        try (PreparedStatement stmt = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                speciesList.add(extractTreeSpeciesFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return speciesList;
    }

}
