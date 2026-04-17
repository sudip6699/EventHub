<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.eventhub.model.User,java.util.List" %>
<%@ page import="java.util.List, com.eventhub.model.User" %>
<%-- userManagement.jsp — Admin user management page --%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<%
    List<User> users = (List<User>) request.getAttribute("users");
    int currentAdminId = (int) session.getAttribute("userId");
%>

<main class="page-transition max-w-6xl mx-auto px-6 py-10">
    <div class="mb-8">
        <h1 class="text-3xl font-bold font-headline text-on-surface mb-1">User Management</h1>
        <p class="text-on-surface-variant text-sm">Manage user accounts, roles, and access.</p>
    </div>

    <% if ("self".equals(request.getParameter("error"))) { %>
    <div class="mb-6 p-4 bg-yellow-50 text-yellow-700 rounded-lg border border-yellow-200 text-sm font-medium flex items-center gap-2">
        <span class="material-symbols-outlined text-lg">warning</span> You cannot modify your own account.
    </div>
    <% } %>

    <% if (users != null && !users.isEmpty()) { %>
    <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead class="bg-surface-container-low">
                    <tr>
                        <th class="px-6 py-4 text-left text-xs font-bold text-on-surface-variant uppercase tracking-wider">User</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-on-surface-variant uppercase tracking-wider">Email</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-on-surface-variant uppercase tracking-wider">Role</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-on-surface-variant uppercase tracking-wider">Status</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-on-surface-variant uppercase tracking-wider">Joined</th>
                        <th class="px-6 py-4 text-center text-xs font-bold text-on-surface-variant uppercase tracking-wider">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-outline-variant/10">
                    <% for (User user : users) { %>
                    <tr class="hover:bg-surface-container-low/50 transition-colors">
                        <td class="px-6 py-4">
                            <div class="flex items-center gap-3">
                                <div class="w-9 h-9 rounded-full primary-gradient flex items-center justify-center text-white font-bold text-sm shrink-0">
                                    <%= user.getName().charAt(0) %>
                                </div>
                                <span class="font-semibold text-on-surface"><%= user.getName() %></span>
                            </div>
                        </td>
                        <td class="px-6 py-4 text-sm text-on-surface-variant"><%= user.getEmail() %></td>
                        <td class="px-6 py-4">
                            <span class="px-3 py-1 rounded-full text-xs font-bold <%= "admin".equals(user.getRole()) ? "bg-tertiary/10 text-tertiary" : "bg-primary/10 text-primary" %> capitalize"><%= user.getRole() %></span>
                        </td>
                        <td class="px-6 py-4">
                            <span class="px-3 py-1 rounded-full text-xs font-bold <%= user.getIsActive() == 1 ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700" %>">
                                <%= user.getIsActive() == 1 ? "Active" : "Disabled" %>
                            </span>
                        </td>
                        <td class="px-6 py-4 text-sm text-on-surface-variant">
                            <%= user.getCreatedAt() != null ? user.getCreatedAt().toString().substring(0, 10) : "N/A" %>
                        </td>
                        <td class="px-6 py-4">
                            <% if (user.getUserId() != currentAdminId) { %>
                            <div class="flex items-center justify-center gap-1">
                                <form action="${pageContext.request.contextPath}/admin/users" method="POST" class="inline">
                                    <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                                    <input type="hidden" name="action" value="toggleActive">
                                    <button class="p-2 rounded-lg hover:bg-surface-container transition-colors" title="<%= user.getIsActive() == 1 ? "Disable" : "Enable" %>">
                                        <span class="material-symbols-outlined text-lg <%= user.getIsActive() == 1 ? "text-green-600" : "text-red-600" %>">
                                            <%= user.getIsActive() == 1 ? "toggle_on" : "toggle_off" %>
                                        </span>
                                    </button>
                                </form>
                                <form action="${pageContext.request.contextPath}/admin/users" method="POST" class="inline">
                                    <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                                    <input type="hidden" name="action" value="toggleRole">
                                    <button class="p-2 rounded-lg hover:bg-surface-container transition-colors" title="Toggle Role">
                                        <span class="material-symbols-outlined text-lg text-tertiary">swap_horiz</span>
                                    </button>
                                </form>
                                <form action="${pageContext.request.contextPath}/admin/users" method="POST" class="inline" onsubmit="return confirm('Delete this user permanently?');">
                                    <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                                    <input type="hidden" name="action" value="delete">
                                    <button class="p-2 rounded-lg hover:bg-red-50 text-red-400 transition-colors" title="Delete User">
                                        <span class="material-symbols-outlined text-lg">delete</span>
                                    </button>
                                </form>
                            </div>
                            <% } else { %>
                            <span class="text-xs text-on-surface-variant italic">Current Admin</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } %>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
