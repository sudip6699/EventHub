package com.eventhub.controllers;

import com.eventhub.model.Event;
import com.eventhub.service.EventService;
import com.eventhub.service.ParticipantService;
import com.eventhub.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * UserDashboardServlet — Serves the logged-in user's main dashboard.
 * Shows upcoming events, joined events count, and user stats.
 */
@WebServlet("/dashboard")
public class UserDashboardServlet extends HttpServlet {

    private EventService eventService;
    private ParticipantService participantService;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        eventService = new EventService();
        participantService = new ParticipantService();
        userService = new UserService();
    }

    /**
     * GET /dashboard — Display the user dashboard with stats and event lists.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get user ID from session
        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");

        // Fetch dashboard data
        List<Event> recentEvents = eventService.getRecentApproved(6);
        List<Event> myEvents = eventService.getByUser(userId);
        List<Event> joinedEvents = participantService.getJoinedEvents(userId);

        // Set attributes for JSP
        request.setAttribute("recentEvents", recentEvents);
        request.setAttribute("myEvents", myEvents);
        request.setAttribute("joinedEvents", joinedEvents);
        request.setAttribute("myEventCount", myEvents.size());
        request.setAttribute("joinedCount", joinedEvents.size());
        request.setAttribute("totalApproved", eventService.countByStatus("approved"));
        request.setAttribute("totalUsers", userService.countAll());

        // Forward to dashboard JSP
        request.getRequestDispatcher("/WEB-INF/views/user/dashboard.jsp").forward(request, response);
    }
}
