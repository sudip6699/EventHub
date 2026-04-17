package com.eventhub.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Participant JavaBean — maps to the 'event_participants' table.
 * Represents a user joining an event.
 */
public class Participant implements Serializable {

    // --- Fields matching database columns ---
    private int id;
    private int userId;       // FK → users(user_id)
    private int eventId;      // FK → events(event_id)
    private Timestamp joinedAt;

    // --- No-arg constructor (required for JavaBean) ---
    public Participant() {}

    // --- Getters and Setters ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getEventId() {
        return eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    public Timestamp getJoinedAt() {
        return joinedAt;
    }

    public void setJoinedAt(Timestamp joinedAt) {
        this.joinedAt = joinedAt;
    }
}
