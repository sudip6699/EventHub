<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.eventhub.model.Event,java.util.List" %>
<%@ page import="java.util.List, com.eventhub.model.Event" %>
<%-- dashboard.jsp — Logged-in user's main dashboard --%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<%
    String userName = (String) session.getAttribute("userName");
    List<Event> recentEvents = (List<Event>) request.getAttribute("recentEvents");
    List<Event> joinedEvents = (List<Event>) request.getAttribute("joinedEvents");
    int myEventCount = (request.getAttribute("myEventCount") != null) ? (int) request.getAttribute("myEventCount") : 0;
    int joinedCount = (request.getAttribute("joinedCount") != null) ? (int) request.getAttribute("joinedCount") : 0;
    int totalApproved = (request.getAttribute("totalApproved") != null) ? (int) request.getAttribute("totalApproved") : 0;
    int totalUsers = (request.getAttribute("totalUsers") != null) ? (int) request.getAttribute("totalUsers") : 0;
%>

<main class="page-transition">

    <!-- ===== HERO SECTION ===== -->
    <section class="max-w-7xl mx-auto px-6 pt-8">
        <div class="relative h-[350px] md:h-[450px] rounded-xl overflow-hidden shadow-lg">
            <img src="https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=1400&q=80"
                 alt="Events Hero" class="absolute inset-0 w-full h-full object-cover">
            <div class="absolute inset-0 bg-gradient-to-t from-background via-background/60 to-transparent"></div>
            <div class="absolute bottom-0 left-0 p-8 md:p-12 z-10">
                <h1 class="text-4xl md:text-5xl font-bold font-headline text-on-surface mb-3">
                    Welcome back, <span class="text-primary"><%= userName %></span>
                </h1>
                <p class="text-on-surface-variant text-lg max-w-lg">Discover what's happening in your community today.</p>
                <div class="flex gap-3 mt-6">
                    <a href="${pageContext.request.contextPath}/events" class="primary-gradient text-on-primary px-6 py-3 rounded-full font-bold hover:scale-[1.02] shadow-lg transition-all flex items-center gap-2 text-sm">
                        <span class="material-symbols-outlined text-lg">explore</span> Explore Now
                    </a>
                    <a href="${pageContext.request.contextPath}/events/joined" class="bg-surface-container-lowest border border-outline-variant/30 text-on-surface px-6 py-3 rounded-full font-bold hover:shadow-md transition-all text-sm">
                        My Schedule
                    </a>
                </div>
            </div>
            <!-- Floating card -->
            <div class="hidden md:block absolute bottom-8 right-8 bg-tertiary-container/90 backdrop-blur-md rounded-xl p-5 shadow-lg transform rotate-3 hover:rotate-0 transition-transform z-10">
                <div class="text-on-surface font-bold font-headline text-lg"><%= totalApproved %></div>
                <div class="text-sm text-on-surface-variant">Active Events</div>
            </div>
        </div>
    </section>

    <!-- ===== STATS CARDS ===== -->
    <section class="max-w-7xl mx-auto px-6 -mt-8 relative z-20">
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div class="bg-surface-container-lowest rounded-xl p-5 shadow-sm border border-outline-variant/10 text-center">
                <span class="material-symbols-outlined text-primary text-2xl mb-2">event</span>
                <div class="text-2xl font-bold font-headline text-on-surface"><%= myEventCount %></div>
                <div class="text-xs text-on-surface-variant">My Events</div>
            </div>
            <div class="bg-surface-container-lowest rounded-xl p-5 shadow-sm border border-outline-variant/10 text-center">
                <span class="material-symbols-outlined text-secondary text-2xl mb-2">confirmation_number</span>
                <div class="text-2xl font-bold font-headline text-on-surface"><%= joinedCount %></div>
                <div class="text-xs text-on-surface-variant">Joined Events</div>
            </div>
            <div class="bg-surface-container-lowest rounded-xl p-5 shadow-sm border border-outline-variant/10 text-center">
                <span class="material-symbols-outlined text-tertiary text-2xl mb-2">celebration</span>
                <div class="text-2xl font-bold font-headline text-on-surface"><%= totalApproved %></div>
                <div class="text-xs text-on-surface-variant">Active Events</div>
            </div>
            <div class="bg-surface-container-lowest rounded-xl p-5 shadow-sm border border-outline-variant/10 text-center">
                <span class="material-symbols-outlined text-primary-container text-2xl mb-2">group</span>
                <div class="text-2xl font-bold font-headline text-on-surface"><%= totalUsers %></div>
                <div class="text-xs text-on-surface-variant">Total Users</div>
            </div>
        </div>
    </section>

    <!-- ===== CONTENT GRID ===== -->
    <section class="max-w-7xl mx-auto px-6 py-12">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">

            <!-- LEFT: Recent Events (8 columns) -->
            <div class="lg:col-span-8">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-xl font-bold font-headline text-on-surface">Recent Events</h2>
                    <a href="${pageContext.request.contextPath}/events" class="text-primary font-semibold text-sm hover:underline">View All</a>
                </div>
                <% if (recentEvents != null && !recentEvents.isEmpty()) { %>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <% for (Event event : recentEvents) { %>
                    <a href="${pageContext.request.contextPath}/events/detail?id=<%= event.getEventId() %>"
                       class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 p-5 hover:shadow-md hover:-translate-y-0.5 transition-all block">
                        <div class="flex items-start justify-between mb-3">
                            <span class="px-3 py-1 rounded-full text-xs font-bold bg-primary/10 text-primary"><%= event.getCategory() %></span>
                            <span class="text-xs text-on-surface-variant"><%= event.getEventDate() %></span>
                        </div>
                        <h3 class="font-bold font-headline text-on-surface mb-2 line-clamp-1"><%= event.getTitle() %></h3>
                        <p class="text-sm text-on-surface-variant line-clamp-2 mb-3"><%= event.getExcerpt() %></p>
                        <div class="flex items-center gap-2 text-xs text-on-surface-variant">
                            <span class="material-symbols-outlined text-sm">location_on</span> <%= event.getLocation() %>
                        </div>
                    </a>
                    <% } %>
                </div>
                <% } else { %>
                <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 p-10 text-center">
                    <span class="material-symbols-outlined text-4xl text-outline-variant mb-3">event_busy</span>
                    <p class="text-on-surface-variant">No events available yet. Be the first to create one!</p>
                </div>
                <% } %>
            </div>

            <!-- RIGHT: Schedule + Quick Actions (4 columns) -->
            <div class="lg:col-span-4 space-y-6">
                <!-- My Schedule / Joined Events -->
                <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 p-6">
                    <h3 class="font-bold font-headline text-on-surface mb-4 flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary">schedule</span> My Schedule
                    </h3>
                    <% if (joinedEvents != null && !joinedEvents.isEmpty()) { %>
                    <div class="space-y-3">
                        <% int maxShow = Math.min(joinedEvents.size(), 4);
                           for (int i = 0; i < maxShow; i++) {
                               Event je = joinedEvents.get(i); %>
                        <a href="${pageContext.request.contextPath}/events/detail?id=<%= je.getEventId() %>" class="flex items-center gap-3 p-3 rounded-lg hover:bg-surface-container-low transition-colors">
                            <div class="w-10 h-10 rounded-full bg-<%= i % 2 == 0 ? "primary" : "tertiary" %>/10 flex items-center justify-center shrink-0">
                                <span class="material-symbols-outlined text-<%= i % 2 == 0 ? "primary" : "tertiary" %> text-lg">event</span>
                            </div>
                            <div class="min-w-0">
                                <div class="text-sm font-semibold text-on-surface truncate"><%= je.getTitle() %></div>
                                <div class="text-xs text-on-surface-variant"><%= je.getEventDate() %></div>
                            </div>
                        </a>
                        <% } %>
                    </div>
                    <% } else { %>
                    <p class="text-sm text-on-surface-variant text-center py-4">No upcoming events on your schedule.</p>
                    <% } %>
                    <a href="${pageContext.request.contextPath}/events/joined" class="block mt-4 text-center text-sm text-primary font-semibold hover:underline">View All →</a>
                </div>

                <!-- Quick Actions -->
                <div class="primary-gradient rounded-xl p-6 text-white">
                    <h3 class="font-bold font-headline mb-3">🎉 Host an Event</h3>
                    <p class="text-sm opacity-90 mb-4">Share your passion with the community. Create an event in minutes.</p>
                    <a href="${pageContext.request.contextPath}/events/create" class="block bg-white text-primary text-center py-3 rounded-full font-bold text-sm hover:scale-[1.02] transition-transform">
                        Create Event
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== FAB (Floating Action Button) ===== -->
    <a href="${pageContext.request.contextPath}/events/create"
       class="fixed bottom-8 right-8 w-14 h-14 primary-gradient rounded-full shadow-lg flex items-center justify-center hover:scale-110 transition-transform z-30"
       title="Create Event">
        <span class="material-symbols-outlined text-white text-2xl">add</span>
    </a>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
