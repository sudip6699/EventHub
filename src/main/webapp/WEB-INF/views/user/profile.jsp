<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.eventhub.model.User,java.util.List" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<%
    User user = (User) request.getAttribute("user");
    int myEventCount = (request.getAttribute("myEventCount") != null) ? (int) request.getAttribute("myEventCount") : 0;
    int joinedCount = (request.getAttribute("joinedCount") != null) ? (int) request.getAttribute("joinedCount") : 0;
%>

<main class="page-transition max-w-3xl mx-auto px-6 py-10">
    <h1 class="text-3xl font-bold font-headline text-on-surface mb-8">My Profile</h1>

    <!-- Success / Error messages -->
    <% String successMsg = (String) request.getAttribute("successMsg"); %>
    <% if (successMsg != null) { %>
    <div class="mb-6 p-4 bg-green-50 text-green-700 rounded-lg border border-green-200 text-sm font-medium flex items-center gap-2">
        <span class="material-symbols-outlined text-lg">check_circle</span> <%= successMsg %>
    </div>
    <% } %>
    <% String errorMsg = (String) request.getAttribute("errorMsg"); %>
    <% if (errorMsg != null) { %>
    <div class="mb-6 p-4 bg-red-50 text-red-700 rounded-lg border border-red-200 text-sm font-medium flex items-center gap-2">
        <span class="material-symbols-outlined text-lg">error</span> <%= errorMsg %>
    </div>
    <% } %>

    <!-- Profile Card -->
    <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 shadow-sm p-8 mb-6">
        <div class="flex items-center gap-4 mb-8">
            <div class="w-16 h-16 rounded-full primary-gradient flex items-center justify-center text-white text-2xl font-bold">
                <%= user.getName().charAt(0) %>
            </div>
            <div>
                <h2 class="text-xl font-bold font-headline text-on-surface"><%= user.getName() %></h2>
                <p class="text-sm text-on-surface-variant"><%= user.getEmail() %></p>
                <span class="inline-block mt-1 px-3 py-0.5 rounded-full text-xs font-bold bg-primary/10 text-primary capitalize"><%= user.getRole() %></span>
            </div>
        </div>
        <!-- Stats -->
        <div class="grid grid-cols-3 gap-4 p-4 bg-surface-container-low rounded-xl">
            <div class="text-center">
                <div class="text-xl font-bold font-headline text-on-surface"><%= myEventCount %></div>
                <div class="text-xs text-on-surface-variant">Events Created</div>
            </div>
            <div class="text-center">
                <div class="text-xl font-bold font-headline text-on-surface"><%= joinedCount %></div>
                <div class="text-xs text-on-surface-variant">Events Joined</div>
            </div>
            <div class="text-center">
                <div class="text-xl font-bold font-headline text-on-surface"><%= user.getCreatedAt() != null ? user.getCreatedAt().toString().substring(0, 10) : "N/A" %></div>
                <div class="text-xs text-on-surface-variant">Member Since</div>
            </div>
        </div>
    </div>

    <!-- Edit Profile Form -->
    <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 shadow-sm p-8 mb-6">
        <h2 class="text-lg font-bold font-headline text-on-surface mb-6">Edit Profile</h2>
        <form action="${pageContext.request.contextPath}/profile" method="POST" class="space-y-5">
            <input type="hidden" name="action" value="updateProfile">
            <div>
                <label class="block text-sm font-semibold mb-2" for="name">Full Name</label>
                <input type="text" id="name" name="name" required value="<%= user.getName() %>"
                       class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
            </div>
            <div>
                <label class="block text-sm font-semibold mb-2" for="email">Email Address</label>
                <input type="email" id="email" name="email" required value="<%= user.getEmail() %>"
                       class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
            </div>
            <button type="submit" class="px-8 py-3 primary-gradient text-on-primary font-bold rounded-full hover:scale-[1.02] shadow-lg transition-all text-sm">
                Save Changes
            </button>
        </form>
    </div>

    <!-- Change Password Form -->
    <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 shadow-sm p-8">
        <h2 class="text-lg font-bold font-headline text-on-surface mb-6">Change Password</h2>
        <form action="${pageContext.request.contextPath}/profile" method="POST" class="space-y-5">
            <input type="hidden" name="action" value="changePassword">
            <div>
                <label class="block text-sm font-semibold mb-2" for="currentPassword">Current Password</label>
                <input type="password" id="currentPassword" name="currentPassword" required placeholder="••••••••"
                       class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-semibold mb-2" for="newPassword">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" required placeholder="Min. 8 characters"
                           class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
                </div>
                <div>
                    <label class="block text-sm font-semibold mb-2" for="confirmPassword">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Repeat password"
                           class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
                </div>
            </div>
            <button type="submit" class="px-8 py-3 bg-surface-container border border-outline-variant/30 text-on-surface font-bold rounded-full hover:shadow-md transition-all text-sm">
                Change Password
            </button>
        </form>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
