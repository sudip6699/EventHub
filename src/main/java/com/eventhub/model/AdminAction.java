package com.eventhub.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * AdminAction JavaBean — maps to the 'admin_actions' table.
 * Records every administrative action for audit trail.
 */
public class AdminAction implements Serializable {

    // --- Fields matching database columns ---
    private int actionId;
    private int adminId;          // FK → users(user_id) of admin performing action
    private String actionType;    // e.g. "APPROVE_EVENT", "REJECT_EVENT", "TOGGLE_ACTIVE"
    private int targetId;         // ID of affected entity
    private String targetType;    // "EVENT", "USER"
    private String notes;         // Human-readable description
    private Timestamp actionAt;   // When the action occurred

    // --- Extra display field (not stored directly) ---
    private String adminName;     // Joined from users table

    // --- No-arg constructor (required for JavaBean) ---
    public AdminAction() {}

    // --- Getters and Setters ---

    public int getActionId() {
        return actionId;
    }

    public void setActionId(int actionId) {
        this.actionId = actionId;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public int getTargetId() {
        return targetId;
    }

    public void setTargetId(int targetId) {
        this.targetId = targetId;
    }

    public String getTargetType() {
        return targetType;
    }

    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Timestamp getActionAt() {
        return actionAt;
    }

    public void setActionAt(Timestamp actionAt) {
        this.actionAt = actionAt;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }
}
