package com.eventhub.config;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * CookieUtil — Centralised helper class for all cookie operations.
 * Handles creating, reading, and deleting cookies.
 * Used for "Remember Me" functionality and user preferences.
 */
public class CookieUtil {

    // --- Default cookie max age: 30 days in seconds ---
    private static final int DEFAULT_MAX_AGE = 30 * 24 * 60 * 60;

    /**
     * Adds a cookie to the response with the default max age (30 days).
     *
     * @param response the HTTP response to add the cookie to
     * @param name     the cookie name
     * @param value    the cookie value
     */
    public static void addCookie(HttpServletResponse response, String name, String value) {
        addCookie(response, name, value, DEFAULT_MAX_AGE);
    }

    /**
     * Adds a cookie to the response with a custom max age.
     *
     * @param response the HTTP response to add the cookie to
     * @param name     the cookie name
     * @param value    the cookie value
     * @param maxAge   the max age in seconds
     */
    public static void addCookie(HttpServletResponse response, String name, String value, int maxAge) {
        Cookie cookie = new Cookie(name, value);
        cookie.setMaxAge(maxAge);          // How long cookie lives
        cookie.setPath("/");               // Available across entire app
        cookie.setHttpOnly(true);          // Not accessible via JavaScript (security)
        response.addCookie(cookie);
    }

    /**
     * Retrieves a cookie value by name from the request.
     *
     * @param request the HTTP request containing cookies
     * @param name    the cookie name to look for
     * @return the cookie value, or null if not found
     */
    public static String getCookie(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (name.equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    /**
     * Deletes a cookie by setting its max age to 0.
     *
     * @param response the HTTP response
     * @param name     the cookie name to delete
     */
    public static void deleteCookie(HttpServletResponse response, String name) {
        Cookie cookie = new Cookie(name, "");
        cookie.setMaxAge(0);    // Immediately expires the cookie
        cookie.setPath("/");    // Must match the path used when creating
        response.addCookie(cookie);
    }
}
