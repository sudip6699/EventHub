package com.eventhub.controllers;

import com.eventhub.model.AdminAction;
import com.eventhub.model.Event;
import com.eventhub.model.User;
import com.eventhub.service.AdminActionService;
import com.eventhub.service.EventService;
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

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final EventService        eventService        = new EventService();
    private final UserService         userService         = new UserService();
    private final AdminActionService  adminActionService  = new AdminActionService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!SessionUtil.isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/dashboard"); return;
        }

        int totalEvents = 0, totalUsers = 0;
        int pendingEvents = 0, approvedEvents = 0, rejectedEvents = 0;
        try { totalEvents = eventService.countAllEvents(); } catch (Exception ignored) {}
        try { totalUsers  = userService.countAllUsers();  } catch (Exception ignored) {}

        List<Event> pendingList = new ArrayList<>();
        List<User>  recentUsers = new ArrayList<>();
        List<AdminAction> recentActions = new ArrayList<>();

        try {
            pendingList = eventService.searchEvents(null, null, "pending");
            pendingEvents = pendingList.size();
        } catch (Exception ignored) {}
        try {
            approvedEvents = eventService.searchEvents(null, null, "approved").size();
        } catch (Exception ignored) {}
        try {
            rejectedEvents = eventService.searchEvents(null, null, "rejected").size();
        } catch (Exception ignored) {}
        try { recentUsers   = userService.getAllUsers(); } catch (Exception ignored) {}
        try { recentActions = adminActionService.getRecentActions(10); } catch (Exception ignored) {}

        // Resolve organiser names so the JSP can show "by <name>"
        for (Event ev : pendingList) {
            try {
                User host = userService.getUserById(ev.getHostId());
                if (host != null) ev.setOrganizerName(host.getName());
            } catch (Exception ignored) {}
        }

        req.setAttribute("totalEvents",    totalEvents);
        req.setAttribute("totalUsers",     totalUsers);
        req.setAttribute("pendingEvents",  pendingEvents);
        req.setAttribute("approvedEvents", approvedEvents);
        req.setAttribute("rejectedEvents", rejectedEvents);
        req.setAttribute("pendingList",    pendingList);
        req.setAttribute("recentUsers",    recentUsers);
        req.setAttribute("recentActions",  recentActions);
        req.getRequestDispatcher("/WEB-INF/views/admin/admindashboard.jsp").forward(req, resp);
    }
}
