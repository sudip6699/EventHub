package com.eventhub.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * ErrorServlet — Handles error pages (403, 404, 500).
 * Maps to /error/* URL pattern and forwards to appropriate error JSPs.
 */
@WebServlet("/error/*")
public class ErrorServlet extends HttpServlet {

    /**
     * GET /error/403, /error/404, /error/500 — Display error page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo(); // e.g. "/403"

        if ("/403".equals(pathInfo)) {
            request.getRequestDispatcher("/WEB-INF/views/error/403.jsp").forward(request, response);
        } else if ("/404".equals(pathInfo)) {
            request.getRequestDispatcher("/WEB-INF/views/error/404.jsp").forward(request, response);
        } else {
            // Default to 500 error page
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
}
