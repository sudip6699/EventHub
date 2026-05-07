<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password — EventHub</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #fef2f2;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .card {
            background: white;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(0,0,0,.08);
            width: 100%;
            max-width: 420px;
            text-align: center;
        }
        .logo { color: #C0392B; font-size: 24px; font-weight: 800; margin-bottom: 16px; }
        h2 { color: #1a1a2e; margin-bottom: 8px; font-size: 22px; }
        p  { color: #666; margin-bottom: 24px; font-size: 14px; }
        .alert-success {
            background: #d4edda; color: #155724;
            padding: 12px; border-radius: 8px;
            margin-bottom: 16px; font-size: 14px;
        }
        .alert-error {
            background: #fde8e8; color: #c0392b;
            padding: 12px; border-radius: 8px;
            margin-bottom: 16px; font-size: 14px;
        }
        .form-group { text-align: left; margin-bottom: 16px; }
        label { display: block; font-size: 13px; font-weight: 600; color: #444; margin-bottom: 6px; }
        input {
            width: 100%; padding: 12px 16px;
            border: 1.5px solid #e0e0e0;
            border-radius: 8px; font-size: 14px; outline: none;
        }
        input:focus { border-color: #c0392b; }
        .btn {
            width: 100%; padding: 14px;
            background: #c0392b; color: white;
            border: none; border-radius: 8px;
            font-size: 16px; font-weight: 600;
            cursor: pointer; margin-top: 8px;
        }
        .btn:hover { background: #a93226; }
        .back {
            display: block; margin-top: 20px;
            color: #c0392b; text-decoration: none; font-size: 14px;
        }
    </style>
</head>
<body>
<div class="card">
    <div class="logo">EventHub</div>
    <h2>Set New Password</h2>
    <p>Enter your new password below.</p>

    <c:if test="${not empty error}">
        <div class="alert-error">${error}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/reset-password">
        <input type="hidden" name="token" value="${token}">

        <div class="form-group">
            <label>New Password</label>
            <input type="password" name="newPassword"
                   placeholder="Min. 6 characters" required>
        </div>

        <div class="form-group">
            <label>Confirm Password</label>
            <input type="password" name="confirmPassword"
                   placeholder="Repeat password" required>
        </div>

        <button type="submit" class="btn">Reset Password</button>
    </form>

    <a href="${pageContext.request.contextPath}/login" class="back">
        ← Back to Login
    </a>
</div>
</body>
</html>