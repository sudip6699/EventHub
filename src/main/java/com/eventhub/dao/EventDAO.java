package com.eventhub.dao;

import com.eventhub.model.Event;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventDAO extends BaseDAO {

    private Event map(ResultSet rs) throws SQLException {
        Event e = new Event();
        e.setEventId(rs.getInt("event_id"));
        e.setTitle(rs.getString("title"));
        e.setDescription(rs.getString("description"));
        e.setCategory(rs.getString("category"));
        e.setLocation(rs.getString("location"));
        e.setEventDate(rs.getDate("event_date"));
        e.setEventTime(rs.getTime("event_time"));
        e.setMaxParticipants(rs.getInt("max_participants"));
        e.setStatus(rs.getString("status"));
        e.setHostId(rs.getInt("host_id"));
        e.setCreatedAt(rs.getTimestamp("created_at"));
        e.setImagePath(rs.getString("image_path"));
        e.setIsPaid(rs.getInt("is_paid") == 1);
        e.setTicketPrice(rs.getDouble("ticket_price"));
        return e;
    }

    public int insert(Event e) throws SQLException {
        String sql = "INSERT INTO events (title, description, category, location, " +
                     "event_date, event_time, max_participants, status, host_id, " +
                     "image_path, is_paid, ticket_price) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, e.getTitle());
            ps.setString(2, e.getDescription());
            ps.setString(3, e.getCategory());
            ps.setString(4, e.getLocation());
            ps.setDate(5, new java.sql.Date(e.getEventDate().getTime()));
            if (e.getEventTime() != null) {
                ps.setTime(6, new java.sql.Time(e.getEventTime().getTime()));
            } else {
                ps.setNull(6, java.sql.Types.TIME);
            }
            ps.setInt(7, e.getMaxParticipants());
            ps.setString(8, e.getStatus() != null ? e.getStatus() : "pending");
            ps.setInt(9, e.getHostId());
            ps.setString(10, e.getImagePath());
            ps.setInt(11, e.isPaid() ? 1 : 0);
            ps.setDouble(12, e.getTicketPrice());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    public List<Event> findAll() throws SQLException {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM events ORDER BY created_at DESC";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public Event findById(int eventId) throws SQLException {
        String sql = "SELECT * FROM events WHERE event_id = ?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public List<Event> findByHost(int hostId) throws SQLException {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM events WHERE host_id = ? ORDER BY created_at DESC";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, hostId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public List<Event> search(String keyword, String category, String status) throws SQLException {
        List<Event> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM events WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty())
            sql.append(" AND (title LIKE ? OR description LIKE ? OR location LIKE ?)");
        if (category != null && !category.trim().isEmpty())
            sql.append(" AND category = ?");
        if (status != null && !status.trim().isEmpty())
            sql.append(" AND status = ?");
        sql.append(" ORDER BY event_date ASC");

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim() + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }
            if (category != null && !category.trim().isEmpty()) ps.setString(idx++, category);
            if (status   != null && !status.trim().isEmpty())   ps.setString(idx++, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public List<Event> findRecentApproved(int limit) throws SQLException {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM events WHERE status = 'approved' " +
                     "ORDER BY created_at DESC LIMIT ?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public int countActive() throws SQLException {
        String sql = "SELECT COUNT(*) FROM events WHERE status = 'approved'";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int countByHost(int hostId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM events WHERE host_id = ?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, hostId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public boolean update(Event e) throws SQLException {
        String sql = "UPDATE events SET title=?, description=?, category=?, location=?, " +
                     "event_date=?, event_time=?, max_participants=?, status=?, image_path=?, " +
                     "is_paid=?, ticket_price=? WHERE event_id=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, e.getTitle());
            ps.setString(2, e.getDescription());
            ps.setString(3, e.getCategory());
            ps.setString(4, e.getLocation());
            ps.setDate(5, new java.sql.Date(e.getEventDate().getTime()));
            if (e.getEventTime() != null) {
                ps.setTime(6, new java.sql.Time(e.getEventTime().getTime()));
            } else {
                ps.setNull(6, java.sql.Types.TIME);
            }
            ps.setInt(7, e.getMaxParticipants());
            ps.setString(8, e.getStatus());
            ps.setString(9, e.getImagePath());
            ps.setInt(10, e.isPaid() ? 1 : 0);
            ps.setDouble(11, e.getTicketPrice());
            ps.setInt(12, e.getEventId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateStatus(int eventId, String status) throws SQLException {
        String sql = "UPDATE events SET status=? WHERE event_id=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, eventId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int eventId) throws SQLException {
        String sql = "DELETE FROM events WHERE event_id=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            return ps.executeUpdate() > 0;
        }
    }

    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM events";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}
