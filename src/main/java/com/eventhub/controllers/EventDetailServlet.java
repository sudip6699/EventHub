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

/**
 * EventDetailServlet — Shows detailed information about a single event.
 * GET /events/detail?id=X — Display event detail page.
 */
@WebServlet("/events/detail")
public class EventDetailServlet extends HttpServlet {

    private EventService eventService;
    private ParticipantService participantService;

    @Override
    public void init() throws ServletException {
        eventService = new EventService();
        participantService = new ParticipantService();
    }

    /**
     * GET /events/detail?id=X — Display event details.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Parse event ID from query parameter
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/events");
            return;
        }

        try {
            int eventId = Integer.parseInt(idParam);

            // Fetch event from service
            Event event = eventService.findById(eventId);
            if (event == null) {
                response.sendRedirect(request.getContextPath() + "/error/404");
                return;
            }

            // Get participant count for this event
            int participantCount = participantService.countByEvent(eventId);
            event.setParticipantCount(participantCount);

            // Check if current user has joined this event
            HttpSession session = request.getSession(false);
            boolean isJoined = false;
            boolean isOwner = false;
            if (session != null && session.getAttribute("userId") != null) {
                int userId = (int) session.getAttribute("userId");
                isJoined = participantService.isJoined(userId, eventId);
                isOwner = (event.getUserId() == userId);
            }

            // Set attributes for JSP
            request.setAttribute("event", event);
            request.setAttribute("participantCount", participantCount);
            request.setAttribute("isJoined", isJoined);
            request.setAttribute("isOwner", isOwner);

            // Forward to event detail JSP
            request.getRequestDispatcher("/WEB-INF/views/user/eventDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/events");
        }
    }
}
