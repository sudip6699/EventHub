package com.eventhub.controllers;

import com.eventhub.service.UserService;
import com.eventhub.util.EmailUtil;
import com.eventhub.util.EventHubException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/forgotPassword.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        try {
            String token = userService.initiatePasswordReset(email);
            EmailUtil.sendPasswordReset(email, token, req.getContextPath());
            req.setAttribute("success", "Password reset link sent to " + email);
        } catch (EventHubException e) {
            req.setAttribute("success",
                "If an account exists with this email, a reset link will be sent.");
        } catch (Exception e) {
            req.setAttribute("error", "Could not send email. Please try again later.");
        }
        req.getRequestDispatcher("/WEB-INF/views/auth/forgotPassword.jsp")
           .forward(req, resp);
    }
}