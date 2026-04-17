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
 * EditEventServlet — Handles event editing (GET shows pre-filled form, POST updates).
 * Only the event owner or an admin can edit an event.
 */
@WebServlet("/events/edit")
public class EditEventServlet extends HttpServlet {

    private EventService eventService;

    @Override
    public void init() throws ServletException {
        eventService = new EventService();
    }

    /**
     * GET /events/edit?id=X — Display the edit form pre-filled with event data.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/events/my");
            return;
        }

        try {
            int eventId = Integer.parseInt(idParam);
            Event event = eventService.findById(eventId);

            if (event == null) {
                response.sendRedirect(request.getContextPath() + "/error/404");
                return;
            }

            // Check ownership — only owner or admin can edit
            HttpSession session = request.getSession(false);
            int userId = (int) session.getAttribute("userId");
            String userRole = (String) session.getAttribute("userRole");
            if (event.getUserId() != userId && !"admin".equals(userRole)) {
                response.sendRedirect(request.getContextPath() + "/error/403");
                return;
            }

            // Set event for pre-filling form
            request.setAttribute("event", event);
            request.getRequestDispatcher("/WEB-INF/views/user/editEvent.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/events/my");
        }
    }

    /**
     * POST /events/edit — Process the edit form and update the event.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");

        // Get form parameters
        String eventIdStr = request.getParameter("eventId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String eventDateStr = request.getParameter("eventDate");
        String eventTimeStr = request.getParameter("eventTime");
        String location = request.getParameter("location");
        String category = request.getParameter("category");
        String maxParticipantsStr = request.getParameter("maxParticipants");

        try {
            int eventId = Integer.parseInt(eventIdStr);

            // Verify ownership
            Event existing = eventService.findById(eventId);
            if (existing == null) {
                response.sendRedirect(request.getContextPath() + "/error/404");
                return;
            }
            if (existing.getUserId() != userId && !"admin".equals(userRole)) {
                response.sendRedirect(request.getContextPath() + "/error/403");
                return;
            }

            // Build updated Event object
            Event event = new Event();
            event.setEventId(eventId);
            event.setUserId(existing.getUserId());
            event.setTitle(title);
            event.setDescription(description);

            if (eventDateStr != null && !eventDateStr.trim().isEmpty()) {
                event.setEventDate(Date.valueOf(eventDateStr));
            }
            if (eventTimeStr != null && !eventTimeStr.trim().isEmpty()) {
                event.setEventTime(Time.valueOf(eventTimeStr + ":00"));
            }

            event.setLocation(location);
            event.setCategory(category);

            if (maxParticipantsStr != null && !maxParticipantsStr.trim().isEmpty()) {
                event.setMaxParticipants(Integer.parseInt(maxParticipantsStr));
            }

            // Update event (resets status to pending)
            eventService.updateEvent(event);

            // Redirect to my events
            response.sendRedirect(request.getContextPath() + "/events/my?success=updated");

        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMsg", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/user/editEvent.jsp").forward(request, response);
        }
    }
}
