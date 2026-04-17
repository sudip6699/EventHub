package com.eventhub.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * ForgotPasswordServlet — Displays the forgot password page.
 * In a real application, this would send a reset email.
 * For this coursework, it just shows the form.
 */
@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    /**
     * GET /forgot-password — Display the forgot password form.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/forgotPassword.jsp").forward(request, response);
    }

    /**
     * POST /forgot-password — Process the forgot password request.
     * Shows a confirmation message (email sending is out of scope for this coursework).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        // In a real app, generate token + send email
        // For this coursework, just show confirmation
        request.setAttribute("successMsg", "If an account exists with this email, a reset link will be sent shortly.");
        request.setAttribute("email", email);
        request.getRequestDispatcher("/WEB-INF/views/auth/forgotPassword.jsp").forward(request, response);
    }
}
