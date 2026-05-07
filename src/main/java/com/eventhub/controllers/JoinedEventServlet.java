package com.eventhub.controllers;

import com.eventhub.model.Event;
import com.eventhub.model.Participant;
import com.eventhub.service.EventService;
import com.eventhub.service.ParticipantService;
import com.eventhub.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/events/joined")
public class JoinedEventServlet extends HttpServlet {

    private final EventService eventService           = new EventService();
    private final ParticipantService participantService = new ParticipantService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId = SessionUtil.getUserId(req);
        List<Event> joinedEvents = new ArrayList<>();

        try {
            List<Participant> participations = participantService.getParticipationsByUser(userId);
            for (Participant p : participations) {
                Event e = eventService.getEventById(p.getEventId());
                if (e != null) joinedEvents.add(e);
            }
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Could not load your tickets.");
        }

        req.setAttribute("joinedEvents", joinedEvents);
        req.getRequestDispatcher("/WEB-INF/views/user/joinedevents.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        int userId    = SessionUtil.getUserId(req);

        if ("cancel".equals(action)) {
            try {
                int eventId = Integer.parseInt(req.getParameter("eventId"));
                participantService.cancelParticipation(userId, eventId);
                resp.sendRedirect(req.getContextPath() + "/events/joined?success=cancelled");
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/events/joined?error=cancelFailed");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/events/joined");
        }
    }
}