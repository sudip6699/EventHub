<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.eventhub.model.Event,java.util.List" %>
<%@ page import="com.eventhub.model.Event" %>
<%-- editEvent.jsp — Form to edit an existing event --%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<%
    Event event = (Event) request.getAttribute("event");
    String[] categories = {"Workshop", "Seminar", "Meetup", "Cultural", "Sports", "Other"};
%>

<main class="page-transition max-w-3xl mx-auto px-6 py-10">
    <a href="${pageContext.request.contextPath}/events/my" class="inline-flex items-center gap-1 text-sm text-on-surface-variant hover:text-primary transition-colors mb-6">
        <span class="material-symbols-outlined text-lg">arrow_back</span> Back to My Events
    </a>

    <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 shadow-sm p-8 md:p-10">
        <h1 class="text-2xl font-bold font-headline text-on-surface mb-2">Edit Event</h1>
        <p class="text-on-surface-variant text-sm mb-8">Update your event details. Changes will reset the status to pending for re-review.</p>

        <% String errorMsg = (String) request.getAttribute("errorMsg"); %>
        <% if (errorMsg != null) { %>
        <div class="mb-6 p-4 bg-red-50 text-red-700 rounded-lg border border-red-200 text-sm font-medium flex items-center gap-2">
            <span class="material-symbols-outlined text-lg">error</span> <%= errorMsg %>
        </div>
        <% } %>

        <% if (event != null) { %>
        <form action="${pageContext.request.contextPath}/events/edit" method="POST" class="space-y-6">
            <input type="hidden" name="eventId" value="<%= event.getEventId() %>">

            <div>
                <label class="block text-sm font-semibold mb-2" for="title">Event Title *</label>
                <input type="text" id="title" name="title" required value="<%= event.getTitle() %>"
                       class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
            </div>

            <div>
                <label class="block text-sm font-semibold mb-2" for="description">Description *</label>
                <textarea id="description" name="description" required rows="5"
                          class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all resize-none"><%= event.getDescription() %></textarea>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-semibold mb-2" for="eventDate">Event Date *</label>
                    <input type="date" id="eventDate" name="eventDate" required value="<%= event.getEventDate() %>"
                           class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
                </div>
                <div>
                    <label class="block text-sm font-semibold mb-2" for="eventTime">Event Time</label>
                    <input type="time" id="eventTime" name="eventTime" value="<%= event.getEventTime() != null ? event.getEventTime() : "" %>"
                           class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
                </div>
            </div>

            <div>
                <label class="block text-sm font-semibold mb-2" for="location">Location *</label>
                <input type="text" id="location" name="location" required value="<%= event.getLocation() %>"
                       class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-semibold mb-2" for="category">Category *</label>
                    <select id="category" name="category" required
                            class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
                        <% for (String cat : categories) { %>
                        <option value="<%= cat %>" <%= cat.equals(event.getCategory()) ? "selected" : "" %>><%= cat %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-semibold mb-2" for="maxParticipants">Max Participants</label>
                    <input type="number" id="maxParticipants" name="maxParticipants" min="0"
                           value="<%= event.getMaxParticipants() > 0 ? event.getMaxParticipants() : "" %>"
                           class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
                </div>
            </div>

            <div class="p-4 bg-yellow-50 text-yellow-700 rounded-lg border border-yellow-200 text-sm flex items-start gap-2">
                <span class="material-symbols-outlined text-lg mt-0.5">warning</span>
                <span>Editing will reset the event status to <strong>pending</strong>. It must be re-approved by an admin.</span>
            </div>

            <button type="submit" class="w-full py-4 primary-gradient text-on-primary font-bold rounded-full hover:scale-[1.02] shadow-lg transition-all">
                Update Event
            </button>
        </form>
        <% } %>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
