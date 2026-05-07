package com.eventhub.controllers;

import com.eventhub.service.UserService;
import com.eventhub.util.EventHubException;
import com.eventhub.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!SessionUtil.isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/dashboard"); return;
        }
        try {
            req.setAttribute("users", userService.getAllUsers());
        } catch (Exception ignored) {}
        req.getRequestDispatcher("/WEB-INF/views/admin/userManagement.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!SessionUtil.isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/dashboard"); return;
        }
        String action = req.getParameter("action");
        int userId = Integer.parseInt(req.getParameter("userId"));
        try {
            if ("delete".equals(action)) {
                userService.deleteUser(userId);
                resp.sendRedirect(req.getContextPath() + "/admin/users?success=deleted");
            } else if ("lock".equals(action)) {
                userService.updateStatus(userId, "locked");
                resp.sendRedirect(req.getContextPath() + "/admin/users?success=locked");
            } else if ("unlock".equals(action)) {
                userService.updateStatus(userId, "active");
                resp.sendRedirect(req.getContextPath() + "/admin/users?success=unlocked");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/users");
            }
        } catch (EventHubException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + e.getMessage());
        }
    }
}