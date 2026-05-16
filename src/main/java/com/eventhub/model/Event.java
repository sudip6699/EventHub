package com.eventhub.model;

import java.io.Serializable;
import java.util.Date;

public class Event implements Serializable {
    private static final long serialVersionUID = 1L;

    private int    eventId;
    private String title;
    private String description;
    private String category;
    private String location;
    private Date   eventDate;
    private Date   eventTime;
    private int    maxParticipants;
    private int    participantCount;
    private String status;
    private int    hostId;
    private String organizerName;
    private Date   createdAt;
    private String imagePath;
    private boolean isPaid;
    private double  ticketPrice;

    public Event() {}

    public int    getEventId()                              { return eventId; }
    public void   setEventId(int eventId)                   { this.eventId = eventId; }
    public int    getId()                                   { return eventId; }
    public void   setId(int id)                             { this.eventId = id; }

    public String getTitle()                                { return title; }
    public void   setTitle(String title)                    { this.title = title; }

    public String getDescription()                          { return description; }
    public void   setDescription(String description)        { this.description = description; }

    public String getCategory()                             { return category; }
    public void   setCategory(String category)              { this.category = category; }

    public String getLocation()                             { return location; }
    public void   setLocation(String location)              { this.location = location; }

    public Date   getEventDate()                            { return eventDate; }
    public void   setEventDate(Date eventDate)              { this.eventDate = eventDate; }

    public Date   getEventTime()                            { return eventTime; }
    public void   setEventTime(Date eventTime)              { this.eventTime = eventTime; }

    public int    getMaxParticipants()                          { return maxParticipants; }
    public void   setMaxParticipants(int maxParticipants)       { this.maxParticipants = maxParticipants; }

    public int    getParticipantCount()                         { return participantCount; }
    public void   setParticipantCount(int participantCount)     { this.participantCount = participantCount; }

    public String getStatus()                               { return status; }
    public void   setStatus(String status)                  { this.status = status; }

    public int    getHostId()                               { return hostId; }
    public void   setHostId(int hostId)                     { this.hostId = hostId; }
    public int    getUserId()                               { return hostId; }
    public void   setUserId(int userId)                     { this.hostId = userId; }

    public String getOrganizerName()                        { return organizerName; }
    public void   setOrganizerName(String organizerName)    { this.organizerName = organizerName; }

    public Date   getCreatedAt()                            { return createdAt; }
    public void   setCreatedAt(Date createdAt)              { this.createdAt = createdAt; }

    public String getImagePath()                            { return imagePath; }
    public void   setImagePath(String imagePath)            { this.imagePath = imagePath; }

    public boolean isPaid()                                 { return isPaid; }
    public void    setIsPaid(boolean isPaid)                { this.isPaid = isPaid; }
    public void    setPaid(boolean isPaid)                  { this.isPaid = isPaid; }

    public double  getTicketPrice()                         { return ticketPrice; }
    public void    setTicketPrice(double ticketPrice)       { this.ticketPrice = ticketPrice; }

    public String getExcerpt() {
        if (description == null || description.length() <= 120) return description;
        return description.substring(0, 120) + "...";
    }

    @Override
    public String toString() {
        return "Event{eventId=" + eventId + ", title='" + title + "', status='" + status + "'}";
    }
}