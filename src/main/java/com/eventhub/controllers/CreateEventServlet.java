package com.eventhub.controllers;

import com.eventhub.model.Event;
import com.eventhub.service.EventService;
import com.eventhub.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.UUID;

@WebServlet("/events/create")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 5 * 1024 * 1024,
    maxRequestSize    = 10 * 1024 * 1024
)
public class CreateEventServlet extends HttpServlet {

    private final EventService eventService = new EventService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/user/createevent.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = SessionUtil.getUserId(req);
        try {
            Event e = new Event();
            e.setTitle(req.getParameter("title"));
            e.setDescription(req.getParameter("description"));
            e.setCategory(req.getParameter("category"));
            e.setLocation(req.getParameter("location"));
            e.setHostId(userId);
            e.setStatus("pending");

            // Max participants — handle blank
            String maxP = req.getParameter("maxParticipants");
            if (maxP != null && !maxP.trim().isEmpty()) {
                e.setMaxParticipants(Integer.parseInt(maxP.trim()));
            } else {
                e.setMaxParticipants(0); // 0 = unlimited
            }

            // Date
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            e.setEventDate(sdf.parse(req.getParameter("eventDate")));

            // Time — store as java.sql.Time to avoid format issues
            String timeParam = req.getParameter("eventTime");
            if (timeParam != null && !timeParam.isEmpty()) {
                e.setEventTime(java.sql.Time.valueOf(timeParam + ":00"));
            }

            // isPaid + ticketPrice
            boolean isPaid = "true".equals(req.getParameter("isPaid"));
            e.setIsPaid(isPaid);
            if (isPaid) {
                String priceParam = req.getParameter("ticketPrice");
                if (priceParam != null && !priceParam.trim().isEmpty()) {
                    e.setTicketPrice(Double.parseDouble(priceParam.trim()));
                }
            }

            // Handle image upload
            Part filePart = req.getPart("coverImage");
            if (filePart != null && filePart.getSize() > 0) {
                String originalName = Paths.get(
                    filePart.getSubmittedFileName()).getFileName().toString();
                String fileName = UUID.randomUUID().toString() + "_" + originalName;

                String uploadDir = getServletContext().getRealPath("/images/events");
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input,
                        new File(uploadDir + File.separator + fileName).toPath(),
                        StandardCopyOption.REPLACE_EXISTING);
                }
                e.setImagePath("images/events/" + fileName);
            }

            eventService.createEvent(e);
            resp.sendRedirect(req.getContextPath() + "/events/my?success=created");

        } catch (Exception ex) {
            req.setAttribute("error", "Could not create event: " + ex.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/user/createevent.jsp").forward(req, resp);
        }
    }
}
