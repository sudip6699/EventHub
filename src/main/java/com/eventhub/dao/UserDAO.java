package com.eventhub.dao;

import com.eventhub.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends BaseDAO {

    private User map(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setName(rs.getString("name"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getString("role"));
        u.setPhone(rs.getString("phone"));
        u.setBio(rs.getString("bio"));
        u.setStatus(rs.getString("status"));
        u.setFailedAttempts(rs.getInt("failed_attempts"));
        u.setResetToken(rs.getString("reset_token"));
        u.setResetExpiry(rs.getTimestamp("reset_expiry"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }

    public int insert(User u) throws SQLException {
        String sql = "INSERT INTO users (name, email, password, role, phone, bio, status) VALUES (?,?,?,?,?,?,?)";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, u.getName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getRole() != null ? u.getRole() : "user");
            ps.setString(5, u.getPhone());
            ps.setString(6, u.getBio());
            ps.setString(7, u.getStatus() != null ? u.getStatus() : "active");
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    public User findById(int userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public List<User> findAll() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public boolean update(User u) throws SQLException {
        String sql = "UPDATE users SET name=?, email=?, phone=?, bio=?, status=? WHERE user_id=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, u.getName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPhone());
            ps.setString(4, u.getBio());
            ps.setString(5, u.getStatus());
            ps.setInt(6, u.getUserId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updatePassword(int userId, String hashedPassword) throws SQLException {
        String sql = "UPDATE users SET password=?, reset_token=NULL, reset_expiry=NULL WHERE user_id=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateStatus(int userId, String status) throws SQLException {
        String sql = "UPDATE users SET status=? WHERE user_id=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean incrementFailedAttempts(int userId) throws SQLException {
        String sql = "UPDATE users SET failed_attempts = failed_attempts + 1 WHERE user_id=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean resetFailedAttempts(int userId) throws SQLException {
        String sql = "UPDATE users SET failed_attempts=0 WHERE user_id=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean saveResetToken(int userId, String token, Timestamp expiry) throws SQLException {
        String sql = "UPDATE users SET reset_token=?, reset_expiry=? WHERE user_id=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setTimestamp(2, expiry);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public User findByResetToken(String token) throws SQLException {
        String sql = "SELECT * FROM users WHERE reset_token=? AND reset_expiry > UTC_TIMESTAMP()";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE email=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public boolean delete(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }
}