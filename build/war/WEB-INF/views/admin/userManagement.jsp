<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management – EventHub Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f5f5f5; margin: 0; }
        .admin-wrapper { display: flex; min-height: 100vh; }
        .sidebar { width: 220px; background: #1a1a2e; color: #fff; padding: 20px 0; }
        .sidebar h2 { text-align: center; color: #e94560; margin-bottom: 30px; }
        .sidebar a { display: block; padding: 12px 24px; color: #ccc; text-decoration: none; }
        .sidebar a:hover, .sidebar a.active { background: #e94560; color: #fff; }
        .main { flex: 1; padding: 30px; }
        .main h1 { margin-bottom: 20px; color: #1a1a2e; }
        .alert { padding: 12px 16px; border-radius: 6px; margin-bottom: 20px; }
        .alert-success { background: #d4edda; color: #155724; }
        .alert-error   { background: #f8d7da; color: #721c24; }
        .card { background: #fff; border-radius: 10px; padding: 24px; box-shadow: 0 2px 8px rgba(0,0,0,.08); }
        .search-bar { display: flex; gap: 10px; margin-bottom: 20px; }
        .search-bar input { flex: 1; padding: 10px 14px; border: 1px solid #ddd; border-radius: 6px; }
        .search-bar button { padding: 10px 20px; background: #e94560; color: #fff; border: none; border-radius: 6px; cursor: pointer; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #1a1a2e; color: #fff; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #eee; vertical-align: middle; }
        tr:hover td { background: #fafafa; }
        .badge { padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .badge-active  { background: #d4edda; color: #155724; }
        .badge-locked  { background: #f8d7da; color: #721c24; }
        .badge-admin   { background: #cce5ff; color: #004085; }
        .badge-user    { background: #e2e3e5; color: #383d41; }
        .btn { padding: 6px 14px; border: none; border-radius: 5px; cursor: pointer; font-size: 13px; text-decoration: none; display: inline-block; }
        .btn-lock    { background: #ffc107; color: #333; }
        .btn-unlock  { background: #28a745; color: #fff; }
        .btn-delete  { background: #dc3545; color: #fff; }
        .btn-view    { background: #17a2b8; color: #fff; }
        .empty { text-align: center; padding: 40px; color: #888; }
        .stats-row { display: flex; gap: 16px; margin-bottom: 24px; }
        .stat-box { flex: 1; background: #fff; border-radius: 8px; padding: 16px 20px; box-shadow: 0 2px 6px rgba(0,0,0,.07); text-align: center; }
        .stat-box h3 { margin: 0; font-size: 28px; color: #e94560; }
        .stat-box p  { margin: 4px 0 0; color: #666; font-size: 13px; }
        .avatar { width: 34px; height: 34px; border-radius: 50%; background: #e94560; color: #fff; display: inline-flex; align-items: center; justify-content: center; font-weight: 700; font-size: 14px; margin-right: 8px; }
        .name-cell { display: flex; align-items: center; }
    </style>
</head>
<body>
<div class="admin-wrapper">

    <!-- Sidebar -->
    <div class="sidebar">
        <h2>EventHub</h2>
        <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/events">Event Moderation</a>
        <a href="${pageContext.request.contextPath}/admin/users" class="active">User Management</a>
        <a href="${pageContext.request.contextPath}/admin/logs">Action Log</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>

    <!-- Main Content -->
    <div class="main">
        <h1>User Management</h1>

        <!-- Alerts -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">
                <c:choose>
                    <c:when test="${param.success eq 'locked'}">User has been locked.</c:when>
                    <c:when test="${param.success eq 'unlocked'}">User has been unlocked.</c:when>
                    <c:when test="${param.success eq 'deleted'}">User has been deleted.</c:when>
                    <c:otherwise>Action completed successfully.</c:otherwise>
                </c:choose>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error">${param.error}</div>
        </c:if>

        <!-- Stats -->
        <div class="stats-row">
            <div class="stat-box">
                <h3>${totalUsers}</h3>
                <p>Total Users</p>
            </div>
            <div class="stat-box">
                <h3>${activeUsers}</h3>
                <p>Active Users</p>
            </div>
            <div class="stat-box">
                <h3>${lockedUsers}</h3>
                <p>Locked Users</p>
            </div>
            <div class="stat-box">
                <h3>${adminUsers}</h3>
                <p>Admins</p>
            </div>
        </div>

        <div class="card">
            <!-- Search -->
            <form method="get" action="${pageContext.request.contextPath}/admin/users" class="search-bar">
                <input type="text" name="q" placeholder="Search by name or email..."
                       value="${not empty param.q ? param.q : ''}">
                <button type="submit">Search</button>
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-view">Reset</a>
            </form>

            <!-- Table -->
            <c:choose>
                <c:when test="${not empty users}">
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Joined</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${users}" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}</td>
                                    <td>
                                        <div class="name-cell">
                                            <div class="avatar">
                                                ${user.name.charAt(0)}
                                            </div>
                                            ${user.name}
                                        </div>
                                    </td>
                                    <td>${user.email}</td>
                                    <td>${not empty user.phone ? user.phone : '—'}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.role eq 'admin'}">
                                                <span class="badge badge-admin">Admin</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-user">User</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.status eq 'active'}">
                                                <span class="badge badge-active">Active</span>
                                            </c:when>
                                            <c:when test="${user.status eq 'locked'}">
                                                <span class="badge badge-locked">Locked</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-locked">${user.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${user.createdAt}" pattern="dd MMM yyyy"/>
                                    </td>
                                    <td>
                                        <!-- Lock / Unlock -->
                                        <c:choose>
                                            <c:when test="${user.status eq 'active'}">
                                                <form method="post" action="${pageContext.request.contextPath}/admin/users" style="display:inline;">
                                                    <input type="hidden" name="action" value="lock">
                                                    <input type="hidden" name="userId" value="${user.userId}">
                                                    <button type="submit" class="btn btn-lock"
                                                            onclick="return confirm('Lock this user?')">Lock</button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <form method="post" action="${pageContext.request.contextPath}/admin/users" style="display:inline;">
                                                    <input type="hidden" name="action" value="unlock">
                                                    <input type="hidden" name="userId" value="${user.userId}">
                                                    <button type="submit" class="btn btn-unlock">Unlock</button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- Delete (not for admins) -->
                                        <c:if test="${user.role ne 'admin'}">
                                            <form method="post" action="${pageContext.request.contextPath}/admin/users" style="display:inline;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="userId" value="${user.userId}">
                                                <button type="submit" class="btn btn-delete"
                                                        onclick="return confirm('Delete this user permanently?')">Delete</button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty">
                        <p>No users found.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>