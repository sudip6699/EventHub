package com.eventhub.controllers;

import com.eventhub.config.CookieUtil;
import com.eventhub.model.User;
import com.eventhub.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * LoginServlet — Handles user login (GET shows form, POST authenticates).
 * On successful login, creates session with userId, userName, userRole.
 * Redirects admin to /admin/dashboard and users to /dashboard.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        // Initialise service layer
        userService = new UserService();
    }

    /**
     * GET /login — Display the login form.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if "Remember Me" cookie exists and pre-fill email
        String savedEmail = CookieUtil.getCookie(request, "rememberEmail");
        if (savedEmail != null) {
            request.setAttribute("savedEmail", savedEmail);
        }

        // Forward to login JSP inside WEB-INF/views
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    /**
     * POST /login — Authenticate user and create session.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        try {
            // Authenticate user via service layer
            User user = userService.authenticate(email, password);

            // Create HTTP session with user attributes
            HttpSession session = request.getSession(true);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userRole", user.getRole());

            // Handle "Remember Me" cookie
            if ("on".equals(remember)) {
                CookieUtil.addCookie(response, "rememberEmail", email);
            } else {
                CookieUtil.deleteCookie(response, "rememberEmail");
            }

            // Role-based redirect: admin → admin dashboard, user → user dashboard
            if ("admin".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }

        } catch (IllegalArgumentException e) {
            // Authentication failed — show error on login form
            request.setAttribute("errorMsg", e.getMessage());
            request.setAttribute("email", email); // Retain entered email
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }
}
