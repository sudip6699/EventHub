package com.eventhub.controllers;

import com.eventhub.model.Event;
import com.eventhub.service.EventService;
import com.eventhub.service.ParticipantService;
import com.eventhub.util.EventHubException;
import com.eventhub.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/events")
public class EventServlet extends HttpServlet {

    private final EventService       eventService       = new EventService();
    private final ParticipantService participantService = new ParticipantService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword    = req.getParameter("q");
        String category   = req.getParameter("category");
        String dateFilter = req.getParameter("date");
        int    userId     = SessionUtil.getUserId(req);

        List<Event> events = new ArrayList<>();
        try {
            events = eventService.searchEvents(keyword, category, dateFilter);
            for (Event e : events) {
                e.setParticipantCount(participantService.countByEvent(e.getEventId()));
            }
        } catch (EventHubException ignored) {}

        Map<Integer, Boolean> joinedMap = participantService.buildJoinedMap(userId, events);

        req.setAttribute("events",           events);
        req.setAttribute("joinedMap",        joinedMap);
        req.setAttribute("keyword",          keyword);
        req.setAttribute("selectedCategory", category);
        req.getRequestDispatcher("/WEB-INF/views/user/events.jsp").forward(req, resp);
    }
}