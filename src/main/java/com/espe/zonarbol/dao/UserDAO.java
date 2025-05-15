package com.espe.zonarbol.dao;

import java.sql.PreparedStatement;
import java.sql.Connection;
import com.espe.zonarbol.model.User;
import java.sql.ResultSet;

/**
 *
 * @author vier
 */
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public boolean save(User user) {
        String sql = "INSERT INTO users (name,lastname,age) VALUES (?,?,?)";
        try {
            Connection con = ConnectionBDD.getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getLast_name());
            stmt.setInt(3, user.getAge());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<User> findAll() {
        List<User> users = new ArrayList<>();

        String sql = "SELECT * FROM users;";

        try {
            Connection con = ConnectionBDD.getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getLong("id"));
                user.setName(rs.getString("name"));
                user.setLast_name(rs.getString("lastname"));
                user.setAge(rs.getInt("age"));
                users.add(user);
            }

        } catch (SQLException e) {

            e.printStackTrace();

        }
        return users;
    }

    public User findById(Long id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        User user = null;
        try {
            Connection con = ConnectionBDD.getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);

            stmt.setLong(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getLong("id"));
                    user.setName(rs.getString("name"));
                    user.setLast_name(rs.getString("lastname"));
                    user.setAge(rs.getInt("age"));

                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean update(User user) {
        String sql = "UPDATE users SET name = ?, lastname = ?, age = ? WHERE id = ?";
        try {
            Connection con = ConnectionBDD.getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getLast_name());
            stmt.setInt(3, user.getAge());
            stmt.setLong(4, user.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

    }

    public boolean delete(Long id) {
        String sql = "DELETE FROM users WHERE id = ?";
        try {
            Connection con = ConnectionBDD.getConnection();
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
