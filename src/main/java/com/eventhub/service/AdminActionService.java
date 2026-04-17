package com.eventhub.service;

import com.eventhub.config.DBConfig;
import com.eventhub.model.AdminAction;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 * AdminActionService — Business logic + JDBC for the admin_actions table.
 * Logs and retrieves administrative actions for audit trail.
 * Every database method follows the strict 6-step JDBC pattern.
 */
public class AdminActionService {

    // ========================================================
    // LOG ACTION
    // ========================================================

    /**
     * Records an admin action in the audit log.
     *
     * @param adminId    the admin performing the action
     * @param actionType type of action (e.g. "APPROVE_EVENT", "TOGGLE_ACTIVE")
     * @param targetId   the ID of the affected entity (user or event)
     * @param targetType the type of entity ("USER" or "EVENT")
     * @param notes      human-readable description of the action
     */
    public void logAction(int adminId, String actionType, int targetId, String targetType, String notes) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            // Step 2: Get connection
            conn = DBConfig.getConnection();

            // Step 3: Create PreparedStatement
            String sql = "INSERT INTO admin_actions (admin_id, action_type, target_id, target_type, notes) VALUES (?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, adminId);
            ps.setString(2, actionType);

            // Handle nullable target_id
            if (targetId > 0) {
                ps.setInt(3, targetId);
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            ps.setString(4, targetType);
            ps.setString(5, notes);

            // Step 4: Execute update
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Error logging admin action: " + e.getMessage(), e);
        } finally {
            // Step 6: Close all resources
            closeResources(conn, ps, null);
        }
    }

    // ========================================================
    // RETRIEVE ACTIONS
    // ========================================================

    /**
     * Retrieves the most recent admin actions, with admin name from users table.
     *
     * @param limit maximum number of records to return
     * @return list of AdminAction objects, most recent first
     */
    public List<AdminAction> getRecentActions(int limit) {
        List<AdminAction> actions = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            // Step 2: Get connection
            conn = DBConfig.getConnection();

            // Step 3: Create PreparedStatement (JOIN with users for admin name)
            String sql = "SELECT a.*, u.name AS admin_name FROM admin_actions a "
                       + "JOIN users u ON a.admin_id = u.user_id "
                       + "ORDER BY a.action_at DESC LIMIT ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);

            // Step 4: Execute query
            rs = ps.executeQuery();

            // Step 5: Process ResultSet into AdminAction objects
            while (rs.next()) {
                AdminAction action = new AdminAction();
                action.setActionId(rs.getInt("action_id"));
                action.setAdminId(rs.getInt("admin_id"));
                action.setActionType(rs.getString("action_type"));
                int targetId = rs.getInt("target_id");
                action.setTargetId(rs.wasNull() ? 0 : targetId);
                action.setTargetType(rs.getString("target_type"));
                action.setNotes(rs.getString("notes"));
                action.setActionAt(rs.getTimestamp("action_at"));
                action.setAdminName(rs.getString("admin_name"));
                actions.add(action);
            }
            return actions;

        } catch (SQLException e) {
            throw new RuntimeException("Error fetching admin actions: " + e.getMessage(), e);
        } finally {
            // Step 6: Close all resources
            closeResources(conn, ps, rs);
        }
    }

    /**
     * Retrieves all admin actions (no limit).
     */
    public List<AdminAction> getAllActions() {
        return getRecentActions(1000); // Practical limit
    }

    // ========================================================
    // HELPER METHODS
    // ========================================================

    /** Closes JDBC resources safely (Step 6 of JDBC) */
    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { /* log silently */ }
        try { if (ps != null) ps.close(); } catch (SQLException e) { /* log silently */ }
        try { if (conn != null) conn.close(); } catch (SQLException e) { /* log silently */ }
    }
}
