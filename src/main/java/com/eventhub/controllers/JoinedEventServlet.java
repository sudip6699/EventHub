package com.eventhub.controllers;

import com.eventhub.model.Event;
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
 * JoinedEventsServlet — Shows events the logged-in user has joined.
 */
@WebServlet("/events/joined")
public class JoinedEventServlet extends HttpServlet {

    private ParticipantService participantService;

    @Override
    public void init() throws ServletException {
        participantService = new ParticipantService();
    }

    /**
     * GET /events/joined — Display all events the user has joined.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");

        // Fetch all events this user has joined
        List<Event> joinedEvents = participantService.getJoinedEvents(userId);

        // Add participant count to each event
        for (Event event : joinedEvents) {
            event.setParticipantCount(participantService.countByEvent(event.getEventId()));
        }

        request.setAttribute("joinedEvents", joinedEvents);
        request.getRequestDispatcher("/WEB-INF/views/user/joinedEvents.jsp").forward(request, response);
    }
}
