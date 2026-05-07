package com.eventhub.dao;

import com.eventhub.model.AdminAction;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminActionDAO extends BaseDAO {

    private AdminAction map(ResultSet rs) throws SQLException {
        AdminAction a = new AdminAction();
        a.setActionId(rs.getInt("action_id"));
        a.setAdminId(rs.getInt("admin_id"));
        a.setActionType(rs.getString("action_type"));
        a.setTargetType(rs.getString("target_type"));
        a.setTargetId(rs.getInt("target_id"));
        a.setNotes(rs.getString("notes"));
        a.setActionAt(rs.getTimestamp("action_at"));
        return a;
    }

    public int insert(AdminAction a) throws SQLException {
        String sql = "INSERT INTO admin_actions (admin_id, action_type, target_type, target_id, notes) VALUES (?,?,?,?,?)";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, a.getAdminId());
            ps.setString(2, a.getActionType());
            ps.setString(3, a.getTargetType());
            ps.setInt(4, a.getTargetId());
            ps.setString(5, a.getNotes());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    public List<AdminAction> findAll() throws SQLException {
        List<AdminAction> list = new ArrayList<>();
        String sql = "SELECT * FROM admin_actions ORDER BY action_at DESC";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public List<AdminAction> findByAdmin(int adminId) throws SQLException {
        List<AdminAction> list = new ArrayList<>();
        String sql = "SELECT * FROM admin_actions WHERE admin_id=? ORDER BY action_at DESC";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM admin_actions";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}
