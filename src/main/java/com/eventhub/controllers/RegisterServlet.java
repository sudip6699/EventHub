package com.eventhub.controllers;

import com.eventhub.model.User;
import com.eventhub.service.UserService;
import com.eventhub.util.EventHubException;
import com.eventhub.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (SessionUtil.isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String name     = req.getParameter("name");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String phone    = req.getParameter("phone");
        try {
            User u = new User();
            u.setName(name);
            u.setEmail(email);
            u.setPassword(password);
            u.setPhone(phone);
            userService.register(u);
            resp.sendRedirect(req.getContextPath() + "/login?success=registered");
        } catch (EventHubException e) {
            req.setAttribute("errorMsg", e.getMessage());
            req.setAttribute("name",  name);
            req.setAttribute("email", email);
            req.setAttribute("phone", phone);
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
        }
    }
}