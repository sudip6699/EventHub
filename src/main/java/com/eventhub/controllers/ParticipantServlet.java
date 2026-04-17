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
 * ParticipantServlet — Handles joining and leaving events.
 * POST /participants/join — Join an event
 * POST /participants/leave — Leave an event
 */
@WebServlet("/participants/*")
public class ParticipantServlet extends HttpServlet {

    private ParticipantService participantService;
    private EventService eventService;

    @Override
    public void init() throws ServletException {
        participantService = new ParticipantService();
        eventService = new EventService();
    }

    /**
     * POST /participants/join or /participants/leave
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");

        String pathInfo = request.getPathInfo(); // "/join" or "/leave"
        String eventIdStr = request.getParameter("eventId");

        if (eventIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/events");
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event event = eventService.findById(eventId);

            if (event == null) {
                response.sendRedirect(request.getContextPath() + "/events");
                return;
            }

            if ("/join".equals(pathInfo)) {
                // --- Join Event ---
                // Check if event is approved
                if (!"approved".equals(event.getStatus())) {
                    response.sendRedirect(request.getContextPath() + "/events/detail?id=" + eventId + "&error=notapproved");
                    return;
                }
                // Check if user is the owner
                if (event.getUserId() == userId) {
                    response.sendRedirect(request.getContextPath() + "/events/detail?id=" + eventId + "&error=owner");
                    return;
                }
                // Check capacity
                if (event.getMaxParticipants() > 0) {
                    int currentCount = participantService.countByEvent(eventId);
                    if (currentCount >= event.getMaxParticipants()) {
                        response.sendRedirect(request.getContextPath() + "/events/detail?id=" + eventId + "&error=full");
                        return;
                    }
                }
                // Join the event
                participantService.joinEvent(userId, eventId);

            } else if ("/leave".equals(pathInfo)) {
                // --- Leave Event ---
                participantService.leaveEvent(userId, eventId);
            }

            // Redirect back to event detail page
            response.sendRedirect(request.getContextPath() + "/events/detail?id=" + eventId);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/events");
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/events?error=" + e.getMessage());
        }
    }
}

