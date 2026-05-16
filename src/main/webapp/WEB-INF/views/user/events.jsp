<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.eventhub.model.Event" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<%
    List<Event> events = (List<Event>) request.getAttribute("events");
    String keyword = (request.getAttribute("keyword") != null) ? (String) request.getAttribute("keyword") : "";
    String category = (request.getAttribute("category") != null) ? (String) request.getAttribute("category") : "";
    String[] categories = {"Workshop", "Seminar", "Meetup", "Cultural", "Sports", "Adventure", "Nature", "Music", "Food", "Tech", "Entertainment", "Festival", "Spiritual", "Other"};
    String ctx = request.getContextPath();
%>

<style>
.ec { background:#fff; border-radius:20px; overflow:hidden; box-shadow:0 4px 20px rgba(0,0,0,.07); border:1.5px solid rgba(192,57,43,.1); transition:all .3s; text-decoration:none; display:block; }
.ec:hover { transform:translateY(-6px); box-shadow:0 16px 48px rgba(192,57,43,.14); border-color:#c0392b; }
.ec-img { height:200px; position:relative; overflow:hidden; background:linear-gradient(135deg,#FFE0B2,#FFCCBC); display:flex; align-items:center; justify-content:center; font-size:56px; }
.ec-img img { width:100%; height:100%; object-fit:cover; transition:transform .4s; display:block; position:absolute; inset:0; }
.ec:hover .ec-img img { transform:scale(1.06); }
.ec-cat { position:absolute; top:12px; left:12px; background:#FF6B00; color:white; padding:5px 12px; border-radius:12px; font-size:11px; font-weight:800; text-transform:uppercase; z-index:2; }
.ec-price { position:absolute; top:12px; right:12px; background:#c0392b; color:white; padding:5px 12px; border-radius:12px; font-size:11px; font-weight:800; z-index:2; }
.ec-free  { position:absolute; top:12px; right:12px; background:#27ae60; color:white; padding:5px 12px; border-radius:12px; font-size:11px; font-weight:800; z-index:2; }
.ec-body  { padding:18px 20px 20px; }
.ec-title { font-size:16px; font-weight:800; color:#3E2000; margin-bottom:10px; line-height:1.3; }
.ec-meta  { display:flex; flex-direction:column; gap:5px; margin-bottom:12px; }
.ec-meta span { font-size:12px; color:#7A5C3E; display:flex; align-items:center; gap:6px; }
.ec-desc  { font-size:13px; color:#999; line-height:1.5; margin-bottom:14px; }
.ec-foot  { display:flex; justify-content:space-between; align-items:center; border-top:1px solid rgba(240,165,0,.2); padding-top:12px; }
.ec-spots { font-size:12px; color:#7A5C3E; }
.btn-join { background:#FF6B00; color:white; padding:8px 18px; border-radius:18px; text-decoration:none; font-size:13px; font-weight:700; transition:all .2s; border:none; cursor:pointer; }
.btn-join:hover { background:#c0392b; }
</style>

<main class="page-transition max-w-7xl mx-auto px-6 py-10">

    <!-- Page Header -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold font-headline text-on-surface mb-2">Discover Events</h1>
        <p class="text-on-surface-variant">Find events that match your interests.</p>
    </div>

    <!-- Search + Filter Bar -->
    <form action="${pageContext.request.contextPath}/events" method="GET" class="mb-10">
        <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 p-4 flex flex-col md:flex-row gap-4 shadow-sm">
            <div class="flex-1 relative">
                <span class="material-symbols-outlined absolute left-4 top-3 text-on-surface-variant">search</span>
                <input type="text" name="keyword" value="<%= keyword %>" placeholder="Search by title, description, or location..."
                       class="w-full bg-surface-container-low border border-outline-variant/20 rounded-full px-4 py-3 pl-12 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 transition-all">
            </div>
            <select name="category" class="bg-surface-container-low border border-outline-variant/20 rounded-full px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 transition-all min-w-[180px]">
                <option value="">All Categories</option>
                <% for (String cat : categories) { %>
                <option value="<%= cat %>" <%= cat.equals(category) ? "selected" : "" %>><%= cat %></option>
                <% } %>
            </select>
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
        <% for (Event event : events) {
            // Pick emoji fallback based on category
            String cat = event.getCategory() != null ? event.getCategory() : "";
            String emoji = "🎪";
            if (cat.equals("Music"))         emoji = "🎵";
            else if (cat.equals("Food"))     emoji = "🍜";
            else if (cat.equals("Cultural")) emoji = "🪷";
            else if (cat.equals("Sports"))   emoji = "🏃";
            else if (cat.equals("Tech"))     emoji = "💻";
            else if (cat.equals("Workshop")) emoji = "🎓";
            else if (cat.equals("Meetup"))   emoji = "🤝";
            else if (cat.equals("Seminar"))  emoji = "📢";
            else if (cat.equals("Adventure"))emoji = "🏔️";
            else if (cat.equals("Nature"))   emoji = "🦅";
            else if (cat.equals("Spiritual"))emoji = "🧘";
            else if (cat.equals("Festival")) emoji = "🎉";
            else if (cat.equals("Entertainment")) emoji = "🎭";
        %>
        <a href="<%= ctx %>/events/detail?id=<%= event.getEventId() %>" class="ec">
            <div class="ec-img">
                <% if (event.getImagePath() != null && !event.getImagePath().isEmpty()) { %>
                    <img src="<%= ctx %>/<%= event.getImagePath() %>" alt="<%= event.getTitle() %>">
                <% } else { %>
                    <%= emoji %>
                <% } %>
                <span class="ec-cat"><%= event.getCategory() %></span>
                <% if (event.isPaid()) { %>
                    <span class="ec-price">Rs. <%= (int)event.getTicketPrice() %></span>
                <% } else { %>
                    <span class="ec-free">FREE</span>
                <% } %>
            </div>
            <div class="ec-body">
                <div class="ec-title"><%= event.getTitle() %></div>
                <div class="ec-meta">
                    <span>📅 <%= event.getEventDate() %></span>
                    <span>📍 <%= event.getLocation() %></span>
                </div>
                <div class="ec-desc"><%= event.getExcerpt() %></div>
                <div class="ec-foot">
                    <span class="ec-spots">👥 <%= event.getParticipantCount() %><% if (event.getMaxParticipants() > 0) { %>/<%= event.getMaxParticipants() %><% } %> spots</span>
                    <span class="btn-join">View Event →</span>
                </div>
            </div>
        </a>
        <% } %>
    </div>
    <% } else { %>
    <div class="text-center py-20">
        <span class="material-symbols-outlined text-6xl text-outline-variant mb-4">event_busy</span>
        <h3 class="text-xl font-bold font-headline text-on-surface mb-2">No events found</h3>
        <p class="text-on-surface-variant mb-6">Try adjusting your search or browse all events.</p>
        <a href="${pageContext.request.contextPath}/events" class="primary-gradient text-on-primary px-6 py-3 rounded-full font-bold text-sm hover:scale-[1.02] transition-all">Clear Filters</a>
    </div>
    <% } %>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
