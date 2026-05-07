package com.eventhub.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtil {

    private static final int SALT_LENGTH = 16;

    public static String hashPassword(String password) {
        try {
            byte[] salt = generateSalt();
            byte[] hash = sha256(password + Base64.getEncoder().encodeToString(salt));
            return Base64.getEncoder().encodeToString(salt) + ":" +
                   Base64.getEncoder().encodeToString(hash);
        } catch (Exception e) {
            throw new RuntimeException("Password hashing failed", e);
        }
    }

    public static boolean checkPassword(String rawPassword, String storedHash) {
        try {
            String[] parts = storedHash.split(":");
            if (parts.length != 2) return false;
            String saltStr = parts[0];
            String hashStr = parts[1];
            byte[] hash = sha256(rawPassword + saltStr);
            return hashStr.equals(Base64.getEncoder().encodeToString(hash));
        } catch (Exception e) {
            return false;
        }
    }

    public static String generateResetToken() {
        byte[] bytes = new byte[32];
        new SecureRandom().nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
    

    private static byte[] generateSalt() {
        byte[] salt = new byte[SALT_LENGTH];
        new SecureRandom().nextBytes(salt);
        return salt;
    }

    private static byte[] sha256(String input) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        return md.digest(input.getBytes());
    }
}