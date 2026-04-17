package com.eventhub.controllers;

import com.eventhub.model.Event;
import com.eventhub.service.EventService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * HomeServlet — Serves the public landing page.
 * Shows recent approved events to both guests and logged-in users.
 */
@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private EventService eventService;

    @Override
    public void init() throws ServletException {
        eventService = new EventService();
    }

    /**
     * GET /home — Display the public landing page with recent events.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fetch recent approved events for the landing page
        List<Event> recentEvents = eventService.getRecentApproved(6);
        request.setAttribute("recentEvents", recentEvents);

        // Count stats for display
        request.setAttribute("totalEvents", eventService.countAll());
        request.setAttribute("approvedEvents", eventService.countByStatus("approved"));

        // Forward to home JSP
        request.getRequestDispatcher("/WEB-INF/views/user/home.jsp").forward(request, response);
    }
}
