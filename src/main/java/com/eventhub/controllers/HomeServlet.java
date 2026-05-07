package com.eventhub.controllers;

import com.eventhub.model.Event;
import com.eventhub.service.EventService;
import com.eventhub.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private final EventService eventService = new EventService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // If already logged in, go straight to dashboard
        if (SessionUtil.isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        List<Event> featuredEvents = new ArrayList<>();
        try {
            featuredEvents = eventService.getRecentApproved(6);
        } catch (Exception ignored) {}

        req.setAttribute("featuredEvents", featuredEvents);
        req.getRequestDispatcher("/WEB-INF/views/user/home.jsp").forward(req, resp);
    }
}