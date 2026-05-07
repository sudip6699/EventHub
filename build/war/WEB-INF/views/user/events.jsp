

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.eventhub.model.Event" %>
<%-- events.jsp — Browse and search approved events --%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<%
    List<Event> events = (List<Event>) request.getAttribute("events");
    String keyword = (request.getAttribute("keyword") != null) ? (String) request.getAttribute("keyword") : "";
    String category = (request.getAttribute("category") != null) ? (String) request.getAttribute("category") : "";
    String[] categories = {"Workshop", "Seminar", "Meetup", "Cultural", "Sports", "Other"};
%>

<main class="page-transition max-w-7xl mx-auto px-6 py-10">

    <!-- Page Header -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold font-headline text-on-surface mb-2">Discover Events</h1>
        <p class="text-on-surface-variant">Find events that match your interests.</p>
    </div>

    <!-- Search + Filter Bar -->
    <form action="${pageContext.request.contextPath}/events" method="GET" class="mb-10">
        <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 p-4 flex flex-col md:flex-row gap-4 shadow-sm">
            <!-- Keyword search -->
            <div class="flex-1 relative">
                <span class="material-symbols-outlined absolute left-4 top-3 text-on-surface-variant">search</span>
                <input type="text" name="keyword" value="<%= keyword %>" placeholder="Search by title, description, or location..."
                       class="w-full bg-surface-container-low border border-outline-variant/20 rounded-full px-4 py-3 pl-12 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 transition-all">
            </div>
            <!-- Category filter -->
            <select name="category" class="bg-surface-container-low border border-outline-variant/20 rounded-full px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 transition-all min-w-[180px]">
                <option value="">All Categories</option>
                <% for (String cat : categories) { %>
                <option value="<%= cat %>" <%= cat.equals(category) ? "selected" : "" %>><%= cat %></option>
                <% } %>
            </select>
            <!-- Search button -->
            <button type="submit" class="primary-gradient text-on-primary px-6 py-3 rounded-full font-bold hover:scale-[1.02] transition-all text-sm flex items-center gap-2">
                <span class="material-symbols-outlined text-lg">search</span> Search
            </button>
        </div>
    </form>

    <!-- Category Chips -->
    <div class="flex flex-wrap gap-2 mb-8">
        <a href="${pageContext.request.contextPath}/events" class="px-4 py-2 rounded-full text-sm font-semibold border transition-all <%= category.isEmpty() ? "bg-primary text-on-primary border-primary" : "bg-surface-container-lowest text-on-surface-variant border-outline-variant/20 hover:border-primary hover:text-primary" %>">All</a>
        <% for (String cat : categories) { %>
        <a href="${pageContext.request.contextPath}/events?category=<%= cat %>" class="px-4 py-2 rounded-full text-sm font-semibold border transition-all <%= cat.equals(category) ? "bg-primary text-on-primary border-primary" : "bg-surface-container-lowest text-on-surface-variant border-outline-variant/20 hover:border-primary hover:text-primary" %>"><%= cat %></a>
        <% } %>
    </div>

    <!-- Results count -->
    <p class="text-sm text-on-surface-variant mb-6">
        <% if (events != null) { %>
        Showing <strong><%= events.size() %></strong> event<%= events.size() != 1 ? "s" : "" %>
        <% if (!keyword.isEmpty()) { %> for "<strong><%= keyword %></strong>"<% } %>
        <% } %>
    </p>

    <!-- Events Grid -->
    <% if (events != null && !events.isEmpty()) { %>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <% for (Event event : events) { %>
        <a href="${pageContext.request.contextPath}/events/detail?id=<%= event.getEventId() %>"
           class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 shadow-sm hover:shadow-lg hover:-translate-y-1 transition-all block overflow-hidden group">
            <!-- Card top with category color strip -->
            <div class="h-2 primary-gradient"></div>
            <div class="p-6">
                <!-- Category + Date -->
                <div class="flex justify-between items-center mb-4">
                    <span class="px-3 py-1 rounded-full text-xs font-bold bg-primary/10 text-primary"><%= event.getCategory() %></span>
                    <span class="text-xs text-on-surface-variant flex items-center gap-1">
                        <span class="material-symbols-outlined text-sm">calendar_today</span> <%= event.getEventDate() %>
                    </span>
                </div>
                <!-- Title -->
                <h3 class="font-bold font-headline text-lg text-on-surface mb-2 line-clamp-2 group-hover:text-primary transition-colors"><%= event.getTitle() %></h3>
                <!-- Description excerpt -->
                <p class="text-sm text-on-surface-variant mb-4 line-clamp-2"><%= event.getExcerpt() %></p>
                <!-- Meta info -->
                <div class="flex items-center justify-between text-xs text-on-surface-variant">
                    <span class="flex items-center gap-1"><span class="material-symbols-outlined text-sm">location_on</span> <%= event.getLocation() %></span>
                    <span class="flex items-center gap-1"><span class="material-symbols-outlined text-sm">group</span> <%= event.getParticipantCount() %><% if (event.getMaxParticipants() > 0) { %>/<%= event.getMaxParticipants() %><% } %></span>
                </div>
                <% if (event.getOrganizerName() != null) { %>
                <div class="mt-3 pt-3 border-t border-outline-variant/15 text-xs text-on-surface-variant flex items-center gap-1">
                    <span class="material-symbols-outlined text-sm">person</span> By <%= event.getOrganizerName() %>
                </div>
                <% } %>
            </div>
        </a>
        <% } %>
    </div>
    <% } else { %>
    <!-- Empty state -->
    <div class="text-center py-20">
        <span class="material-symbols-outlined text-6xl text-outline-variant mb-4">event_busy</span>
        <h3 class="text-xl font-bold font-headline text-on-surface mb-2">No events found</h3>
        <p class="text-on-surface-variant mb-6">Try adjusting your search or browse all events.</p>
        <a href="${pageContext.request.contextPath}/events" class="primary-gradient text-on-primary px-6 py-3 rounded-full font-bold text-sm hover:scale-[1.02] transition-all">Clear Filters</a>
    </div>
    <% } %>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
