package com.eventhub.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class SessionUtil {

    public static int getUserId(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s == null) return -1;
        Object id = s.getAttribute("userId");
        return (id instanceof Integer) ? (Integer) id : -1;
    }

    public static String getUserRole(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s == null) return null;
        return (String) s.getAttribute("userRole");
    }

    public static String getUserName(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s == null) return null;
        return (String) s.getAttribute("userName");
    }

    public static boolean isLoggedIn(HttpServletRequest req) {
        return getUserId(req) > 0;
    }

    public static boolean isAdmin(HttpServletRequest req) {
        return "admin".equalsIgnoreCase(getUserRole(req));
    }

    public static void setUser(HttpServletRequest req, int userId, String name, String role) {
        HttpSession s = req.getSession(true);
        s.setAttribute("userId",   userId);
        s.setAttribute("userName", name);
        s.setAttribute("userRole", role);
    }

    public static void invalidate(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s != null) s.invalidate();
    }
}