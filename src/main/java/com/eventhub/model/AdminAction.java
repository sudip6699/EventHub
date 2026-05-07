package com.eventhub.model;

import java.io.Serializable;
import java.util.Date;

public class AdminAction implements Serializable {
    private static final long serialVersionUID = 1L;

    private int    actionId;
    private int    adminId;
    private String adminName;
    private String actionType;
    private String targetType;
    private int    targetId;
    private String description;
    private String notes;
    private Date   createdAt;
    private Date   actionAt;

    public AdminAction() {}

    public int    getActionId()                             { return actionId; }
    public void   setActionId(int actionId)                 { this.actionId = actionId; }

    public int    getAdminId()                              { return adminId; }
    public void   setAdminId(int adminId)                   { this.adminId = adminId; }

    public String getAdminName()                            { return adminName; }
    public void   setAdminName(String adminName)            { this.adminName = adminName; }

    public String getActionType()                           { return actionType; }
    public void   setActionType(String actionType)          { this.actionType = actionType; }

    public String getTargetType()                           { return targetType; }
    public void   setTargetType(String targetType)          { this.targetType = targetType; }

    public int    getTargetId()                             { return targetId; }
    public void   setTargetId(int targetId)                 { this.targetId = targetId; }

    public String getDescription()                          { return description; }
    public void   setDescription(String description)        { this.description = description; }

    public String getNotes()                                { return notes; }
    public void   setNotes(String notes)                    { this.notes = notes; }

    public Date   getCreatedAt()                            { return createdAt; }
    public void   setCreatedAt(Date createdAt)              { this.createdAt = createdAt; }

    // actionAt alias — some servlets use setActionAt instead of setCreatedAt
    public Date   getActionAt()                             { return createdAt; }
    public void   setActionAt(Date actionAt)                { this.createdAt = actionAt; }

    @Override
    public String toString() {
        return "AdminAction{actionId=" + actionId + ", actionType='" + actionType + "'}";
    }
}