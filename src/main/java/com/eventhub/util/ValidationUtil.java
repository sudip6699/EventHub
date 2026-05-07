package com.eventhub.util;

public class ValidationUtil {

    public static boolean isNullOrEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    public static boolean isValidEmail(String email) {
        if (isNullOrEmpty(email)) return false;
        return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    // Relaxed — just needs 6+ characters
    public static boolean isValidPassword(String password) {
        if (isNullOrEmpty(password)) return false;
        return password.length() >= 6;
    }

    public static boolean isValidName(String name) {
        if (isNullOrEmpty(name)) return false;
        return name.trim().length() >= 2 && name.trim().length() <= 100;
    }

    public static boolean isValidPhone(String phone) {
        if (isNullOrEmpty(phone)) return false;
        return phone.matches("^[+]?[0-9]{7,15}$");
    }

    public static String sanitize(String input) {
        if (input == null) return "";
        return input.trim()
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;");
    }
}