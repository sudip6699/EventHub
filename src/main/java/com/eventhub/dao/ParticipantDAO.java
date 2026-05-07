package com.eventhub.dao;

import com.eventhub.model.Participant;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ParticipantDAO extends BaseDAO {

    private Participant map(ResultSet rs) throws SQLException {
        Participant p = new Participant();
        p.setParticipantId(rs.getInt("participant_id"));
        p.setEventId(rs.getInt("event_id"));
        p.setUserId(rs.getInt("user_id"));
        p.setStatus(rs.getString("status"));
        p.setJoinedAt(rs.getTimestamp("joined_at"));
        return p;
    }

    public int insert(Participant p) throws SQLException {
        String sql = "INSERT INTO participants (event_id, user_id, status) VALUES (?,?,?)";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getEventId());
            ps.setInt(2, p.getUserId());
            ps.setString(3, p.getStatus() != null ? p.getStatus() : "registered");
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    public List<Participant> findByUser(int userId) throws SQLException {
        List<Participant> list = new ArrayList<>();
        String sql = "SELECT * FROM participants WHERE user_id=? ORDER BY joined_at DESC";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public List<Participant> findByEvent(int eventId) throws SQLException {
        List<Participant> list = new ArrayList<>();
        String sql = "SELECT * FROM participants WHERE event_id=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public boolean isJoined(int userId, int eventId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM participants WHERE user_id=? AND event_id=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public boolean delete(int userId, int eventId) throws SQLException {
        String sql = "DELETE FROM participants WHERE user_id=? AND event_id=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            return ps.executeUpdate() > 0;
        }
    }

    public int countByUser(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM participants WHERE user_id=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public int countByEvent(int eventId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM participants WHERE event_id=?";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
}