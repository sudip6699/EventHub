package com.eventhub.controllers;

import com.eventhub.model.Event;
import com.eventhub.service.EventService;
import com.eventhub.service.ParticipantService;
import com.eventhub.util.EventHubException;
import com.eventhub.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/events/detail")
public class EventDetailServlet extends HttpServlet {

    private final EventService       eventService       = new EventService();
    private final ParticipantService participantService = new ParticipantService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId   = SessionUtil.getUserId(req);
        String idParam = req.getParameter("id");
        if (idParam == null) { resp.sendRedirect(req.getContextPath() + "/events"); return; }
        try {
            Event event = eventService.getEventById(Integer.parseInt(idParam));
            if (event == null) { resp.sendRedirect(req.getContextPath() + "/events"); return; }
            int participantCount = participantService.countByEvent(event.getEventId());
            event.setParticipantCount(participantCount);
            boolean isJoined = userId > 0 && participantService.isJoined(userId, event.getEventId());
            boolean isOwner  = userId > 0 && event.getHostId() == userId;
            req.setAttribute("event",            event);
            req.setAttribute("participantCount", participantCount);
            req.setAttribute("isJoined",         isJoined);
            req.setAttribute("isOwner",          isOwner);
            req.setAttribute("isFull",           participantCount >= event.getMaxParticipants());
            req.getRequestDispatcher("/WEB-INF/views/user/eventdetail.jsp").forward(req, resp);
        } catch (EventHubException e) {
            req.setAttribute("errorMsg", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/user/eventdetail.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = SessionUtil.getUserId(req);
        String action  = req.getParameter("action");
        int    eventId = Integer.parseInt(req.getParameter("eventId"));
        try {
            if ("join".equals(action)) {
                participantService.joinEvent(userId, eventId);
            } else if ("leave".equals(action)) {
                participantService.cancelParticipation(userId, eventId);
            }
            resp.sendRedirect(req.getContextPath() + "/events/detail?id=" + eventId);
        } catch (EventHubException e) {
            resp.sendRedirect(req.getContextPath() + "/events/detail?id=" + eventId + "&error=" + e.getMessage());
        }
    }
}