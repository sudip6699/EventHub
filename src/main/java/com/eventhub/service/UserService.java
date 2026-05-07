package com.eventhub.service;

import com.eventhub.dao.UserDAO;
import com.eventhub.model.User;
import com.eventhub.util.EventHubException;
import com.eventhub.util.PasswordUtil;
import com.eventhub.util.ValidationUtil;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

public class UserService {

    private final UserDAO userDAO = new UserDAO();

    public int registerUser(String name, String email, String password, String phone)
            throws EventHubException {
        User u = new User();
        u.setName(name);
        u.setEmail(email);
        u.setPassword(password);
        u.setPhone(phone);
        return register(u);
    }

    public int register(User u) throws EventHubException {
        if (ValidationUtil.isNullOrEmpty(u.getName()))
            throw new EventHubException("Name is required.");
        if (!ValidationUtil.isValidEmail(u.getEmail()))
            throw new EventHubException("Invalid email address.");
        if (!ValidationUtil.isValidPassword(u.getPassword()))
            throw new EventHubException("Password must be at least 6 characters.");
        try {
            if (userDAO.emailExists(u.getEmail()))
                throw new EventHubException("Email already registered.");
            u.setPassword(PasswordUtil.hashPassword(u.getPassword()));
            u.setRole("user");
            u.setStatus("active");
            return userDAO.insert(u);
        } catch (SQLException ex) {
            throw new EventHubException("Registration failed.", ex);
        }
    }

    public User login(String email, String password) throws EventHubException {
        if (ValidationUtil.isNullOrEmpty(email) || ValidationUtil.isNullOrEmpty(password))
            throw new EventHubException("Email and password are required.");
        try {
            User u = userDAO.findByEmail(email);
            if (u == null) throw new EventHubException("Invalid email or password.");
            if ("locked".equals(u.getStatus()))
                throw new EventHubException("Account is locked. Please contact support.");
            if (!PasswordUtil.checkPassword(password, u.getPassword())) {
                userDAO.incrementFailedAttempts(u.getUserId());
                if (u.getFailedAttempts() + 1 >= 5) {
                    userDAO.updateStatus(u.getUserId(), "locked");
                    throw new EventHubException("Too many failed attempts. Account locked.");
                }
                throw new EventHubException("Invalid email or password.");
            }
            userDAO.resetFailedAttempts(u.getUserId());
            return u;
        } catch (SQLException ex) {
            throw new EventHubException("Login failed.", ex);
        }
    }

    public User getUserById(int userId) throws EventHubException {
        try { return userDAO.findById(userId); }
        catch (SQLException ex) { throw new EventHubException("Could not fetch user.", ex); }
    }

    public User getUserByEmail(String email) throws EventHubException {
        try { return userDAO.findByEmail(email); }
        catch (SQLException ex) { throw new EventHubException("Could not fetch user.", ex); }
    }

    public List<User> getAllUsers() throws EventHubException {
        try { return userDAO.findAll(); }
        catch (SQLException ex) { throw new EventHubException("Could not fetch users.", ex); }
    }

    public boolean updateProfile(User u) throws EventHubException {
        if (ValidationUtil.isNullOrEmpty(u.getName()))
            throw new EventHubException("Name is required.");
        try { return userDAO.update(u); }
        catch (SQLException ex) { throw new EventHubException("Could not update profile.", ex); }
    }

    public boolean changePassword(int userId, String oldPassword, String newPassword)
            throws EventHubException {
        try {
            User u = userDAO.findById(userId);
            if (u == null) throw new EventHubException("User not found.");
            if (!PasswordUtil.checkPassword(oldPassword, u.getPassword()))
                throw new EventHubException("Current password is incorrect.");
            if (!ValidationUtil.isValidPassword(newPassword))
                throw new EventHubException("New password does not meet requirements.");
            return userDAO.updatePassword(userId, PasswordUtil.hashPassword(newPassword));
        } catch (SQLException ex) {
            throw new EventHubException("Password change failed.", ex);
        }
    }

    public String initiatePasswordReset(String email) throws EventHubException {
        try {
            User u = userDAO.findByEmail(email);
            if (u == null) throw new EventHubException("No account with that email.");
            String token = PasswordUtil.generateResetToken();
            Timestamp expiry = new Timestamp(System.currentTimeMillis() + 86400_000);
            userDAO.saveResetToken(u.getUserId(), token, expiry);
            return token;
        } catch (SQLException ex) {
            throw new EventHubException("Password reset failed.", ex);
        }
    }

    public boolean resetPassword(String token, String newPassword) throws EventHubException {
        try {
            User u = userDAO.findByResetToken(token);
            if (u == null) throw new EventHubException("Invalid or expired reset token.");
            if (!ValidationUtil.isValidPassword(newPassword))
                throw new EventHubException("Password does not meet requirements.");
            return userDAO.updatePassword(u.getUserId(), PasswordUtil.hashPassword(newPassword));
        } catch (SQLException ex) {
            throw new EventHubException("Password reset failed.", ex);
        }
    }

    public boolean updateStatus(int userId, String status) throws EventHubException {
        try { return userDAO.updateStatus(userId, status); }
        catch (SQLException ex) { throw new EventHubException("Could not update status.", ex); }
    }

    public int countAllUsers() throws EventHubException {
        try { return userDAO.countAll(); }
        catch (SQLException ex) { throw new EventHubException("Count failed.", ex); }
    }

    public boolean deleteUser(int userId) throws EventHubException {
        try { return userDAO.delete(userId); }
        catch (SQLException ex) { throw new EventHubException("Could not delete user.", ex); }
    }
}