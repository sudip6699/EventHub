package com.eventhub.controllers;

import com.eventhub.service.UserService;
import com.eventhub.util.EventHubException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String token = req.getParameter("token");
        if (token == null || token.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }
        req.setAttribute("token", token);
        req.getRequestDispatcher("/WEB-INF/views/auth/resetPassword.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String token       = req.getParameter("token");
        String newPassword = req.getParameter("newPassword");
        String confirm     = req.getParameter("confirmPassword");

        if (!newPassword.equals(confirm)) {
            req.setAttribute("token", token);
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("/WEB-INF/views/auth/resetPassword.jsp")
               .forward(req, resp);
            return;
        }
        try {
            userService.resetPassword(token, newPassword);
            resp.sendRedirect(req.getContextPath() + "/login?success=passwordReset");
        } catch (EventHubException e) {
            req.setAttribute("token", token);
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/auth/resetPassword.jsp")
               .forward(req, resp);
        }
    }
}