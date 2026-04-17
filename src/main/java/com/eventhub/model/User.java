package com.eventhub.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * User JavaBean — maps to the 'users' table in eventhub database.
 * Follows JavaBean conventions: no-arg constructor + getters/setters.
 * Used with <jsp:useBean>, <jsp:setProperty>, <jsp:getProperty>.
 */
public class User implements Serializable {

    // --- Fields matching database columns ---
    private int userId;
    private String name;
    private String email;
    private String password;          // AES-encrypted password
    private String role;              // "admin" or "user"
    private int isActive;             // 1 = active, 0 = disabled
    private int failedAttempts;       // Count of consecutive failed logins
    private Timestamp lockedUntil;    // Account lock expiry timestamp
    private Timestamp createdAt;      // Account creation timestamp

    // --- No-arg constructor (required for JavaBean) ---
    public User() {
        this.role = "user";
        this.isActive = 1;
        this.failedAttempts = 0;
    }

    // --- Getters and Setters ---

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public int getIsActive() {
        return isActive;
    }

    public void setIsActive(int isActive) {
        this.isActive = isActive;
    }

    public int getFailedAttempts() {
        return failedAttempts;
    }

    public void setFailedAttempts(int failedAttempts) {
        this.failedAttempts = failedAttempts;
    }

    public Timestamp getLockedUntil() {
        return lockedUntil;
    }

    public void setLockedUntil(Timestamp lockedUntil) {
        this.lockedUntil = lockedUntil;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // --- Helper Methods ---

    /**
     * Checks if the account is currently locked (lock window hasn't expired).
     */
    public boolean isLocked() {
        return lockedUntil != null && lockedUntil.after(new Timestamp(System.currentTimeMillis()));
    }

    /**
     * Checks if the user is an admin.
     */
    public boolean isAdmin() {
        return "admin".equals(role);
    }
}
