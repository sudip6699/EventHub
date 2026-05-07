package com.eventhub.model;

import java.io.Serializable;
import java.util.Date;

public class Participant implements Serializable {
    private static final long serialVersionUID = 1L;

    private int    participantId;
    private int    eventId;
    private int    userId;
    private String status;
    private Date   joinedAt;

    public Participant() {}

    public int    getParticipantId()                          { return participantId; }
    public void   setParticipantId(int participantId)         { this.participantId = participantId; }

    public int    getEventId()                                { return eventId; }
    public void   setEventId(int eventId)                     { this.eventId = eventId; }

    public int    getUserId()                                 { return userId; }
    public void   setUserId(int userId)                       { this.userId = userId; }

    public String getStatus()                                 { return status; }
    public void   setStatus(String status)                    { this.status = status; }

    public Date   getJoinedAt()                               { return joinedAt; }
    public void   setJoinedAt(Date joinedAt)                  { this.joinedAt = joinedAt; }

    @Override
    public String toString() {
        return "Participant{participantId=" + participantId + ", eventId=" + eventId + ", userId=" + userId + "}";
    }
}