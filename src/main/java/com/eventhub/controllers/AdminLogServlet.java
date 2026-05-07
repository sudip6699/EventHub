package com.eventhub.controllers;

import com.eventhub.model.AdminAction;
import com.eventhub.service.AdminActionService;
import com.eventhub.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/logs")
public class AdminLogServlet extends HttpServlet {

    private final AdminActionService adminActionService = new AdminActionService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!SessionUtil.isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        List<AdminAction> actions = new ArrayList<>();
        try { actions = adminActionService.getAllActions(); } catch (Exception ignored) {}
        req.setAttribute("actions", actions);
        req.getRequestDispatcher("/WEB-INF/views/admin/actionLog.jsp").forward(req, resp);
    }
}
