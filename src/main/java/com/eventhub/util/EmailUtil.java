package com.eventhub.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtil {

    private static final String FROM_EMAIL = "sudipparajuli107@gmail.com";
    private static final String APP_PASSWORD = "djtmkuotwqobbzcf";

    public static void sendPasswordReset(String toEmail, String resetToken, String contextPath)
            throws Exception {

        String resetLink = "http://localhost:8080" + contextPath +
                           "/reset-password?token=" + resetToken;

        Properties props = new Properties();
        props.put("mail.smtp.auth",            "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host",            "smtp.gmail.com");
        props.put("mail.smtp.port",            "587");
        props.put("mail.smtp.ssl.trust",       "smtp.gmail.com");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("EventHub — Reset Your Password");
        message.setContent(
            "<div style='font-family:Arial,sans-serif;max-width:500px;margin:auto;'>" +
            "<h2 style='color:#C0392B;'>EventHub Password Reset</h2>" +
            "<p>We received a request to reset your password.</p>" +
            "<p>Click the button below. Link expires in <strong>1 hour</strong>.</p>" +
            "<a href='" + resetLink + "' style='background:#C0392B;color:white;padding:12px 24px;" +
            "text-decoration:none;border-radius:6px;display:inline-block;margin:16px 0;'>" +
            "Reset Password</a>" +
            "<p style='color:#888;font-size:12px;'>If you didn't request this, ignore this email.</p>" +
            "</div>",
            "text/html"
        );
        Transport.send(message);
    }
}