package com.eventhub.dao;

import com.eventhub.model.ContactMessage;
import com.eventhub.config.DBConfig;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ContactDAO {

    public boolean save(ContactMessage msg) {
        String sql = "INSERT INTO contact_messages (name, email, subject, message, submitted_at) "
                   + "VALUES (?, ?, ?, ?, NOW())";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, msg.getName());
            ps.setString(2, msg.getEmail());
            ps.setString(3, msg.getSubject());
            ps.setString(4, msg.getMessage());
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}