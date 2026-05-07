package com.eventhub.service;

import com.eventhub.dao.ParticipantDAO;
import com.eventhub.model.Event;
import com.eventhub.model.Participant;
import com.eventhub.util.EventHubException;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ParticipantService {

    private final ParticipantDAO participantDAO = new ParticipantDAO();

    public void joinEvent(int userId, int eventId) throws EventHubException {
        try {
            if (participantDAO.isJoined(userId, eventId))
                throw new EventHubException("You have already joined this event.");
            Participant p = new Participant();
            p.setUserId(userId);
            p.setEventId(eventId);
            p.setStatus("registered");
            participantDAO.insert(p);
        } catch (SQLException ex) {
            throw new EventHubException("Could not join event.", ex);
        }
    }

    // Alias used by ParticipantServlet
    public void leaveEvent(int userId, int eventId) throws EventHubException {
        cancelParticipation(userId, eventId);
    }

    public void cancelParticipation(int userId, int eventId) throws EventHubException {
        try { participantDAO.delete(userId, eventId); }
        catch (SQLException ex) { throw new EventHubException("Could not cancel.", ex); }
    }

    public List<Participant> getParticipationsByUser(int userId) throws EventHubException {
        try { return participantDAO.findByUser(userId); }
        catch (SQLException ex) { throw new EventHubException("Could not fetch your events.", ex); }
    }

    public List<Participant> getParticipantsByEvent(int eventId) throws EventHubException {
        try { return participantDAO.findByEvent(eventId); }
        catch (SQLException ex) { throw new EventHubException("Could not fetch participants.", ex); }
    }

    public boolean isJoined(int userId, int eventId) throws EventHubException {
        try { return participantDAO.isJoined(userId, eventId); }
        catch (SQLException ex) { throw new EventHubException("Could not check status.", ex); }
    }

    public int countByUser(int userId) throws EventHubException {
        try { return participantDAO.countByUser(userId); }
        catch (SQLException ex) { throw new EventHubException("Count failed.", ex); }
    }

    public int countByEvent(int eventId) throws EventHubException {
        try { return participantDAO.countByEvent(eventId); }
        catch (SQLException ex) { throw new EventHubException("Count failed.", ex); }
    }

    public Map<Integer, Boolean> buildJoinedMap(int userId, List<Event> events) {
        Map<Integer, Boolean> map = new HashMap<>();
        for (Event e : events) {
            try { map.put(e.getEventId(), participantDAO.isJoined(userId, e.getEventId())); }
            catch (SQLException ex) { map.put(e.getEventId(), false); }
        }
        return map;
    }
}