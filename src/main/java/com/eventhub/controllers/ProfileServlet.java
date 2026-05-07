package com.eventhub.controllers;

import com.eventhub.model.User;
import com.eventhub.service.EventService;
import com.eventhub.service.ParticipantService;
import com.eventhub.service.UserService;
import com.eventhub.util.EventHubException;
import com.eventhub.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private final UserService        userService        = new UserService();
    private final EventService       eventService       = new EventService();
    private final ParticipantService participantService = new ParticipantService();

    private void loadProfileAttributes(HttpServletRequest req, int userId) {
        try { req.setAttribute("user", userService.getUserById(userId)); } catch (Exception ignored) {}
        try { req.setAttribute("myEventCount", eventService.countByHost(userId)); } catch (Exception ignored) {}
        try { req.setAttribute("joinedCount", participantService.countByUser(userId)); } catch (Exception ignored) {}
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = SessionUtil.getUserId(req);
        loadProfileAttributes(req, userId);

        // Surface success codes via query param so a redirect can carry them across
        String success = req.getParameter("success");
        if ("updated".equals(success))           req.setAttribute("successMsg", "Profile updated successfully.");
        else if ("passwordChanged".equals(success)) req.setAttribute("successMsg", "Password changed successfully.");

        req.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int    userId = SessionUtil.getUserId(req);
        String action = req.getParameter("action");
        try {
            if ("updateProfile".equals(action)) {
                User u = userService.getUserById(userId);
                u.setName(req.getParameter("name"));
                u.setPhone(req.getParameter("phone"));
                u.setBio(req.getParameter("bio"));
                userService.updateProfile(u);
                resp.sendRedirect(req.getContextPath() + "/profile?success=updated");
            } else if ("changePassword".equals(action)) {
                // The form posts "currentPassword" — accept either name for safety.
                String oldPw  = req.getParameter("currentPassword");
                if (oldPw == null) oldPw = req.getParameter("oldPassword");
                String newPw  = req.getParameter("newPassword");
                String confirmPw = req.getParameter("confirmPassword");
                if (newPw != null && confirmPw != null && !newPw.equals(confirmPw))
                    throw new EventHubException("New password and confirmation do not match.");
                userService.changePassword(userId, oldPw, newPw);
                resp.sendRedirect(req.getContextPath() + "/profile?success=passwordChanged");
            } else {
                resp.sendRedirect(req.getContextPath() + "/profile");
            }
        } catch (EventHubException e) {
            loadProfileAttributes(req, userId);
            req.setAttribute("errorMsg", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(req, resp);
        }
    }
}
