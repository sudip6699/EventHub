package com.eventhub.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

/**
 * Event JavaBean — maps to the 'events' table in eventhub database.
 * Follows JavaBean conventions: no-arg constructor + getters/setters.
 */
public class Event implements Serializable {

    // --- Fields matching database columns ---
    private int eventId;
    private int userId;                // FK → users(user_id)
    private String title;
    private String description;
    private Date eventDate;            // java.sql.Date for DATE column
    private Time eventTime;            // java.sql.Time for TIME column
    private String location;
    private String category;           // Workshop, Seminar, Meetup, Cultural, Sports, Other
    private String status;             // pending, approved, rejected
    private int maxParticipants;       // 0 means unlimited
    private Timestamp createdAt;

    // --- Extra fields for display (not in DB directly) ---
    private String organizerName;      // Joined from users table
    private int participantCount;      // Count from event_participants

    // --- No-arg constructor (required for JavaBean) ---
    public Event() {
        this.status = "pending";
        this.maxParticipants = 0;
    }

    // --- Getters and Setters ---

    public int getEventId() {
        return eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getEventDate() {
        return eventDate;
    }

    public void setEventDate(Date eventDate) {
        this.eventDate = eventDate;
    }

    public Time getEventTime() {
        return eventTime;
    }

    public void setEventTime(Time eventTime) {
        this.eventTime = eventTime;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getMaxParticipants() {
        return maxParticipants;
    }

    public void setMaxParticipants(int maxParticipants) {
        this.maxParticipants = maxParticipants;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getOrganizerName() {
        return organizerName;
    }

    public void setOrganizerName(String organizerName) {
        this.organizerName = organizerName;
    }

    public int getParticipantCount() {
        return participantCount;
    }

    public void setParticipantCount(int participantCount) {
        this.participantCount = participantCount;
    }

    // --- Helper Methods ---

    /**
     * Returns a short excerpt of the description (first 120 characters).
     */
    public String getExcerpt() {
        if (description == null) return "";
        return description.length() > 120 ? description.substring(0, 120) + "..." : description;
    }
}
