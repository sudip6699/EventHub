package com.eventhub.controllers;

import com.eventhub.service.ParticipantService;
import com.eventhub.util.EventHubException;
import com.eventhub.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Handles join/leave for an event. Accepts either:
 *   POST /participant            with action=join|leave  (legacy form)
 *   POST /participants/join      (path-based action)
 *   POST /participants/leave     (path-based action)
 */
@WebServlet({"/participant", "/participants/join", "/participants/leave"})
public class ParticipantServlet extends HttpServlet {

    private final ParticipantService participantService = new ParticipantService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int    userId  = SessionUtil.getUserId(req);
        if (userId <= 0) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        // Pick action from URL suffix first, fall back to form parameter
        String path = req.getServletPath();
        String action = req.getParameter("action");
        if (path != null) {
            if (path.endsWith("/join"))  action = "join";
            if (path.endsWith("/leave")) action = "leave";
        }

        int eventId;
        try { eventId = Integer.parseInt(req.getParameter("eventId")); }
        catch (Exception ex) { resp.sendRedirect(req.getContextPath() + "/events"); return; }

        String redirect = req.getContextPath() + "/events/detail?id=" + eventId;
        try {
            if ("join".equals(action)) {
                participantService.joinEvent(userId, eventId);
            } else if ("leave".equals(action)) {
                participantService.leaveEvent(userId, eventId);
            }
            resp.sendRedirect(redirect);
        } catch (EventHubException e) {
            resp.sendRedirect(redirect + "&error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}
