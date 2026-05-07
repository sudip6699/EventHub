package com.eventhub.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.eventhub.dao.ContactDAO;
import com.eventhub.model.ContactMessage;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ContactDAO contactDAO = new ContactDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/user/contact.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name    = safe(request.getParameter("name"));
        String email   = safe(request.getParameter("email"));
        String subject = safe(request.getParameter("subject"));
        String message = safe(request.getParameter("message"));

        if (name.isEmpty() || email.isEmpty() || subject.isEmpty() || message.isEmpty()) {
            sendBack(request, response, "All fields are required.", null, name, email, subject, message);
            return;
        }
        if (!name.matches(".*[a-zA-Z].*")) {
            sendBack(request, response, "Please enter a valid full name.", null, name, email, subject, message);
            return;
        }
        if (!email.matches("^[\\w._%+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$")) {
            sendBack(request, response, "Please enter a valid email address.", null, name, email, subject, message);
            return;
        }
        if (message.length() < 10) {
            sendBack(request, response, "Message must be at least 10 characters.", null, name, email, subject, message);
            return;
        }

        ContactMessage msg = new ContactMessage(name, email, subject, message);
        boolean saved = contactDAO.save(msg);

        if (saved) {
            sendBack(request, response, null,
                "Thank you, " + name + "! Message received. We will respond within 24 hours.",
                "", "", "", "");
        } else {
            sendBack(request, response, "Something went wrong. Please try again.", null, name, email, subject, message);
        }
    }

    private String safe(String p) {
        return (p != null) ? p.trim() : "";
    }

    private void sendBack(HttpServletRequest req, HttpServletResponse res,
                           String error, String success,
                           String name, String email, String subject, String message)
            throws ServletException, IOException {
        req.setAttribute("errorMsg",    error);
        req.setAttribute("success",  success);
        req.setAttribute("fName",    name);
        req.setAttribute("fEmail",   email);
        req.setAttribute("fSubject", subject);
        req.setAttribute("fMessage", message);
        req.getRequestDispatcher("/WEB-INF/views/user/contact.jsp").forward(req, res);
    }
}