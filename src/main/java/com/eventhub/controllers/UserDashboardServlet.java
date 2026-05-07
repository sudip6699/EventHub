package com.eventhub.controllers;

import com.eventhub.model.Event;
import com.eventhub.model.Participant;
import com.eventhub.model.User;
import com.eventhub.service.EventService;
import com.eventhub.service.ParticipantService;
import com.eventhub.service.UserService;
import com.eventhub.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/dashboard")
public class UserDashboardServlet extends HttpServlet {

    private final EventService       eventService       = new EventService();
    private final ParticipantService participantService = new ParticipantService();
    private final UserService        userService        = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId = SessionUtil.getUserId(req);

        // ---- Stat counters ----
        int totalApproved = 0, totalUsers = 0, joinedCount = 0, myEventCount = 0;
        try { totalApproved = eventService.countActiveEvents(); }       catch (Exception ignored) {}
        try { totalUsers    = userService.countAllUsers(); }            catch (Exception ignored) {}
        try { joinedCount   = participantService.countByUser(userId); } catch (Exception ignored) {}
        try { myEventCount  = eventService.countByHost(userId); }       catch (Exception ignored) {}

        req.setAttribute("totalApproved", totalApproved);
        req.setAttribute("totalUsers",    totalUsers);
        req.setAttribute("joinedCount",   joinedCount);
        req.setAttribute("myEventCount",  myEventCount);

        // ---- Recent approved events ----
        List<Event> recentEvents = new ArrayList<>();
        try { recentEvents = eventService.getRecentApproved(6); } catch (Exception ignored) {}
        req.setAttribute("recentEvents", recentEvents);

        // ---- Joined events (full Event list, not Participant) ----
        List<Event> joinedEvents = new ArrayList<>();
        try {
            List<Participant> parts = participantService.getParticipationsByUser(userId);
            for (Participant p : parts) {
                Event e = eventService.getEventById(p.getEventId());
                if (e != null) joinedEvents.add(e);
            }
        } catch (Exception ignored) {}
        req.setAttribute("joinedEvents", joinedEvents);

        // ---- My events (events the user hosts) ----
        List<Event> myEvents = new ArrayList<>();
        try { myEvents = eventService.getEventsByHost(userId); } catch (Exception ignored) {}
        req.setAttribute("myEvents", myEvents);

        // ---- Current user object ----
        User currentUser = null;
        try { currentUser = userService.getUserById(userId); } catch (Exception ignored) {}
        req.setAttribute("currentUser", currentUser);

        req.getRequestDispatcher("/WEB-INF/views/user/dashboard.jsp").forward(req, resp);
    }
}
