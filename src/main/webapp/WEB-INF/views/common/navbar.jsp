
<%
    // Get session attributes for display
    String navUserName = (session != null) ? (String) session.getAttribute("userName") : null;
    String navUserRole = (session != null) ? (String) session.getAttribute("userRole") : null;
    boolean navLoggedIn = (navUserName != null);
    boolean navIsAdmin = "admin".equals(navUserRole);
%>

<nav class="glass-nav sticky top-0 z-50 border-b border-outline-variant/20 shadow-sm">
    <div class="max-w-7xl mx-auto px-6 py-3 flex items-center justify-between">

        <!-- Logo -->
        <a href="${pageContext.request.contextPath}/home" class="flex items-center gap-2">
            <span class="text-2xl font-black font-headline text-primary tracking-tighter">EventHub</span>
        </a>

        <% if (navLoggedIn) { %>
        <!-- Logged-in Navigation -->
        <div class="hidden md:flex items-center gap-6">
            <a href="${pageContext.request.contextPath}/dashboard" class="text-sm font-semibold text-on-surface-variant hover:text-primary transition-colors">
                <span class="flex items-center gap-1"><span class="material-symbols-outlined text-lg">dashboard</span> Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/events" class="text-sm font-semibold text-on-surface-variant hover:text-primary transition-colors">
                <span class="flex items-center gap-1"><span class="material-symbols-outlined text-lg">explore</span> Discover</span>
            </a>
            <a href="${pageContext.request.contextPath}/events/create" class="text-sm font-semibold text-on-surface-variant hover:text-primary transition-colors">
                <span class="flex items-center gap-1"><span class="material-symbols-outlined text-lg">add_circle</span> Host</span>
            </a>
            <a href="${pageContext.request.contextPath}/events/joined" class="text-sm font-semibold text-on-surface-variant hover:text-primary transition-colors">
                <span class="flex items-center gap-1"><span class="material-symbols-outlined text-lg">confirmation_number</span> My Tickets</span>
            </a>
            <% if (navIsAdmin) { %>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="text-sm font-semibold text-tertiary hover:text-tertiary/80 transition-colors">
                <span class="flex items-center gap-1"><span class="material-symbols-outlined text-lg">admin_panel_settings</span> Admin</span>
            </a>
            <% } %>
        </div>

        <!-- Right side: Search + User menu -->
        <div class="flex items-center gap-4">
            <!-- Search bar -->
            <form action="${pageContext.request.contextPath}/events" method="GET" class="hidden lg:flex">
                <div class="relative">
                    <input type="text" name="keyword" placeholder="Search events..."
                           class="bg-surface-container-low border border-outline-variant/20 rounded-full px-4 py-2 pl-10 text-sm w-56 focus:outline-none focus:ring-2 focus:ring-primary/30 transition-all">
                    <span class="material-symbols-outlined absolute left-3 top-2 text-on-surface-variant text-lg">search</span>
                </div>
            </form>

            <!-- User avatar + dropdown -->
            <a href="${pageContext.request.contextPath}/profile" class="flex items-center gap-2 hover:opacity-80 transition-opacity">
                <div class="w-9 h-9 rounded-full primary-gradient flex items-center justify-center text-white font-bold text-sm">
                    <%= navUserName != null ? navUserName.charAt(0) : "U" %>
                </div>
                <span class="hidden md:inline text-sm font-semibold text-on-surface"><%= navUserName %></span>
            </a>

            <!-- Logout -->
            <a href="${pageContext.request.contextPath}/logout" class="text-on-surface-variant hover:text-primary transition-colors" title="Logout">
                <span class="material-symbols-outlined">logout</span>
            </a>
        </div>
        <% } else { %>
        <!-- Guest Navigation -->
        <div class="flex items-center gap-4">
            <a href="${pageContext.request.contextPath}/login" class="text-sm font-semibold text-on-surface-variant hover:text-primary transition-colors">Log In</a>
            <a href="${pageContext.request.contextPath}/register" class="primary-gradient text-on-primary px-5 py-2 rounded-full text-sm font-bold hover:scale-[1.02] transition-transform shadow-md">Register</a>
        </div>
        <% } %>
    </div>
</nav>
