<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.eventhub.model.Event,java.util.List" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<%
    List<Event> recentEvents = (List<Event>) request.getAttribute("recentEvents");
    int totalEvents = (request.getAttribute("totalEvents") != null) ? (int) request.getAttribute("totalEvents") : 0;
%>

<main class="page-transition">

    <!-- ===== HERO SECTION ===== -->
    <section class="max-w-7xl mx-auto px-6 py-16 md:py-24">
        <div class="grid grid-cols-1 md:grid-cols-12 gap-12 items-center">
            <!-- Left: Text content -->
            <div class="md:col-span-7">
                <h1 class="text-5xl md:text-6xl font-bold font-headline leading-tight mb-6 text-on-surface">
                    Discover Your City's<br>
                    <span class="italic text-primary">Kinetic Rhythm</span>
                </h1>
                <p class="text-lg text-on-surface-variant mb-8 max-w-xl leading-relaxed">
                    From art exhibitions to tech workshops, find events that ignite your passions. Connect with your community and create lasting memories.
                </p>
                <div class="flex flex-wrap gap-4">
                    <a href="${pageContext.request.contextPath}/events" class="primary-gradient text-on-primary px-8 py-4 rounded-full font-bold hover:scale-[1.02] shadow-lg transition-all flex items-center gap-2">
                        <span class="material-symbols-outlined">explore</span> Explore Events
                    </a>
                    <a href="${pageContext.request.contextPath}/register" class="bg-surface-container-lowest border-2 border-primary text-primary px-8 py-4 rounded-full font-bold hover:bg-primary hover:text-on-primary transition-all">
                        Get Started Free
                    </a>
                </div>
                <!-- Stats row -->
                <div class="flex gap-8 mt-10">
                    <div>
                        <div class="text-3xl font-bold font-headline text-primary"><%= totalEvents %>+</div>
                        <div class="text-sm text-on-surface-variant">Active Events</div>
                    </div>
                    <div>
                        <div class="text-3xl font-bold font-headline text-primary">12k+</div>
                        <div class="text-sm text-on-surface-variant">Community Members</div>
                    </div>
                    <div>
                        <div class="text-3xl font-bold font-headline text-primary">6</div>
                        <div class="text-sm text-on-surface-variant">Event Categories</div>
                    </div>
                </div>
            </div>
            <!-- Right: Hero image -->
            <div class="md:col-span-5 relative">
                <img src="https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?auto=format&fit=crop&w=600&q=80"
                     alt="Events" class="rounded-2xl border-8 border-white shadow-2xl w-full object-cover h-[400px]">
                <!-- Decorative blobs -->
                <div class="absolute -top-8 -left-8 w-32 h-32 bg-tertiary-container/30 rounded-full blur-2xl -z-10"></div>
                <div class="absolute -bottom-8 -right-8 w-40 h-40 bg-secondary-container/30 rounded-full blur-2xl -z-10"></div>
            </div>
        </div>
    </section>

    <!-- ===== WHAT WE OFFER ===== -->
    <section class="bg-surface-container-low py-20">
        <div class="max-w-7xl mx-auto px-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-16 items-center">
                <!-- Left: Image mosaic -->
                <div class="grid grid-cols-2 gap-4">
                    <img src="https://images.unsplash.com/photo-1475721027785-f74eccf877e2?auto=format&fit=crop&w=300&q=80"
                         alt="Workshop" class="rounded-xl w-full h-48 object-cover shadow-md col-span-2">
                    <img src="https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=300&q=80"
                         alt="Seminar" class="rounded-xl w-full h-40 object-cover shadow-md">
                    <img src="https://images.unsplash.com/photo-1523580494863-6f3031224c94?auto=format&fit=crop&w=300&q=80"
                         alt="Cultural" class="rounded-xl w-full h-40 object-cover shadow-md">
                </div>
                <!-- Right: Feature cards -->
                <div>
                    <h2 class="text-3xl font-bold font-headline mb-8 text-on-surface">What We Offer</h2>
                    <div class="space-y-6">
                        <div class="flex gap-4">
                            <div class="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center shrink-0">
                                <span class="material-symbols-outlined text-primary">event</span>
                            </div>
                            <div>
                                <h3 class="font-bold font-headline text-on-surface mb-1">Discover Events</h3>
                                <p class="text-sm text-on-surface-variant">Browse through workshops, seminars, meetups, cultural shows, and sports events near you.</p>
                            </div>
                        </div>
                        <div class="flex gap-4">
                            <div class="w-12 h-12 rounded-xl bg-secondary/10 flex items-center justify-center shrink-0">
                                <span class="material-symbols-outlined text-secondary">add_circle</span>
                            </div>
                            <div>
                                <h3 class="font-bold font-headline text-on-surface mb-1">Host Your Own</h3>
                                <p class="text-sm text-on-surface-variant">Create and manage events, set capacity limits, and track participants seamlessly.</p>
                            </div>
                        </div>
                        <div class="flex gap-4">
                            <div class="w-12 h-12 rounded-xl bg-tertiary/10 flex items-center justify-center shrink-0">
                                <span class="material-symbols-outlined text-tertiary">group</span>
                            </div>
                            <div>
                                <h3 class="font-bold font-headline text-on-surface mb-1">Build Community</h3>
                                <p class="text-sm text-on-surface-variant">Connect with like-minded people, join local gatherings, and grow your network.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== HOW IT WORKS ===== -->
    <section class="bg-white py-20">
        <div class="max-w-7xl mx-auto px-6 text-center">
            <h2 class="text-3xl font-bold font-headline mb-4 text-on-surface">How It Works</h2>
            <p class="text-on-surface-variant mb-12 max-w-lg mx-auto">Three simple steps to get started with EventHub.</p>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <!-- Step 1 -->
                <div class="bg-surface/50 backdrop-blur-md border border-outline-variant/20 rounded-xl p-8 shadow-sm hover:shadow-md transition-shadow">
                    <div class="w-14 h-14 rounded-full primary-gradient flex items-center justify-center mx-auto mb-6 text-white font-bold text-xl">1</div>
                    <h3 class="font-bold font-headline text-lg mb-3 text-on-surface">Create Account</h3>
                    <p class="text-sm text-on-surface-variant">Sign up in seconds with your email. It's completely free.</p>
                </div>
                <!-- Step 2 (staggered) -->
                <div class="bg-surface/50 backdrop-blur-md border border-outline-variant/20 rounded-xl p-8 shadow-sm hover:shadow-md transition-shadow md:mt-12">
                    <div class="w-14 h-14 rounded-full bg-tertiary flex items-center justify-center mx-auto mb-6 text-white font-bold text-xl">2</div>
                    <h3 class="font-bold font-headline text-lg mb-3 text-on-surface">Browse & Join</h3>
                    <p class="text-sm text-on-surface-variant">Search events by category, keyword, or location. Join with one click.</p>
                </div>
                <!-- Step 3 -->
                <div class="bg-surface/50 backdrop-blur-md border border-outline-variant/20 rounded-xl p-8 shadow-sm hover:shadow-md transition-shadow">
                    <div class="w-14 h-14 rounded-full bg-secondary flex items-center justify-center mx-auto mb-6 text-white font-bold text-xl">3</div>
                    <h3 class="font-bold font-headline text-lg mb-3 text-on-surface">Host & Share</h3>
                    <p class="text-sm text-on-surface-variant">Create your own events, set details and capacity, and share with the community.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== RECENT EVENTS PREVIEW ===== -->
    <% if (recentEvents != null && !recentEvents.isEmpty()) { %>
    <section class="max-w-7xl mx-auto px-6 py-20">
        <div class="flex justify-between items-center mb-10">
            <h2 class="text-3xl font-bold font-headline text-on-surface">Upcoming Events</h2>
            <a href="${pageContext.request.contextPath}/events" class="text-primary font-bold text-sm hover:underline flex items-center gap-1">
                View All <span class="material-symbols-outlined text-lg">arrow_forward</span>
            </a>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <% for (Event event : recentEvents) { %>
            <a href="${pageContext.request.contextPath}/events/detail?id=<%= event.getEventId() %>"
               class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 shadow-sm hover:shadow-lg hover:-translate-y-1 transition-all p-6 block">
                <!-- Category badge -->
                <span class="inline-block px-3 py-1 rounded-full text-xs font-bold bg-primary/10 text-primary mb-4"><%= event.getCategory() %></span>
                <h3 class="font-bold font-headline text-lg text-on-surface mb-2 line-clamp-2"><%= event.getTitle() %></h3>
                <p class="text-sm text-on-surface-variant mb-4 line-clamp-2"><%= event.getExcerpt() %></p>
                <div class="flex items-center gap-4 text-xs text-on-surface-variant">
                    <span class="flex items-center gap-1"><span class="material-symbols-outlined text-sm">calendar_today</span> <%= event.getEventDate() %></span>
                    <span class="flex items-center gap-1"><span class="material-symbols-outlined text-sm">location_on</span> <%= event.getLocation() %></span>
                </div>
            </a>
            <% } %>
        </div>
    </section>
    <% } %>

    <!-- ===== CTA SECTION ===== -->
    <section class="max-w-7xl mx-auto px-6 pb-20">
        <div class="primary-gradient rounded-3xl p-12 md:p-16 text-center text-white">
            <h2 class="text-3xl md:text-4xl font-bold font-headline mb-4">Ready to Get Started?</h2>
            <p class="text-lg opacity-90 mb-8 max-w-lg mx-auto">Join thousands of event enthusiasts. Create or discover events today.</p>
            <div class="flex flex-wrap justify-center gap-4">
                <a href="${pageContext.request.contextPath}/register" class="bg-white text-primary px-8 py-4 rounded-full font-bold hover:scale-[1.02] shadow-lg transition-all">
                    Join Now — It's Free
                </a>
                <a href="${pageContext.request.contextPath}/events" class="border-2 border-white text-white px-8 py-4 rounded-full font-bold hover:bg-white/10 transition-all">
                    Browse Events
                </a>
            </div>
        </div>
    </section>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
