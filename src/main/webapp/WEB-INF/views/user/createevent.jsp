<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.eventhub.model.Event,java.util.List" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<%
    String[] categories = {"Workshop", "Seminar", "Meetup", "Cultural", "Sports", "Other"};
%>

<main class="page-transition max-w-3xl mx-auto px-6 py-10">
    <a href="${pageContext.request.contextPath}/events/my" class="inline-flex items-center gap-1 text-sm text-on-surface-variant hover:text-primary transition-colors mb-6">
        <span class="material-symbols-outlined text-lg">arrow_back</span> Back to My Events
    </a>

    <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 shadow-sm p-8 md:p-10">
        <h1 class="text-2xl font-bold font-headline text-on-surface mb-2">Create New Event</h1>
        <p class="text-on-surface-variant text-sm mb-8">Fill in the details below. Your event will be reviewed by an admin before going live.</p>

        <!-- Error message -->
        <% String errorMsg = (String) request.getAttribute("errorMsg"); %>
        <% if (errorMsg != null) { %>
        <div class="mb-6 p-4 bg-red-50 text-red-700 rounded-lg border border-red-200 text-sm font-medium flex items-center gap-2">
            <span class="material-symbols-outlined text-lg">error</span> <%= errorMsg %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/events/create" method="POST" class="space-y-6">
            <!-- Title -->
            <div>
                <label class="block text-sm font-semibold mb-2" for="title">Event Title *</label>
                <input type="text" id="title" name="title" required
                       value="<%= request.getAttribute("title") != null ? request.getAttribute("title") : "" %>"
                       placeholder="e.g. Java Web Dev Workshop"
                       class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
            </div>

            <!-- Description -->
            <div>
                <label class="block text-sm font-semibold mb-2" for="description">Description *</label>
                <textarea id="description" name="description" required rows="5" placeholder="Describe your event in detail..."
                          class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all resize-none"><%= request.getAttribute("description") != null ? request.getAttribute("description") : "" %></textarea>
            </div>

            <!-- Date + Time in grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-semibold mb-2" for="eventDate">Event Date *</label>
                    <input type="date" id="eventDate" name="eventDate" required
                           value="<%= request.getAttribute("eventDate") != null ? request.getAttribute("eventDate") : "" %>"
                           class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
                </div>
                <div>
                    <label class="block text-sm font-semibold mb-2" for="eventTime">Event Time</label>
                    <input type="time" id="eventTime" name="eventTime"
                           value="<%= request.getAttribute("eventTime") != null ? request.getAttribute("eventTime") : "" %>"
                           class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
                </div>
            </div>

            <!-- Location -->
            <div>
                <label class="block text-sm font-semibold mb-2" for="location">Location *</label>
                <input type="text" id="location" name="location" required
                       value="<%= request.getAttribute("location") != null ? request.getAttribute("location") : "" %>"
                       placeholder="e.g. Room 301, IT Building"
                       class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
            </div>

            <!-- Category + Max Participants in grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-semibold mb-2" for="category">Category *</label>
                    <select id="category" name="category" required
                            class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
                        <option value="">Select category</option>
                        <% for (String cat : categories) { %>
                        <option value="<%= cat %>" <%= cat.equals(request.getAttribute("category")) ? "selected" : "" %>><%= cat %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-semibold mb-2" for="maxParticipants">Max Participants</label>
                    <input type="number" id="maxParticipants" name="maxParticipants" min="0" placeholder="Leave empty for unlimited"
                           value="<%= request.getAttribute("maxParticipants") != null ? request.getAttribute("maxParticipants") : "" %>"
                           class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
                </div>
            </div>

            <!-- Info banner -->
            <div class="p-4 bg-blue-50 text-blue-700 rounded-lg border border-blue-200 text-sm flex items-start gap-2">
                <span class="material-symbols-outlined text-lg mt-0.5">info</span>
                <span>Your event will be placed in a <strong>pending</strong> queue and reviewed by an admin before being published.</span>
            </div>

            <!-- Submit button -->
            <button type="submit" class="w-full py-4 primary-gradient text-on-primary font-bold rounded-full hover:scale-[1.02] shadow-lg transition-all">
                Create Event
            </button>
        </form>
    </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
