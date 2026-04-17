<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.eventhub.model.Event,java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.eventhub.model.Event" %>
<%-- myEvents.jsp — User's created events --%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<% List<Event> myEvents = (List<Event>) request.getAttribute("myEvents"); %>

<main class="page-transition max-w-5xl mx-auto px-6 py-10">
    <div class="flex justify-between items-center mb-8">
        <div>
            <h1 class="text-3xl font-bold font-headline text-on-surface mb-1">My Events</h1>
            <p class="text-on-surface-variant text-sm">Events you've created and their current status.</p>
        </div>
        <a href="${pageContext.request.contextPath}/events/create" class="primary-gradient text-on-primary px-6 py-3 rounded-full font-bold text-sm hover:scale-[1.02] transition-all flex items-center gap-2 shadow-md">
            <span class="material-symbols-outlined text-lg">add</span> New Event
        </a>
    </div>

    <!-- Success message -->
    <% if ("created".equals(request.getParameter("success"))) { %>
    <div class="mb-6 p-4 bg-green-50 text-green-700 rounded-lg border border-green-200 text-sm font-medium flex items-center gap-2">
        <span class="material-symbols-outlined text-lg">check_circle</span> Event created successfully! It's now pending admin review.
    </div>
    <% } else if ("updated".equals(request.getParameter("success"))) { %>
    <div class="mb-6 p-4 bg-green-50 text-green-700 rounded-lg border border-green-200 text-sm font-medium flex items-center gap-2">
        <span class="material-symbols-outlined text-lg">check_circle</span> Event updated successfully!
    </div>
    <% } %>

    <% if (myEvents != null && !myEvents.isEmpty()) { %>
    <div class="space-y-4">
        <% for (Event event : myEvents) { %>
        <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 shadow-sm p-6 flex flex-col md:flex-row md:items-center justify-between gap-4">
            <div class="flex-1 min-w-0">
                <div class="flex flex-wrap items-center gap-2 mb-2">
                    <span class="px-3 py-1 rounded-full text-xs font-bold bg-primary/10 text-primary"><%= event.getCategory() %></span>
                    <% if ("approved".equals(event.getStatus())) { %>
                    <span class="px-3 py-1 rounded-full text-xs font-bold bg-green-100 text-green-700">✓ Approved</span>
                    <% } else if ("pending".equals(event.getStatus())) { %>
                    <span class="px-3 py-1 rounded-full text-xs font-bold bg-yellow-100 text-yellow-700">⏳ Pending</span>
                    <% } else { %>
                    <span class="px-3 py-1 rounded-full text-xs font-bold bg-red-100 text-red-700">✕ Rejected</span>
                    <% } %>
                </div>
                <h3 class="font-bold font-headline text-lg text-on-surface mb-1 truncate"><%= event.getTitle() %></h3>
                <div class="flex flex-wrap items-center gap-4 text-xs text-on-surface-variant">
                    <span class="flex items-center gap-1"><span class="material-symbols-outlined text-sm">calendar_today</span> <%= event.getEventDate() %></span>
                    <span class="flex items-center gap-1"><span class="material-symbols-outlined text-sm">location_on</span> <%= event.getLocation() %></span>
                    <span class="flex items-center gap-1"><span class="material-symbols-outlined text-sm">group</span> <%= event.getParticipantCount() %> joined</span>
                </div>
            </div>
            <div class="flex items-center gap-2 shrink-0">
                <a href="${pageContext.request.contextPath}/events/detail?id=<%= event.getEventId() %>"
                   class="px-4 py-2 bg-surface-container border border-outline-variant/20 rounded-full text-sm font-semibold hover:shadow-sm transition-all">View</a>
                <a href="${pageContext.request.contextPath}/events/edit?id=<%= event.getEventId() %>"
                   class="px-4 py-2 bg-surface-container border border-outline-variant/20 rounded-full text-sm font-semibold hover:shadow-sm transition-all">Edit</a>
                <form action="${pageContext.request.contextPath}/events/my" method="POST" class="inline"
                      onsubmit="return confirm('Are you sure you want to delete this event?');">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                    <button type="submit" class="px-4 py-2 bg-red-50 text-red-600 border border-red-200 rounded-full text-sm font-semibold hover:bg-red-100 transition-all">Delete</button>
                </form>
            </div>
        </div>
        <% } %>
    </div>
    <% } else { %>
    <div class="text-center py-20 bg-surface-container-lowest rounded-xl border border-outline-variant/15">
        <span class="material-symbols-outlined text-6xl text-outline-variant mb-4">event</span>
        <h3 class="text-xl font-bold font-headline text-on-surface mb-2">No events yet</h3>
        <p class="text-on-surface-variant mb-6">Create your first event and share it with the community!</p>
        <a href="${pageContext.request.contextPath}/events/create" class="primary-gradient text-on-primary px-6 py-3 rounded-full font-bold text-sm hover:scale-[1.02] transition-all inline-flex items-center gap-2">
            <span class="material-symbols-outlined text-lg">add</span> Create Event
        </a>
    </div>
    <% } %>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
