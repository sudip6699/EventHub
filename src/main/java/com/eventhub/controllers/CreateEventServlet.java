package com.eventhub.controllers;

import com.eventhub.model.Event;
import com.eventhub.service.EventService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;

/**
 * CreateEventServlet — Handles event creation (GET shows form, POST creates).
 * New events are automatically set to 'pending' status.
 */
@WebServlet("/events/create")
public class CreateEventServlet extends HttpServlet {

    private EventService eventService;

    @Override
    public void init() throws ServletException {
        eventService = new EventService();
    }

    /**
     * GET /events/create — Display the create event form.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/user/createEvent.jsp").forward(request, response);
    }

    /**
     * POST /events/create — Process the create event form.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get user ID from session
        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");

        // Get form parameters
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String eventDateStr = request.getParameter("eventDate");
        String eventTimeStr = request.getParameter("eventTime");
        String location = request.getParameter("location");
        String category = request.getParameter("category");
        String maxParticipantsStr = request.getParameter("maxParticipants");

        try {
            // Build Event object from form data
            Event event = new Event();
            event.setUserId(userId);
            event.setTitle(title);
            event.setDescription(description);

            // Parse date
            if (eventDateStr != null && !eventDateStr.trim().isEmpty()) {
                event.setEventDate(Date.valueOf(eventDateStr));
            }

            // Parse time (optional)
            if (eventTimeStr != null && !eventTimeStr.trim().isEmpty()) {
                event.setEventTime(Time.valueOf(eventTimeStr + ":00"));
            }

            event.setLocation(location);
            event.setCategory(category);

            // Parse max participants (optional)
            if (maxParticipantsStr != null && !maxParticipantsStr.trim().isEmpty()) {
                event.setMaxParticipants(Integer.parseInt(maxParticipantsStr));
            }

            // Create event via service (validates + sets status to pending)
            eventService.createEvent(event);

            // Success — redirect to my events page
            response.sendRedirect(request.getContextPath() + "/events/my?success=created");

        } catch (IllegalArgumentException e) {
            // Validation failed — show error on form
            request.setAttribute("errorMsg", e.getMessage());
            request.setAttribute("title", title);
            request.setAttribute("description", description);
            request.setAttribute("eventDate", eventDateStr);
            request.setAttribute("eventTime", eventTimeStr);
            request.setAttribute("location", location);
            request.setAttribute("category", category);
            request.setAttribute("maxParticipants", maxParticipantsStr);
            request.getRequestDispatcher("/WEB-INF/views/user/createEvent.jsp").forward(request, response);
        }
    }
}
