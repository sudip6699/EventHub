<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.eventhub.model.Event,com.eventhub.model.AdminAction,java.util.List" %>
<%@ page import="java.util.List, com.eventhub.model.Event" %>
<%-- eventModeration.jsp — Admin event moderation page --%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<%
    List<Event> events = (List<Event>) request.getAttribute("events");
    String statusFilter = (request.getAttribute("statusFilter") != null) ? (String) request.getAttribute("statusFilter") : "";
    int pendingCount = (request.getAttribute("pendingCount") != null) ? (int) request.getAttribute("pendingCount") : 0;
    int approvedCount = (request.getAttribute("approvedCount") != null) ? (int) request.getAttribute("approvedCount") : 0;
    int rejectedCount = (request.getAttribute("rejectedCount") != null) ? (int) request.getAttribute("rejectedCount") : 0;
%>

<main class="page-transition max-w-6xl mx-auto px-6 py-10">
    <div class="mb-8">
        <h1 class="text-3xl font-bold font-headline text-on-surface mb-1">Event Moderation</h1>
        <p class="text-on-surface-variant text-sm">Review, approve, or reject user-submitted events.</p>
    </div>

    <!-- Filter tabs -->
    <div class="flex flex-wrap gap-2 mb-8">
        <a href="${pageContext.request.contextPath}/admin/events" class="px-5 py-2 rounded-full text-sm font-semibold border transition-all <%= statusFilter.isEmpty() ? "bg-primary text-on-primary border-primary" : "bg-surface-container-lowest text-on-surface-variant border-outline-variant/20 hover:border-primary" %>">
            All (<%= pendingCount + approvedCount + rejectedCount %>)
        </a>
        <a href="${pageContext.request.contextPath}/admin/events?status=pending" class="px-5 py-2 rounded-full text-sm font-semibold border transition-all <%= "pending".equals(statusFilter) ? "bg-yellow-500 text-white border-yellow-500" : "bg-surface-container-lowest text-on-surface-variant border-outline-variant/20 hover:border-yellow-500" %>">
            Pending (<%= pendingCount %>)
        </a>
        <a href="${pageContext.request.contextPath}/admin/events?status=approved" class="px-5 py-2 rounded-full text-sm font-semibold border transition-all <%= "approved".equals(statusFilter) ? "bg-green-600 text-white border-green-600" : "bg-surface-container-lowest text-on-surface-variant border-outline-variant/20 hover:border-green-600" %>">
            Approved (<%= approvedCount %>)
        </a>
        <a href="${pageContext.request.contextPath}/admin/events?status=rejected" class="px-5 py-2 rounded-full text-sm font-semibold border transition-all <%= "rejected".equals(statusFilter) ? "bg-red-600 text-white border-red-600" : "bg-surface-container-lowest text-on-surface-variant border-outline-variant/20 hover:border-red-600" %>">
            Rejected (<%= rejectedCount %>)
        </a>
    </div>

    <!-- Events table/list -->
    <% if (events != null && !events.isEmpty()) { %>
    <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead class="bg-surface-container-low">
                    <tr>
                        <th class="px-6 py-4 text-left text-xs font-bold text-on-surface-variant uppercase tracking-wider">Event</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-on-surface-variant uppercase tracking-wider">Category</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-on-surface-variant uppercase tracking-wider">Date</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-on-surface-variant uppercase tracking-wider">Organizer</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-on-surface-variant uppercase tracking-wider">Status</th>
                        <th class="px-6 py-4 text-center text-xs font-bold text-on-surface-variant uppercase tracking-wider">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-outline-variant/10">
                    <% for (Event event : events) { %>
                    <tr class="hover:bg-surface-container-low/50 transition-colors">
                        <td class="px-6 py-4">
                            <a href="${pageContext.request.contextPath}/events/detail?id=<%= event.getEventId() %>" class="font-semibold text-on-surface hover:text-primary transition-colors"><%= event.getTitle() %></a>
                            <div class="text-xs text-on-surface-variant mt-1"><%= event.getParticipantCount() %> participants</div>
                        </td>
                        <td class="px-6 py-4 text-sm text-on-surface-variant"><%= event.getCategory() %></td>
                        <td class="px-6 py-4 text-sm text-on-surface-variant"><%= event.getEventDate() %></td>
                        <td class="px-6 py-4 text-sm text-on-surface-variant"><%= event.getOrganizerName() %></td>
                        <td class="px-6 py-4">
                            <% if ("approved".equals(event.getStatus())) { %>
                            <span class="px-3 py-1 rounded-full text-xs font-bold bg-green-100 text-green-700">Approved</span>
                            <% } else if ("pending".equals(event.getStatus())) { %>
                            <span class="px-3 py-1 rounded-full text-xs font-bold bg-yellow-100 text-yellow-700">Pending</span>
                            <% } else { %>
                            <span class="px-3 py-1 rounded-full text-xs font-bold bg-red-100 text-red-700">Rejected</span>
                            <% } %>
                        </td>
                        <td class="px-6 py-4">
                            <div class="flex items-center justify-center gap-1">
                                <% if (!"approved".equals(event.getStatus())) { %>
                                <form action="${pageContext.request.contextPath}/admin/events" method="POST" class="inline">
                                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                                    <input type="hidden" name="action" value="approve">
                                    <button class="p-2 rounded-lg hover:bg-green-50 text-green-600 transition-colors" title="Approve">
                                        <span class="material-symbols-outlined text-lg">check_circle</span>
                                    </button>
                                </form>
                                <% } %>
                                <% if (!"rejected".equals(event.getStatus())) { %>
                                <form action="${pageContext.request.contextPath}/admin/events" method="POST" class="inline">
                                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                                    <input type="hidden" name="action" value="reject">
                                    <button class="p-2 rounded-lg hover:bg-red-50 text-red-600 transition-colors" title="Reject">
                                        <span class="material-symbols-outlined text-lg">cancel</span>
                                    </button>
                                </form>
                                <% } %>
                                <form action="${pageContext.request.contextPath}/admin/events" method="POST" class="inline" onsubmit="return confirm('Delete this event permanently?');">
                                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                                    <input type="hidden" name="action" value="delete">
                                    <button class="p-2 rounded-lg hover:bg-red-50 text-red-400 transition-colors" title="Delete">
                                        <span class="material-symbols-outlined text-lg">delete</span>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } else { %>
    <div class="text-center py-20 bg-surface-container-lowest rounded-xl border border-outline-variant/15">
        <span class="material-symbols-outlined text-6xl text-outline-variant mb-4">event_busy</span>
        <h3 class="text-xl font-bold font-headline text-on-surface mb-2">No events found</h3>
        <p class="text-on-surface-variant">No events match the current filter.</p>
    </div>
    <% } %>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
