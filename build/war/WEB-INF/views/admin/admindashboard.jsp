<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.eventhub.model.Event,com.eventhub.model.AdminAction,java.util.List" %>
<%@ page import="java.util.List, com.eventhub.model.Event, com.eventhub.model.AdminAction" %>
<%-- adminDashboard.jsp — Admin dashboard with system statistics --%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<%
    int totalUsers = (request.getAttribute("totalUsers") != null) ? (int) request.getAttribute("totalUsers") : 0;
    int totalEvents = (request.getAttribute("totalEvents") != null) ? (int) request.getAttribute("totalEvents") : 0;
    int pendingEvents = (request.getAttribute("pendingEvents") != null) ? (int) request.getAttribute("pendingEvents") : 0;
    int approvedEvents = (request.getAttribute("approvedEvents") != null) ? (int) request.getAttribute("approvedEvents") : 0;
    int rejectedEvents = (request.getAttribute("rejectedEvents") != null) ? (int) request.getAttribute("rejectedEvents") : 0;
    List<AdminAction> recentActions = (List<AdminAction>) request.getAttribute("recentActions");
    List<Event> pendingList = (List<Event>) request.getAttribute("pendingList");
%>

<main class="page-transition max-w-7xl mx-auto px-6 py-10">
    <!-- Admin Header -->
    <div class="mb-8 flex items-center gap-3">
        <span class="material-symbols-outlined text-tertiary text-3xl">admin_panel_settings</span>
        <div>
            <h1 class="text-3xl font-bold font-headline text-on-surface">Admin Dashboard</h1>
            <p class="text-on-surface-variant text-sm">System overview and quick actions.</p>
        </div>
    </div>

    <!-- Stats Grid -->
    <div class="grid grid-cols-2 md:grid-cols-5 gap-4 mb-10">
        <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/10 p-5 text-center shadow-sm">
            <span class="material-symbols-outlined text-primary text-2xl mb-2">group</span>
            <div class="text-2xl font-bold font-headline text-on-surface"><%= totalUsers %></div>
            <div class="text-xs text-on-surface-variant">Total Users</div>
        </div>
        <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/10 p-5 text-center shadow-sm">
            <span class="material-symbols-outlined text-secondary text-2xl mb-2">event</span>
            <div class="text-2xl font-bold font-headline text-on-surface"><%= totalEvents %></div>
            <div class="text-xs text-on-surface-variant">Total Events</div>
        </div>
        <div class="bg-yellow-50 rounded-xl border border-yellow-200 p-5 text-center shadow-sm">
            <span class="material-symbols-outlined text-yellow-600 text-2xl mb-2">pending</span>
            <div class="text-2xl font-bold font-headline text-yellow-700"><%= pendingEvents %></div>
            <div class="text-xs text-yellow-600">Pending Review</div>
        </div>
        <div class="bg-green-50 rounded-xl border border-green-200 p-5 text-center shadow-sm">
            <span class="material-symbols-outlined text-green-600 text-2xl mb-2">check_circle</span>
            <div class="text-2xl font-bold font-headline text-green-700"><%= approvedEvents %></div>
            <div class="text-xs text-green-600">Approved</div>
        </div>
        <div class="bg-red-50 rounded-xl border border-red-200 p-5 text-center shadow-sm">
            <span class="material-symbols-outlined text-red-600 text-2xl mb-2">cancel</span>
            <div class="text-2xl font-bold font-headline text-red-700"><%= rejectedEvents %></div>
            <div class="text-xs text-red-600">Rejected</div>
        </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
        <!-- Pending Events Queue (8 cols) -->
        <div class="lg:col-span-8">
            <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-bold font-headline text-on-surface flex items-center gap-2">
                    <span class="material-symbols-outlined text-yellow-600">pending_actions</span> Pending Events
                </h2>
                <a href="${pageContext.request.contextPath}/admin/events?status=pending" class="text-primary font-semibold text-sm hover:underline">View All</a>
            </div>
            <% if (pendingList != null && !pendingList.isEmpty()) { %>
            <div class="space-y-3">
                <% for (Event event : pendingList) { %>
                <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 p-5 flex flex-col md:flex-row md:items-center justify-between gap-4 shadow-sm">
                    <div class="flex-1 min-w-0">
                        <h3 class="font-bold font-headline text-on-surface truncate"><%= event.getTitle() %></h3>
                        <div class="flex flex-wrap gap-3 text-xs text-on-surface-variant mt-1">
                            <span><%= event.getCategory() %></span>
                            <span><%= event.getEventDate() %></span>
                            <span>by <%= event.getOrganizerName() %></span>
                        </div>
                    </div>
                    <div class="flex gap-2 shrink-0">
                        <form action="${pageContext.request.contextPath}/admin/events" method="POST" class="inline">
                            <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                            <input type="hidden" name="action" value="approve">
                            <button class="px-4 py-2 bg-green-600 text-white rounded-full text-sm font-bold hover:bg-green-700 transition-colors">Approve</button>
                        </form>
                        <form action="${pageContext.request.contextPath}/admin/events" method="POST" class="inline">
                            <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                            <input type="hidden" name="action" value="reject">
                            <button class="px-4 py-2 bg-red-600 text-white rounded-full text-sm font-bold hover:bg-red-700 transition-colors">Reject</button>
                        </form>
                    </div>
                </div>
                <% } %>
            </div>
            <% } else { %>
            <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 p-10 text-center">
                <span class="material-symbols-outlined text-4xl text-green-400 mb-3">task_alt</span>
                <p class="text-on-surface-variant">All caught up! No events pending review.</p>
            </div>
            <% } %>
        </div>

        <!-- Quick Links + Activity Log (4 cols) -->
        <div class="lg:col-span-4 space-y-6">
            <!-- Quick Links -->
            <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 p-6 shadow-sm">
                <h3 class="font-bold font-headline text-on-surface mb-4">Quick Actions</h3>
                <div class="space-y-2">
                    <a href="${pageContext.request.contextPath}/admin/events" class="flex items-center gap-3 p-3 rounded-lg hover:bg-surface-container-low transition-colors">
                        <span class="material-symbols-outlined text-primary">event_note</span>
                        <span class="text-sm font-semibold text-on-surface">Event Moderation</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/users" class="flex items-center gap-3 p-3 rounded-lg hover:bg-surface-container-low transition-colors">
                        <span class="material-symbols-outlined text-secondary">manage_accounts</span>
                        <span class="text-sm font-semibold text-on-surface">User Management</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/logs" class="flex items-center gap-3 p-3 rounded-lg hover:bg-surface-container-low transition-colors">
                        <span class="material-symbols-outlined text-tertiary">history</span>
                        <span class="text-sm font-semibold text-on-surface">Action Log</span>
                    </a>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 p-6 shadow-sm">
                <h3 class="font-bold font-headline text-on-surface mb-4">Recent Activity</h3>
                <% if (recentActions != null && !recentActions.isEmpty()) { %>
                <div class="space-y-3">
                    <% int maxShow = Math.min(recentActions.size(), 5);
                       for (int i = 0; i < maxShow; i++) {
                           AdminAction action = recentActions.get(i); %>
                    <div class="p-3 bg-surface-container-low rounded-lg">
                        <div class="text-sm font-semibold text-on-surface"><%= action.getActionType() %></div>
                        <div class="text-xs text-on-surface-variant"><%= action.getNotes() %></div>
                        <div class="text-xs text-on-surface-variant mt-1"><%= action.getActionAt() %></div>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <p class="text-sm text-on-surface-variant text-center py-4">No recent activity.</p>
                <% } %>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
