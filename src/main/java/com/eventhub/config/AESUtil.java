package com.eventhub.config;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

/**
 * AESUtil — Encrypts and decrypts passwords using AES-128 symmetric encryption.
 * The secret key is 16 bytes (128-bit) for AES-128.
 * Encrypted output is Base64-encoded for safe storage in VARCHAR columns.
 *
 * IMPORTANT: This is a manual AES implementation as taught in Week 4.
 * In production, use bcrypt or Argon2 — but this course requires AES.
 */
public class AESUtil {

    // --- 16-byte secret key for AES-128 encryption (DO NOT change after data is stored) ---
    private static final String SECRET_KEY = "EventHub@AES2024";
    private static final String ALGORITHM  = "AES";

    /**
     * Encrypts a plain-text password using AES-128/ECB/PKCS5Padding.
     * Returns a Base64-encoded string suitable for database storage.
     *
     * @param plainText the plain-text password to encrypt
     * @return Base64-encoded encrypted string
     */
    public static String encrypt(String plainText) {
        try {
            // Create AES cipher instance
            SecretKeySpec keySpec = new SecretKeySpec(SECRET_KEY.getBytes("UTF-8"), ALGORITHM);
            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");

            // Initialise cipher in ENCRYPT mode
            cipher.init(Cipher.ENCRYPT_MODE, keySpec);

            // Encrypt and encode to Base64
            byte[] encryptedBytes = cipher.doFinal(plainText.getBytes("UTF-8"));
            return Base64.getEncoder().encodeToString(encryptedBytes);

        } catch (Exception e) {
            throw new RuntimeException("Error encrypting password", e);
        }
    }

    /**
     * Decrypts a Base64-encoded AES-encrypted string back to plain text.
     * Used during login to compare entered password with stored encrypted password.
     *
     * @param encryptedText Base64-encoded encrypted password from the database
     * @return the original plain-text password
     */
    public static String decrypt(String encryptedText) {
        try {
            // Create AES cipher instance
            SecretKeySpec keySpec = new SecretKeySpec(SECRET_KEY.getBytes("UTF-8"), ALGORITHM);
            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");

            // Initialise cipher in DECRYPT mode
            cipher.init(Cipher.DECRYPT_MODE, keySpec);

            // Decode from Base64 and decrypt
            byte[] decodedBytes = Base64.getDecoder().decode(encryptedText);
            byte[] decryptedBytes = cipher.doFinal(decodedBytes);
            return new String(decryptedBytes, "UTF-8");

        } catch (Exception e) {
            throw new RuntimeException("Error decrypting password", e);
        }
    }

    /**
     * Compares a plain-text password with an AES-encrypted password.
     *
     * @param plainPassword  the password entered by the user
     * @param encryptedPassword the AES-encrypted password from the database
     * @return true if they match, false otherwise
     */
    public static boolean checkPassword(String plainPassword, String encryptedPassword) {
        if (plainPassword == null || encryptedPassword == null) {
            return false;
        }
        try {
            String decrypted = decrypt(encryptedPassword);
            return plainPassword.equals(decrypted);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Utility main method — run this to generate encrypted passwords for seed data.
     * Usage: java com.eventhub.config.AESUtil
     */
    public static void main(String[] args) {
        String[] passwords = {"Admin@1234", "Test@1234"};
        for (String pw : passwords) {
            String encrypted = encrypt(pw);
            System.out.println("Plain: " + pw + " → Encrypted: " + encrypted);
            System.out.println("  Verify decrypt: " + decrypt(encrypted));
        }
    }
}
