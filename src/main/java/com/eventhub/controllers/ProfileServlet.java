package com.eventhub.controllers;

import com.eventhub.model.User;
import com.eventhub.service.UserService;
import com.eventhub.service.ParticipantService;
import com.eventhub.service.EventService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * ProfileServlet — Handles viewing and updating user profile.
 * GET /profile — Show profile page
 * POST /profile — Update name/email or change password
 */
@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private UserService userService;
    private ParticipantService participantService;
    private EventService eventService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
        participantService = new ParticipantService();
        eventService = new EventService();
    }

    /**
     * GET /profile — Display the user's profile page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");

        // Fetch user details
        User user = userService.findById(userId);
        request.setAttribute("user", user);

        // Fetch activity counts
        request.setAttribute("myEventCount", eventService.getByUser(userId).size());
        request.setAttribute("joinedCount", participantService.countByUser(userId));

        request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
    }

    /**
     * POST /profile — Update profile or change password.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");

        try {
            if ("updateProfile".equals(action)) {
                // --- Update name and email ---
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                userService.updateProfile(userId, name, email);

                // Update session attributes
                session.setAttribute("userName", name);

                request.setAttribute("successMsg", "Profile updated successfully.");

            } else if ("changePassword".equals(action)) {
                // --- Change password ---
                String currentPassword = request.getParameter("currentPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");
                userService.changePassword(userId, currentPassword, newPassword, confirmPassword);

                request.setAttribute("successMsg", "Password changed successfully.");
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMsg", e.getMessage());
        }

        // Re-fetch user data and forward
        User user = userService.findById(userId);
        request.setAttribute("user", user);
        request.setAttribute("myEventCount", eventService.getByUser(userId).size());
        request.setAttribute("joinedCount", participantService.countByUser(userId));
        request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
    }
}
