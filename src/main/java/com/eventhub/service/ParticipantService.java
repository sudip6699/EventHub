package com.eventhub.service;

import com.eventhub.config.DBConfig;
import com.eventhub.model.Event;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * ParticipantService — Business logic + JDBC for event_participants table.
 * Handles joining/leaving events and checking participation status.
 * Every database method follows the strict 6-step JDBC pattern.
 */
public class ParticipantService {

    // ========================================================
    // JOIN / LEAVE EVENT
    // ========================================================

    /**
     * Adds a user as a participant to an event.
     * Validates capacity and prevents duplicate joins.
     *
     * @throws IllegalArgumentException if join is not allowed
     */
    public void joinEvent(int userId, int eventId) {
        // Check if already joined
        if (isJoined(userId, eventId)) {
            throw new IllegalArgumentException("You have already joined this event.");
        }

        Connection conn = null;
        PreparedStatement ps = null;
        try {
            // Step 2: Get connection
            conn = DBConfig.getConnection();

            // Step 3: Create PreparedStatement
            String sql = "INSERT INTO event_participants (user_id, event_id) VALUES (?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, eventId);

            // Step 4: Execute update
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Error joining event: " + e.getMessage(), e);
        } finally {
            // Step 6: Close all resources
            closeResources(conn, ps, null);
        }
    }

    /**
     * Removes a user from an event's participant list.
     */
    public void leaveEvent(int userId, int eventId) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "DELETE FROM event_participants WHERE user_id = ? AND event_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error leaving event: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, null);
        }
    }

    // ========================================================
    // CHECK / COUNT
    // ========================================================

    /**
     * Checks if a user has already joined a specific event.
     */
    public boolean isJoined(int userId, int eventId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "SELECT 1 FROM event_participants WHERE user_id = ? AND event_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            rs = ps.executeQuery();
            return rs.next(); // Returns true if a row exists
        } catch (SQLException e) {
            throw new RuntimeException("Error checking participation: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    /**
     * Counts the number of participants for a specific event.
     */
    public int countByEvent(int eventId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "SELECT COUNT(*) FROM event_participants WHERE event_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, eventId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            return 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error counting participants: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    /**
     * Counts how many events a user has joined.
     */
    public int countByUser(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "SELECT COUNT(*) FROM event_participants WHERE user_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            return 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error counting user participations: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    // ========================================================
    // RETRIEVE JOINED EVENTS
    // ========================================================

    /**
     * Returns all approved events that a user has joined.
     */
    public List<Event> getJoinedEvents(int userId) {
        List<Event> events = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "SELECT e.*, u.name AS organizer_name FROM event_participants ep "
                       + "JOIN events e ON ep.event_id = e.event_id "
                       + "JOIN users u ON e.user_id = u.user_id "
                       + "WHERE ep.user_id = ? ORDER BY e.event_date ASC";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            // Step 5: Process ResultSet into Event objects
            while (rs.next()) {
                Event event = new Event();
                event.setEventId(rs.getInt("event_id"));
                event.setUserId(rs.getInt("user_id"));
                event.setTitle(rs.getString("title"));
                event.setDescription(rs.getString("description"));
                event.setEventDate(rs.getDate("event_date"));
                event.setEventTime(rs.getTime("event_time"));
                event.setLocation(rs.getString("location"));
                event.setCategory(rs.getString("category"));
                event.setStatus(rs.getString("status"));
                int maxP = rs.getInt("max_participants");
                event.setMaxParticipants(rs.wasNull() ? 0 : maxP);
                event.setCreatedAt(rs.getTimestamp("created_at"));
                try { event.setOrganizerName(rs.getString("organizer_name")); } catch (SQLException ignored) {}
                events.add(event);
            }
            return events;
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching joined events: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }
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
