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

@WebServlet("/events/create")
public class CreateEventServlet extends HttpServlet {

    private final EventService eventService = new EventService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/user/createevent.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = SessionUtil.getUserId(req);
        try {
            Event e = new Event();
            e.setTitle(req.getParameter("title"));
            e.setDescription(req.getParameter("description"));
            e.setCategory(req.getParameter("category"));
            e.setLocation(req.getParameter("location"));
            e.setMaxParticipants(Integer.parseInt(req.getParameter("maxParticipants")));
            e.setHostId(userId);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            e.setEventDate(sdf.parse(req.getParameter("eventDate")));
            String timeParam = req.getParameter("eventTime");
            if (timeParam != null && !timeParam.isEmpty()) {
                SimpleDateFormat tdf = new SimpleDateFormat("HH:mm");
                e.setEventTime(tdf.parse(timeParam));
            }
            eventService.createEvent(e);
            resp.sendRedirect(req.getContextPath() + "/events/my?success=created");
        } catch (Exception ex) {
            req.setAttribute("error",    ex.getMessage());
            req.setAttribute("errorMsg", ex.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/user/createevent.jsp").forward(req, resp);
        }
    }
}