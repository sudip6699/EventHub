package com.eventhub.controllers;

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

@WebServlet("/admin/events")
public class AdminEventServlet extends HttpServlet {

    private final EventService       eventService       = new EventService();
    private final UserService        userService        = new UserService();
    private final AdminActionService adminActionService = new AdminActionService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!SessionUtil.isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String status = req.getParameter("status");
        if (status == null) status = "";

        List<Event> events = new ArrayList<>();
        try {
            events = eventService.searchEvents(null, null, status.isEmpty() ? null : status);
        } catch (Exception ignored) {}

        // Resolve organiser names
        for (Event ev : events) {
            try {
                User host = userService.getUserById(ev.getHostId());
                if (host != null) ev.setOrganizerName(host.getName());
            } catch (Exception ignored) {}
        }

        int pendingCount = 0, approvedCount = 0, rejectedCount = 0;
        try { pendingCount  = eventService.searchEvents(null, null, "pending").size(); }  catch (Exception ignored) {}
        try { approvedCount = eventService.searchEvents(null, null, "approved").size(); } catch (Exception ignored) {}
        try { rejectedCount = eventService.searchEvents(null, null, "rejected").size(); } catch (Exception ignored) {}

        req.setAttribute("events",        events);
        req.setAttribute("statusFilter",  status);
        req.setAttribute("pendingCount",  pendingCount);
        req.setAttribute("approvedCount", approvedCount);
        req.setAttribute("rejectedCount", rejectedCount);
        req.getRequestDispatcher("/WEB-INF/views/admin/eventModeration.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!SessionUtil.isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        int adminId = SessionUtil.getUserId(req);
        String action = req.getParameter("action");
        int eventId;
        try { eventId = Integer.parseInt(req.getParameter("eventId")); }
        catch (Exception ex) { resp.sendRedirect(req.getContextPath() + "/admin/events"); return; }

        try {
            if ("approve".equals(action)) {
                eventService.approveEvent(eventId);
                adminActionService.logAction(adminId, "APPROVE_EVENT", eventId, "EVENT", "Approved event #" + eventId);
            } else if ("reject".equals(action)) {
                eventService.rejectEvent(eventId);
                adminActionService.logAction(adminId, "REJECT_EVENT", eventId, "EVENT", "Rejected event #" + eventId);
            } else if ("delete".equals(action)) {
                eventService.deleteEvent(eventId);
                adminActionService.logAction(adminId, "DELETE_EVENT", eventId, "EVENT", "Deleted event #" + eventId);
            }
        } catch (Exception ignored) {}

        String back = req.getParameter("returnStatus");
        resp.sendRedirect(req.getContextPath() + "/admin/events" + (back != null ? "?status=" + back : ""));
    }
}
