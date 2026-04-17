package com.eventhub.controllers;

import com.eventhub.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * RegisterServlet — Handles user registration (GET shows form, POST registers).
 * On success, redirects to login page with success message.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    /**
     * GET /register — Display the registration form.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    /**
     * POST /register — Process registration form.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        try {
            // Register user via service layer (validates + AES encrypts password)
            userService.registerUser(name, email, password, confirmPassword);

            // Success — redirect to login with success message
            response.sendRedirect(request.getContextPath() + "/login?success=registered");

        } catch (IllegalArgumentException e) {
            // Validation failed — show error on registration form
            request.setAttribute("errorMsg", e.getMessage());
            request.setAttribute("name", name);     // Retain entered name
            request.setAttribute("email", email);    // Retain entered email
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }
}
