package com.eventhub.service;

import com.eventhub.config.DBConfig;
import com.eventhub.model.Event;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 * EventService — Business logic + JDBC operations for the events table.
 * Every database method follows the strict 6-step JDBC pattern.
 */
public class EventService {

    // ========================================================
    // CREATE
    // ========================================================

    /**
     * Creates a new event with status 'pending' (requires admin approval).
     * Validates all required fields before inserting.
     *
     * @return the new event's ID
     * @throws IllegalArgumentException if validation fails
     */
    public int createEvent(Event event) {
        // --- Validate required fields ---
        if (event.getTitle() == null || event.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Event title is required.");
        }
        if (event.getDescription() == null || event.getDescription().trim().isEmpty()) {
            throw new IllegalArgumentException("Event description is required.");
        }
        if (event.getEventDate() == null) {
            throw new IllegalArgumentException("Event date is required.");
        }
        if (event.getLocation() == null || event.getLocation().trim().isEmpty()) {
            throw new IllegalArgumentException("Event location is required.");
        }
        if (event.getCategory() == null || event.getCategory().trim().isEmpty()) {
            throw new IllegalArgumentException("Event category is required.");
        }

        // --- Force status to pending for new events ---
        event.setStatus("pending");

        // --- JDBC 6-step pattern: Insert event ---
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            // Step 2: Get connection
            conn = DBConfig.getConnection();

            // Step 3: Create PreparedStatement
            String sql = "INSERT INTO events (user_id, title, description, event_date, event_time, location, category, status, max_participants) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, event.getUserId());
            ps.setString(2, event.getTitle().trim());
            ps.setString(3, event.getDescription().trim());
            ps.setDate(4, event.getEventDate());

            // Handle nullable event time
            if (event.getEventTime() != null) {
                ps.setTime(5, event.getEventTime());
            } else {
                ps.setNull(5, Types.TIME);
            }

            ps.setString(6, event.getLocation().trim());
            ps.setString(7, event.getCategory());
            ps.setString(8, "pending");

            // Handle nullable max participants
            if (event.getMaxParticipants() > 0) {
                ps.setInt(9, event.getMaxParticipants());
            } else {
                ps.setNull(9, Types.INTEGER);
            }

            // Step 4: Execute update
            ps.executeUpdate();

            // Step 5: Get generated event ID
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return -1;

        } catch (SQLException e) {
            throw new RuntimeException("Error creating event: " + e.getMessage(), e);
        } finally {
            // Step 6: Close all resources
            closeResources(conn, ps, rs);
        }
    }

    // ========================================================
    // READ OPERATIONS
    // ========================================================

    /**
     * Finds an event by its ID, joining with users table for organizer name.
     */
    public Event findById(int eventId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "SELECT e.*, u.name AS organizer_name FROM events e "
                       + "JOIN users u ON e.user_id = u.user_id WHERE e.event_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, eventId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToEvent(rs);
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException("Error finding event: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    /**
     * Returns all approved events, ordered by event date ascending.
     */
    public List<Event> getApprovedEvents() {
        String sql = "SELECT e.*, u.name AS organizer_name FROM events e "
                   + "JOIN users u ON e.user_id = u.user_id "
                   + "WHERE e.status = 'approved' ORDER BY e.event_date ASC";
        return fetchEventList(sql);
    }

    /**
     * Returns all events (for admin), ordered by creation date descending.
     */
    public List<Event> getAllEvents() {
        String sql = "SELECT e.*, u.name AS organizer_name FROM events e "
                   + "JOIN users u ON e.user_id = u.user_id ORDER BY e.created_at DESC";
        return fetchEventList(sql);
    }

    /**
     * Returns events by a specific status (pending, approved, rejected).
     */
    public List<Event> getByStatus(String status) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Event> events = new ArrayList<>();
        try {
            conn = DBConfig.getConnection();
            String sql = "SELECT e.*, u.name AS organizer_name FROM events e "
                       + "JOIN users u ON e.user_id = u.user_id "
                       + "WHERE e.status = ? ORDER BY e.created_at DESC";
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            rs = ps.executeQuery();
            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }
            return events;
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching events by status: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    /**
     * Returns all events created by a specific user.
     */
    public List<Event> getByUser(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Event> events = new ArrayList<>();
        try {
            conn = DBConfig.getConnection();
            String sql = "SELECT e.*, u.name AS organizer_name FROM events e "
                       + "JOIN users u ON e.user_id = u.user_id "
                       + "WHERE e.user_id = ? ORDER BY e.event_date ASC";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }
            return events;
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching user events: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    /**
     * Returns the most recent approved events (limited).
     */
    public List<Event> getRecentApproved(int limit) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Event> events = new ArrayList<>();
        try {
            conn = DBConfig.getConnection();
            String sql = "SELECT e.*, u.name AS organizer_name FROM events e "
                       + "JOIN users u ON e.user_id = u.user_id "
                       + "WHERE e.status = 'approved' ORDER BY e.created_at DESC LIMIT ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }
            return events;
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching recent events: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    /**
     * Searches approved events by keyword, category, and/or date.
     */
    public List<Event> searchEvents(String keyword, String category) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Event> events = new ArrayList<>();
        try {
            conn = DBConfig.getConnection();

            // Build dynamic query based on search criteria
            StringBuilder sql = new StringBuilder(
                "SELECT e.*, u.name AS organizer_name FROM events e "
              + "JOIN users u ON e.user_id = u.user_id WHERE e.status = 'approved'");

            List<Object> params = new ArrayList<>();

            // Add keyword filter (searches title, description, location)
            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append(" AND (e.title LIKE ? OR e.description LIKE ? OR e.location LIKE ?)");
                String like = "%" + keyword.trim() + "%";
                params.add(like);
                params.add(like);
                params.add(like);
            }

            // Add category filter
            if (category != null && !category.trim().isEmpty()) {
                sql.append(" AND e.category = ?");
                params.add(category.trim());
            }

            sql.append(" ORDER BY e.event_date ASC");

            ps = conn.prepareStatement(sql.toString());

            // Set parameters dynamically
            for (int i = 0; i < params.size(); i++) {
                ps.setString(i + 1, (String) params.get(i));
            }

            rs = ps.executeQuery();
            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }
            return events;
        } catch (SQLException e) {
            throw new RuntimeException("Error searching events: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    // ========================================================
    // COUNT OPERATIONS
    // ========================================================

    /** Counts events by status */
    public int countByStatus(String status) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "SELECT COUNT(*) FROM events WHERE status = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            return 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error counting events: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    /** Counts all events */
    public int countAll() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "SELECT COUNT(*) FROM events";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            return 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error counting events: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    // ========================================================
    // UPDATE OPERATIONS
    // ========================================================

    /**
     * Updates an existing event.
     * Only the event owner or an admin can update.
     */
    public void updateEvent(Event event) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "UPDATE events SET title=?, description=?, event_date=?, event_time=?, "
                       + "location=?, category=?, max_participants=?, status='pending' WHERE event_id=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, event.getTitle().trim());
            ps.setString(2, event.getDescription().trim());
            ps.setDate(3, event.getEventDate());
            if (event.getEventTime() != null) {
                ps.setTime(4, event.getEventTime());
            } else {
                ps.setNull(4, Types.TIME);
            }
            ps.setString(5, event.getLocation().trim());
            ps.setString(6, event.getCategory());
            if (event.getMaxParticipants() > 0) {
                ps.setInt(7, event.getMaxParticipants());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            ps.setInt(8, event.getEventId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating event: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, null);
        }
    }

    /**
     * Updates event status (approve/reject) — admin only.
     */
    public void updateStatus(int eventId, String status) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "UPDATE events SET status = ? WHERE event_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, eventId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating event status: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, null);
        }
    }

    // ========================================================
    // DELETE
    // ========================================================

    /**
     * Deletes an event by its ID.
     */
    public void deleteEvent(int eventId) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "DELETE FROM events WHERE event_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, eventId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting event: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, null);
        }
    }

    // ========================================================
    // HELPER METHODS
    // ========================================================

    /** Fetches a list of events using a simple SQL query (no parameters) */
    private List<Event> fetchEventList(String sql) {
        List<Event> events = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConfig.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }
            return events;
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching events: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    /** Maps a ResultSet row to an Event object (Step 5 of JDBC) */
    private Event mapResultSetToEvent(ResultSet rs) throws SQLException {
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

        // Handle nullable max_participants
        int maxP = rs.getInt("max_participants");
        event.setMaxParticipants(rs.wasNull() ? 0 : maxP);

        event.setCreatedAt(rs.getTimestamp("created_at"));

        // Try to read organizer name (from JOIN)
        try {
            event.setOrganizerName(rs.getString("organizer_name"));
        } catch (SQLException ignored) {
            // Column may not exist in all queries
        }
        return event;
    }

    /** Closes JDBC resources safely (Step 6 of JDBC) */
    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { /* log silently */ }
        try { if (ps != null) ps.close(); } catch (SQLException e) { /* log silently */ }
        try { if (conn != null) conn.close(); } catch (SQLException e) { /* log silently */ }
    }
}
