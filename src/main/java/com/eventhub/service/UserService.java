package com.eventhub.service;

import com.eventhub.config.AESUtil;
import com.eventhub.config.DBConfig;
import com.eventhub.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * UserService — Business logic + JDBC operations for the users table.
 * Every database method follows the strict 6-step JDBC pattern:
 *   Step 1 → Class.forName (done in DBConfig static block)
 *   Step 2 → DriverManager.getConnection
 *   Step 3 → PreparedStatement
 *   Step 4 → executeQuery / executeUpdate
 *   Step 5 → Process ResultSet into Model objects
 *   Step 6 → Close all resources in finally block
 */
public class UserService {

    // --- Maximum failed login attempts before account lockout ---
    private static final int MAX_FAILED_ATTEMPTS = 5;
    private static final int LOCK_DURATION_MINUTES = 15;

    // ========================================================
    // REGISTRATION
    // ========================================================

    /**
     * Registers a new user with AES-encrypted password.
     * Validates input, checks for duplicate email, then inserts.
     *
     * @return the new user's ID
     * @throws IllegalArgumentException if validation fails
     */
    public int registerUser(String name, String email, String password, String confirmPassword) {
        // --- Input validation ---
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Full name is required.");
        }
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email is required.");
        }
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new IllegalArgumentException("Invalid email format.");
        }
        if (password == null || password.length() < 8) {
            throw new IllegalArgumentException("Password must be at least 8 characters.");
        }
        if (!password.equals(confirmPassword)) {
            throw new IllegalArgumentException("Passwords do not match.");
        }

        // --- Check for duplicate email ---
        if (findByEmail(email) != null) {
            throw new IllegalArgumentException("This email is already registered.");
        }

        // --- AES encrypt the password before storing ---
        String encryptedPassword = AESUtil.encrypt(password);

        // --- JDBC 6-step pattern: Insert new user ---
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            // Step 2: Get connection
            conn = DBConfig.getConnection();

            // Step 3: Create PreparedStatement
            String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, 'user')";
            ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, name.trim());
            ps.setString(2, email.trim().toLowerCase());
            ps.setString(3, encryptedPassword);

            // Step 4: Execute update
            ps.executeUpdate();

            // Step 5: Process result — get generated user ID
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return -1;

        } catch (SQLException e) {
            throw new RuntimeException("Error registering user: " + e.getMessage(), e);
        } finally {
            // Step 6: Close all resources
            closeResources(conn, ps, rs);
        }
    }

    // ========================================================
    // AUTHENTICATION
    // ========================================================

    /**
     * Authenticates a user by email and password.
     * Handles account lockout after 5 failed attempts.
     *
     * @return the authenticated User object
     * @throws IllegalArgumentException if authentication fails
     */
    public User authenticate(String email, String password) {
        // --- Validate input ---
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Email and password are required.");
        }

        // --- Find user by email ---
        User user = findByEmail(email.trim().toLowerCase());
        if (user == null) {
            throw new IllegalArgumentException("Invalid email or password.");
        }

        // --- Check if account is disabled ---
        if (user.getIsActive() == 0) {
            throw new IllegalArgumentException("Account is disabled. Contact support.");
        }

        // --- Check if account is locked ---
        if (user.isLocked()) {
            throw new IllegalArgumentException("Account is temporarily locked. Try again later.");
        }

        // --- Verify password using AES decryption ---
        if (!AESUtil.checkPassword(password, user.getPassword())) {
            // Increment failed attempts
            incrementFailedAttempts(user.getUserId());
            user = findById(user.getUserId()); // Refresh to get updated count

            // Lock account after MAX_FAILED_ATTEMPTS
            if (user.getFailedAttempts() >= MAX_FAILED_ATTEMPTS) {
                lockAccount(user.getUserId());
                throw new IllegalArgumentException("Account locked for " + LOCK_DURATION_MINUTES + " minutes due to too many failed attempts.");
            }
            throw new IllegalArgumentException("Invalid email or password.");
        }

        // --- Login successful — reset failed attempts ---
        resetFailedAttempts(user.getUserId());
        return user;
    }

    // ========================================================
    // FIND OPERATIONS
    // ========================================================

    /**
     * Finds a user by their ID.
     * JDBC 6-step pattern.
     */
    public User findById(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            // Step 2: Get connection
            conn = DBConfig.getConnection();

            // Step 3: Create PreparedStatement
            String sql = "SELECT * FROM users WHERE user_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            // Step 4: Execute query
            rs = ps.executeQuery();

            // Step 5: Process ResultSet into User object
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            return null;

        } catch (SQLException e) {
            throw new RuntimeException("Error finding user by ID: " + e.getMessage(), e);
        } finally {
            // Step 6: Close all resources
            closeResources(conn, ps, rs);
        }
    }

    /**
     * Finds a user by their email address.
     * JDBC 6-step pattern.
     */
    public User findByEmail(String email) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            // Step 2: Get connection
            conn = DBConfig.getConnection();

            // Step 3: Create PreparedStatement
            String sql = "SELECT * FROM users WHERE email = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);

            // Step 4: Execute query
            rs = ps.executeQuery();

            // Step 5: Process ResultSet
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            return null;

        } catch (SQLException e) {
            throw new RuntimeException("Error finding user by email: " + e.getMessage(), e);
        } finally {
            // Step 6: Close all resources
            closeResources(conn, ps, rs);
        }
    }

    /**
     * Retrieves all users from the database.
     * JDBC 6-step pattern.
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            // Step 2: Get connection
            conn = DBConfig.getConnection();

            // Step 3: Create PreparedStatement
            String sql = "SELECT * FROM users ORDER BY created_at DESC";
            ps = conn.prepareStatement(sql);

            // Step 4: Execute query
            rs = ps.executeQuery();

            // Step 5: Process ResultSet into list of User objects
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            return users;

        } catch (SQLException e) {
            throw new RuntimeException("Error fetching all users: " + e.getMessage(), e);
        } finally {
            // Step 6: Close all resources
            closeResources(conn, ps, rs);
        }
    }

    /**
     * Counts total number of users.
     */
    public int countAll() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "SELECT COUNT(*) FROM users";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error counting users: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    // ========================================================
    // UPDATE OPERATIONS
    // ========================================================

    /**
     * Updates a user's profile (name and email).
     * JDBC 6-step pattern.
     */
    public void updateProfile(int userId, String name, String email) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Name is required.");
        }
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email is required.");
        }

        // Check if email is used by another user
        User existingUser = findByEmail(email.trim().toLowerCase());
        if (existingUser != null && existingUser.getUserId() != userId) {
            throw new IllegalArgumentException("Email is already used by another account.");
        }

        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "UPDATE users SET name = ?, email = ? WHERE user_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, name.trim());
            ps.setString(2, email.trim().toLowerCase());
            ps.setInt(3, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating profile: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, null);
        }
    }

    /**
     * Changes a user's password.
     * Verifies current password, then encrypts and stores new one.
     */
    public void changePassword(int userId, String currentPassword, String newPassword, String confirmPassword) {
        if (currentPassword == null || newPassword == null || confirmPassword == null) {
            throw new IllegalArgumentException("All password fields are required.");
        }
        if (newPassword.length() < 8) {
            throw new IllegalArgumentException("New password must be at least 8 characters.");
        }
        if (!newPassword.equals(confirmPassword)) {
            throw new IllegalArgumentException("New passwords do not match.");
        }

        // Verify current password
        User user = findById(userId);
        if (user == null) {
            throw new IllegalArgumentException("User not found.");
        }
        if (!AESUtil.checkPassword(currentPassword, user.getPassword())) {
            throw new IllegalArgumentException("Current password is incorrect.");
        }

        // Encrypt and update new password
        String encryptedNew = AESUtil.encrypt(newPassword);
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "UPDATE users SET password = ? WHERE user_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, encryptedNew);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error changing password: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, null);
        }
    }

    // ========================================================
    // ADMIN OPERATIONS
    // ========================================================

    /**
     * Toggles a user's active status (enable/disable).
     */
    public void toggleActive(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "UPDATE users SET is_active = IF(is_active = 1, 0, 1) WHERE user_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error toggling active status: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, null);
        }
    }

    /**
     * Toggles a user's role between 'admin' and 'user'.
     */
    public void toggleRole(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "UPDATE users SET role = IF(role = 'admin', 'user', 'admin') WHERE user_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error toggling role: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, null);
        }
    }

    /**
     * Deletes a user by ID.
     */
    public void deleteUser(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "DELETE FROM users WHERE user_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting user: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, null);
        }
    }

    // ========================================================
    // ACCOUNT LOCKING HELPERS
    // ========================================================

    /** Increments failed login attempts for a user */
    private void incrementFailedAttempts(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "UPDATE users SET failed_attempts = failed_attempts + 1 WHERE user_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error incrementing failed attempts: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, null);
        }
    }

    /** Locks an account for LOCK_DURATION_MINUTES minutes */
    private void lockAccount(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "UPDATE users SET locked_until = DATE_ADD(NOW(), INTERVAL ? MINUTE), failed_attempts = 0 WHERE user_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, LOCK_DURATION_MINUTES);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error locking account: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, null);
        }
    }

    /** Resets failed attempts count and clears lock */
    private void resetFailedAttempts(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConfig.getConnection();
            String sql = "UPDATE users SET failed_attempts = 0, locked_until = NULL WHERE user_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error resetting failed attempts: " + e.getMessage(), e);
        } finally {
            closeResources(conn, ps, null);
        }
    }

    // ========================================================
    // HELPER METHODS
    // ========================================================

    /** Maps a ResultSet row to a User object (Step 5 of JDBC) */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setIsActive(rs.getInt("is_active"));
        user.setFailedAttempts(rs.getInt("failed_attempts"));
        user.setLockedUntil(rs.getTimestamp("locked_until"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }

    /** Closes JDBC resources safely (Step 6 of JDBC) */
    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { /* log silently */ }
        try { if (ps != null) ps.close(); } catch (SQLException e) { /* log silently */ }
        try { if (conn != null) conn.close(); } catch (SQLException e) { /* log silently */ }
    }
}
