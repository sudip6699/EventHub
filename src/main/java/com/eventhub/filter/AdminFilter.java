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
 * AdminFilter — Servlet Filter that protects all /admin/* routes.
 * Checks that the logged-in user has the 'admin' role.
 * Runs AFTER AuthFilter (which verifies login).
 * If not admin, redirects to the 403 error page.
 */
@WebFilter("/admin/*")
public class AdminFilter implements Filter {

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

        // Get session and check role (AuthFilter already verified login)
        HttpSession session = httpRequest.getSession(false);
        String userRole = (session != null) ? (String) session.getAttribute("userRole") : null;

        // Only allow users with 'admin' role
        if (!"admin".equals(userRole)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/error/403");
            return;
        }

        // User is admin — continue the filter chain
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }
}
