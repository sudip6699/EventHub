package com.eventhub.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConfig — Centralised JDBC connection factory.
 * Uses MySQL Connector/J 8 driver for MySQL database access.
 * All service classes call DBConfig.getConnection() to obtain a connection.
 */
public class DBConfig {

    // --- Database connection constants ---
    private static final String URL =
            "jdbc:mysql://localhost:3306/eventhub?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    // --- Step 1 of JDBC: Load the MySQL JDBC driver once at class-load time ---
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found. Add mysql-connector-j JAR to WEB-INF/lib.", e);
        }
    }

    /**
     * Step 2 of JDBC: Obtain a new database connection.
     * Callers MUST close this connection in a finally block.
     *
     * @return a live Connection to the eventhub database
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
