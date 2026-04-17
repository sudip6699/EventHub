package com.eventhub.controllers;

import com.eventhub.config.CookieUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * LogoutServlet — Invalidates the session and redirects to login page.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    /**
     * GET /logout — Log the user out.
     * Invalidates session, clears remember cookie, redirects to login.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Invalidate the HTTP session if it exists
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Redirect to login page with logout message
        response.sendRedirect(request.getContextPath() + "/login?success=loggedout");
    }
}
