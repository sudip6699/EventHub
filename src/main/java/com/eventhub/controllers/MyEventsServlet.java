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
 * MyEventsServlet — Shows events created by the logged-in user.
 * Also handles event deletion via POST.
 */
@WebServlet("/events/my")
public class MyEventsServlet extends HttpServlet {

    private EventService eventService;
    private ParticipantService participantService;

    @Override
    public void init() throws ServletException {
        eventService = new EventService();
        participantService = new ParticipantService();
    }

    /**
     * GET /events/my — Display user's own events.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");

        // Fetch events created by this user
        List<Event> myEvents = eventService.getByUser(userId);

        // Add participant count to each event
        for (Event event : myEvents) {
            event.setParticipantCount(participantService.countByEvent(event.getEventId()));
        }

        request.setAttribute("myEvents", myEvents);
        request.getRequestDispatcher("/WEB-INF/views/user/myEvents.jsp").forward(request, response);
    }

    /**
     * POST /events/my — Handle event deletion.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");

        String action = request.getParameter("action");
        String eventIdStr = request.getParameter("eventId");

        if ("delete".equals(action) && eventIdStr != null) {
            try {
                int eventId = Integer.parseInt(eventIdStr);
                Event event = eventService.findById(eventId);

                // Verify ownership before deleting
                if (event != null && (event.getUserId() == userId || "admin".equals(userRole))) {
                    eventService.deleteEvent(eventId);
                }
            } catch (NumberFormatException e) {
                // Invalid ID — ignore
            }
        }

        response.sendRedirect(request.getContextPath() + "/events/my");
    }
}
