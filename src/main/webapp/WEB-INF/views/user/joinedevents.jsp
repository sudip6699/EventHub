<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.eventhub.model.Event,java.util.List" %>
<%@ page import="java.util.List, com.eventhub.model.Event" %>
<%-- joinedEvents.jsp — Events the user has joined --%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<% List<Event> joinedEvents = (List<Event>) request.getAttribute("joinedEvents"); %>

<main class="page-transition max-w-5xl mx-auto px-6 py-10">
    <div class="mb-8">
        <h1 class="text-3xl font-bold font-headline text-on-surface mb-1">My Tickets</h1>
        <p class="text-on-surface-variant text-sm">Events you've signed up for.</p>
    </div>

    <% if (joinedEvents != null && !joinedEvents.isEmpty()) { %>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <% for (Event event : joinedEvents) { %>
        <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 shadow-sm overflow-hidden hover:shadow-md transition-shadow">
            <div class="h-2 primary-gradient"></div>
            <div class="p-6">
                <div class="flex justify-between items-start mb-3">
                    <span class="px-3 py-1 rounded-full text-xs font-bold bg-primary/10 text-primary"><%= event.getCategory() %></span>
                    <span class="px-3 py-1 rounded-full text-xs font-bold bg-green-100 text-green-700">✓ Joined</span>
                </div>
                <h3 class="font-bold font-headline text-lg text-on-surface mb-2"><%= event.getTitle() %></h3>
                <div class="space-y-2 mb-4">
                    <div class="flex items-center gap-2 text-sm text-on-surface-variant">
                        <span class="material-symbols-outlined text-sm">calendar_today</span> <%= event.getEventDate() %>
                        <% if (event.getEventTime() != null) { %> at <%= event.getEventTime() %><% } %>
                    </div>
                    <div class="flex items-center gap-2 text-sm text-on-surface-variant">
                        <span class="material-symbols-outlined text-sm">location_on</span> <%= event.getLocation() %>
                    </div>
                    <% if (event.getOrganizerName() != null) { %>
                    <div class="flex items-center gap-2 text-sm text-on-surface-variant">
                        <span class="material-symbols-outlined text-sm">person</span> By <%= event.getOrganizerName() %>
                    </div>
                    <% } %>
                </div>
                <div class="flex gap-2">
                    <a href="${pageContext.request.contextPath}/events/detail?id=<%= event.getEventId() %>"
                       class="flex-1 text-center px-4 py-2 bg-surface-container border border-outline-variant/20 rounded-full text-sm font-semibold hover:shadow-sm transition-all">View Details</a>
                    <form action="${pageContext.request.contextPath}/participants/leave" method="POST" class="flex-1">
                        <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                        <button type="submit" class="w-full px-4 py-2 bg-red-50 text-red-600 border border-red-200 rounded-full text-sm font-semibold hover:bg-red-100 transition-all">Leave</button>
                    </form>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } else { %>
    <div class="text-center py-20 bg-surface-container-lowest rounded-xl border border-outline-variant/15">
        <span class="material-symbols-outlined text-6xl text-outline-variant mb-4">confirmation_number</span>
        <h3 class="text-xl font-bold font-headline text-on-surface mb-2">No tickets yet</h3>
        <p class="text-on-surface-variant mb-6">Browse events and join the ones you're interested in!</p>
        <a href="${pageContext.request.contextPath}/events" class="primary-gradient text-on-primary px-6 py-3 rounded-full font-bold text-sm hover:scale-[1.02] transition-all">Browse Events</a>
    </div>
    <% } %>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
