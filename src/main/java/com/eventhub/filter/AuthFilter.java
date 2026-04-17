package com.eventhub.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * AuthFilter — Servlet Filter that protects all authenticated routes.
 * Checks if a valid session exists with a userId attribute.
 * If no session found, redirects to the login page.
 *
 * URL patterns protected:
 *   /dashboard/* — user dashboard routes
 *   /events/create, /events/edit, /events/delete, /events/my
 *   /events/joined — joined events page
 *   /participants/* — join/leave event
 *   /profile/* — user profile
 *   /admin/* — admin routes (also checked by AdminFilter)
 */
@WebFilter({"/dashboard/*", "/events/create", "/events/edit", "/events/delete",
            "/events/my", "/events/joined", "/participants/*", "/profile/*", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialisation needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        // Cast to HTTP-specific types
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Check if a valid session exists with userId
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("userId") != null);

        if (!isLoggedIn) {
            // No valid session — redirect to login with error parameter
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?error=auth");
            return;
        }

        // User is authenticated — continue the filter chain
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }
}
