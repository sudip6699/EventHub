<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.eventhub.model.Event,java.util.List" %>
<%@ page import="com.eventhub.model.Event" %>
<%-- eventDetail.jsp — Single event detail page --%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<%
    Event event = (Event) request.getAttribute("event");
    int participantCount = (request.getAttribute("participantCount") != null) ? (int) request.getAttribute("participantCount") : 0;
    boolean isJoined = (request.getAttribute("isJoined") != null) ? (boolean) request.getAttribute("isJoined") : false;
    boolean isOwner = (request.getAttribute("isOwner") != null) ? (boolean) request.getAttribute("isOwner") : false;
    boolean isLoggedIn = (session != null && session.getAttribute("userId") != null);
    boolean isFull = (event.getMaxParticipants() > 0 && participantCount >= event.getMaxParticipants());
%>

<main class="page-transition max-w-4xl mx-auto px-6 py-10">

    <!-- Back button -->
    <a href="${pageContext.request.contextPath}/events" class="inline-flex items-center gap-1 text-sm text-on-surface-variant hover:text-primary transition-colors mb-6">
        <span class="material-symbols-outlined text-lg">arrow_back</span> Back to Events
    </a>

    <!-- Event Card -->
    <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 shadow-sm overflow-hidden">
        <!-- Color strip -->
        <div class="h-3 primary-gradient"></div>

        <div class="p-8 md:p-10">
            <!-- Status + Category badges -->
            <div class="flex flex-wrap gap-2 mb-4">
                <span class="px-3 py-1 rounded-full text-xs font-bold bg-primary/10 text-primary"><%= event.getCategory() %></span>
                <% if ("approved".equals(event.getStatus())) { %>
                <span class="px-3 py-1 rounded-full text-xs font-bold bg-green-100 text-green-700">✓ Approved</span>
                <% } else if ("pending".equals(event.getStatus())) { %>
                <span class="px-3 py-1 rounded-full text-xs font-bold bg-yellow-100 text-yellow-700">⏳ Pending Review</span>
                <% } else { %>
                <span class="px-3 py-1 rounded-full text-xs font-bold bg-red-100 text-red-700">✕ Rejected</span>
                <% } %>
            </div>

            <!-- Title -->
            <h1 class="text-3xl font-bold font-headline text-on-surface mb-4"><%= event.getTitle() %></h1>

            <!-- Organizer info -->
            <% if (event.getOrganizerName() != null) { %>
            <div class="flex items-center gap-3 mb-6">
                <div class="w-10 h-10 rounded-full primary-gradient flex items-center justify-center text-white font-bold">
                    <%= event.getOrganizerName().charAt(0) %>
                </div>
                <div>
                    <div class="text-sm font-semibold text-on-surface"><%= event.getOrganizerName() %></div>
                    <div class="text-xs text-on-surface-variant">Event Organizer</div>
                </div>
            </div>
            <% } %>

            <!-- Event details grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8 p-5 bg-surface-container-low rounded-xl">
                <div class="flex items-center gap-3">
                    <span class="material-symbols-outlined text-primary">calendar_today</span>
                    <div>
                        <div class="text-xs text-on-surface-variant">Date</div>
                        <div class="font-semibold text-on-surface"><%= event.getEventDate() %></div>
                    </div>
                </div>
                <div class="flex items-center gap-3">
                    <span class="material-symbols-outlined text-primary">schedule</span>
                    <div>
                        <div class="text-xs text-on-surface-variant">Time</div>
                        <div class="font-semibold text-on-surface"><%= event.getEventTime() != null ? event.getEventTime() : "TBA" %></div>
                    </div>
                </div>
                <div class="flex items-center gap-3">
                    <span class="material-symbols-outlined text-primary">location_on</span>
                    <div>
                        <div class="text-xs text-on-surface-variant">Location</div>
                        <div class="font-semibold text-on-surface"><%= event.getLocation() %></div>
                    </div>
                </div>
                <div class="flex items-center gap-3">
                    <span class="material-symbols-outlined text-primary">group</span>
                    <div>
                        <div class="text-xs text-on-surface-variant">Participants</div>
                        <div class="font-semibold text-on-surface"><%= participantCount %><% if (event.getMaxParticipants() > 0) { %> / <%= event.getMaxParticipants() %><% } else { %> (Unlimited)<% } %></div>
                    </div>
                </div>
            </div>

            <!-- Capacity bar -->
            <% if (event.getMaxParticipants() > 0) { %>
            <div class="mb-8">
                <div class="flex justify-between text-sm mb-1">
                    <span class="text-on-surface-variant">Capacity</span>
                    <span class="font-semibold text-on-surface"><%= Math.round((double) participantCount / event.getMaxParticipants() * 100) %>%</span>
                </div>
                <div class="w-full h-2 bg-surface-container rounded-full overflow-hidden">
                    <div class="h-full primary-gradient rounded-full transition-all" style="width: <%= Math.min(100, Math.round((double) participantCount / event.getMaxParticipants() * 100)) %>%"></div>
                </div>
            </div>
            <% } %>

            <!-- Description -->
            <div class="mb-8">
                <h2 class="text-lg font-bold font-headline text-on-surface mb-3">About This Event</h2>
                <p class="text-on-surface-variant leading-relaxed whitespace-pre-line"><%= event.getDescription() %></p>
            </div>

            <!-- Action buttons -->
            <div class="flex flex-wrap gap-3">
                <% if (isLoggedIn && "approved".equals(event.getStatus())) { %>
                    <% if (isOwner) { %>
                    <!-- Owner: Edit button -->
                    <a href="${pageContext.request.contextPath}/events/edit?id=<%= event.getEventId() %>"
                       class="px-6 py-3 bg-surface-container border border-outline-variant/30 rounded-full font-bold text-sm hover:shadow-md transition-all flex items-center gap-2">
                        <span class="material-symbols-outlined text-lg">edit</span> Edit Event
                    </a>
                    <% } else if (isJoined) { %>
                    <!-- Participant: Leave button -->
                    <form action="${pageContext.request.contextPath}/participants/leave" method="POST">
                        <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                        <button type="submit" class="px-6 py-3 bg-red-50 text-red-700 border border-red-200 rounded-full font-bold text-sm hover:bg-red-100 transition-all flex items-center gap-2">
                            <span class="material-symbols-outlined text-lg">event_busy</span> Leave Event
                        </button>
                    </form>
                    <% } else if (!isFull) { %>
                    <!-- Not joined: Join button -->
                    <form action="${pageContext.request.contextPath}/participants/join" method="POST">
                        <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                        <button type="submit" class="px-8 py-3 primary-gradient text-on-primary rounded-full font-bold text-sm hover:scale-[1.02] shadow-lg transition-all flex items-center gap-2">
                            <span class="material-symbols-outlined text-lg">event_available</span> Join Event
                        </button>
                    </form>
                    <% } else { %>
                    <!-- Full: Disabled button -->
                    <button disabled class="px-8 py-3 bg-surface-container text-on-surface-variant rounded-full font-bold text-sm cursor-not-allowed opacity-60">
                        Event Full
                    </button>
                    <% } %>
                <% } else if (!isLoggedIn) { %>
                <a href="${pageContext.request.contextPath}/login" class="px-8 py-3 primary-gradient text-on-primary rounded-full font-bold text-sm hover:scale-[1.02] shadow-lg transition-all">
                    Login to Join
                </a>
                <% } %>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
