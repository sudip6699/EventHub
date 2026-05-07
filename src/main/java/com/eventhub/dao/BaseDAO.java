package com.eventhub.dao;

import com.eventhub.config.DBConfig;
import java.sql.Connection;
import java.sql.SQLException;

public abstract class BaseDAO {

    protected Connection getConnection() throws SQLException {
        return DBConfig.getConnection();
    }

    protected void closeQuietly(AutoCloseable... resources) {
        for (AutoCloseable r : resources) {
            if (r != null) {
                try { r.close(); } catch (Exception ignored) {}
            }
        }
    }
}