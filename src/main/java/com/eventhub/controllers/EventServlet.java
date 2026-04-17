package com.eventhub.controllers;

import com.eventhub.model.Event;
import com.eventhub.service.EventService;
import com.eventhub.service.ParticipantService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * EventServlet — Handles browsing and searching approved events.
 * GET /events — Shows all approved events with search/filter.
 */
@WebServlet("/events")
public class EventServlet extends HttpServlet {

    private EventService eventService;
    private ParticipantService participantService;

    @Override
    public void init() throws ServletException {
        eventService = new EventService();
        participantService = new ParticipantService();
    }

    /**
     * GET /events — Display approved events, optionally filtered by search.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get search parameters from query string
        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");

        // Fetch events — search if parameters present, otherwise get all approved
        List<Event> events;
        if ((keyword != null && !keyword.trim().isEmpty()) || (category != null && !category.trim().isEmpty())) {
            events = eventService.searchEvents(keyword, category);
        } else {
            events = eventService.getApprovedEvents();
        }

        // Add participant count to each event
        for (Event event : events) {
            event.setParticipantCount(participantService.countByEvent(event.getEventId()));
        }

        // Check which events the current user has joined (if logged in)
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            int userId = (int) session.getAttribute("userId");
            for (Event event : events) {
                // We'll pass join status as a request attribute map
            }
        }

        // Set data for JSP
        request.setAttribute("events", events);
        request.setAttribute("keyword", keyword);
        request.setAttribute("category", category);

        // Forward to events browsing JSP
        request.getRequestDispatcher("/WEB-INF/views/user/events.jsp").forward(request, response);
    }
}
