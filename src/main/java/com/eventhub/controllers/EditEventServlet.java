package com.eventhub.controllers;

import com.eventhub.model.Event;
import com.eventhub.service.EventService;
import com.eventhub.util.EventHubException;
import com.eventhub.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.SimpleDateFormat;

@WebServlet("/events/edit")
public class EditEventServlet extends HttpServlet {

    private final EventService eventService = new EventService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = SessionUtil.getUserId(req);
        String idParam = req.getParameter("id");
        if (idParam == null) { resp.sendRedirect(req.getContextPath() + "/events/my"); return; }
        try {
            Event event = eventService.getEventById(Integer.parseInt(idParam));
            if (event == null || event.getHostId() != userId) {
                resp.sendRedirect(req.getContextPath() + "/events/my"); return;
            }
            req.setAttribute("event", event);
            req.getRequestDispatcher("/WEB-INF/views/user/editevent.jsp").forward(req, resp);
        } catch (EventHubException e) {
            req.setAttribute("errorMsg", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/user/editevent.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = SessionUtil.getUserId(req);
        try {
            int eventId = Integer.parseInt(req.getParameter("eventId"));
            Event existing = eventService.getEventById(eventId);
            if (existing == null || existing.getHostId() != userId) {
                resp.sendRedirect(req.getContextPath() + "/events/my"); return;
            }
            existing.setTitle(req.getParameter("title"));
            existing.setDescription(req.getParameter("description"));
            existing.setCategory(req.getParameter("category"));
            existing.setLocation(req.getParameter("location"));
            existing.setMaxParticipants(Integer.parseInt(req.getParameter("maxParticipants")));
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            existing.setEventDate(sdf.parse(req.getParameter("eventDate")));
            eventService.updateEvent(existing);
            resp.sendRedirect(req.getContextPath() + "/events/my?success=updated");
        } catch (Exception e) {
            req.setAttribute("errorMsg", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/user/editevent.jsp").forward(req, resp);
        }
    }
}