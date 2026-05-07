package com.eventhub.service;

import com.eventhub.dao.EventDAO;
import com.eventhub.model.Event;
import com.eventhub.util.EventHubException;
import com.eventhub.util.ValidationUtil;

import java.sql.SQLException;
import java.util.List;

public class EventService {

    private final EventDAO eventDAO = new EventDAO();

    public int createEvent(Event e) throws EventHubException {
        if (ValidationUtil.isNullOrEmpty(e.getTitle()))
            throw new EventHubException("Event title is required.");
        if (e.getEventDate() == null)
            throw new EventHubException("Event date is required.");
        if (ValidationUtil.isNullOrEmpty(e.getLocation()))
            throw new EventHubException("Location is required.");
        if (e.getMaxParticipants() < 1)
            throw new EventHubException("Max participants must be at least 1.");
        try {
            e.setStatus("pending");
            return eventDAO.insert(e);
        } catch (SQLException ex) {
            throw new EventHubException("Could not create event: " + ex.getMessage(), ex);
        }
    }

    public Event getEventById(int eventId) throws EventHubException {
        try { return eventDAO.findById(eventId); }
        catch (SQLException ex) { throw new EventHubException("Could not fetch event.", ex); }
    }

    public List<Event> getAllEvents() throws EventHubException {
        try { return eventDAO.findAll(); }
        catch (SQLException ex) { throw new EventHubException("Could not fetch events.", ex); }
    }

    // 3-param version used by EventServlet (keyword, category, dateFilter)
    public List<Event> searchEvents(String keyword, String category, String dateFilter)
            throws EventHubException {
        try { return eventDAO.search(keyword, category, null); }
        catch (SQLException ex) { throw new EventHubException("Search failed.", ex); }
    }

    // 2-param shortcut
    public List<Event> searchEvents(String keyword, String category) throws EventHubException {
        return searchEvents(keyword, category, null);
    }

    public List<Event> getRecentApproved(int limit) throws EventHubException {
        try { return eventDAO.findRecentApproved(limit); }
        catch (SQLException ex) { throw new EventHubException("Could not fetch recent events.", ex); }
    }

    public List<Event> getEventsByHost(int hostId) throws EventHubException {
        try { return eventDAO.findByHost(hostId); }
        catch (SQLException ex) { throw new EventHubException("Could not fetch your events.", ex); }
    }

    public int countActiveEvents() throws EventHubException {
        try { return eventDAO.countActive(); }
        catch (SQLException ex) { throw new EventHubException("Count failed.", ex); }
    }

    public int countByHost(int hostId) throws EventHubException {
        try { return eventDAO.countByHost(hostId); }
        catch (SQLException ex) { throw new EventHubException("Count failed.", ex); }
    }

    public int countAllEvents() throws EventHubException {
        try { return eventDAO.countAll(); }
        catch (SQLException ex) { throw new EventHubException("Count failed.", ex); }
    }

    public boolean updateEvent(Event e) throws EventHubException {
        if (ValidationUtil.isNullOrEmpty(e.getTitle()))
            throw new EventHubException("Event title is required.");
        try { return eventDAO.update(e); }
        catch (SQLException ex) { throw new EventHubException("Could not update event.", ex); }
    }

    public boolean approveEvent(int eventId) throws EventHubException {
        try { return eventDAO.updateStatus(eventId, "approved"); }
        catch (SQLException ex) { throw new EventHubException("Could not approve event.", ex); }
    }

    public boolean rejectEvent(int eventId) throws EventHubException {
        try { return eventDAO.updateStatus(eventId, "rejected"); }
        catch (SQLException ex) { throw new EventHubException("Could not reject event.", ex); }
    }

    public boolean deleteEvent(int eventId) throws EventHubException {
        try { return eventDAO.delete(eventId); }
        catch (SQLException ex) { throw new EventHubException("Could not delete event.", ex); }
    }
}