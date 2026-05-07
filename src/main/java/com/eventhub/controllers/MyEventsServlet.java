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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/events/my")
public class MyEventsServlet extends HttpServlet {

    private final EventService       eventService       = new EventService();
    private final ParticipantService participantService = new ParticipantService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = SessionUtil.getUserId(req);
        List<Event> myEvents = new ArrayList<>();
        try {
            myEvents = eventService.getEventsByHost(userId);
            for (Event e : myEvents) {
                e.setParticipantCount(participantService.countByEvent(e.getEventId()));
            }
        } catch (EventHubException ignored) {}
        req.setAttribute("myEvents", myEvents);
        req.getRequestDispatcher("/WEB-INF/views/user/myevent.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int    userId  = SessionUtil.getUserId(req);
        String action  = req.getParameter("action");
        int    eventId = Integer.parseInt(req.getParameter("eventId"));
        try {
            if ("delete".equals(action)) {
                Event e = eventService.getEventById(eventId);
                if (e != null && e.getHostId() == userId) eventService.deleteEvent(eventId);
            }
            resp.sendRedirect(req.getContextPath() + "/events/my");
        } catch (EventHubException ex) {
            resp.sendRedirect(req.getContextPath() + "/events/my?error=" + ex.getMessage());
        }
    }
}