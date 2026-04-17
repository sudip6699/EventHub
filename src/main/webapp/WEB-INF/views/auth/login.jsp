<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="relative min-h-screen flex items-center justify-center p-6 overflow-hidden">

<div class="relative min-h-screen flex items-center justify-center p-6 overflow-hidden">
    <!-- Decorative floating blobs -->
    <div class="fixed top-[10%] right-[5%] w-32 h-32 bg-secondary-container/30 rounded-full blur-2xl -z-10"></div>
    <div class="fixed bottom-[15%] left-[5%] w-48 h-48 bg-tertiary-container/20 rounded-full blur-3xl -z-10"></div>

    <div class="w-full max-w-[1100px] grid grid-cols-1 md:grid-cols-2 bg-surface-container-lowest rounded-xl shadow-[0_24px_48px_-4px_rgba(59,38,75,0.06)] overflow-hidden relative z-10 page-transition">

        <!-- Left Visual Panel — Hidden on mobile -->
        <div class="relative hidden md:flex flex-col justify-between p-12 bg-gray-900 text-white min-h-[600px] overflow-hidden">
            <!-- Background image with gradient overlay -->
            <img src="https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=1000&q=80"
                 alt="Event" class="absolute inset-0 w-full h-full object-cover opacity-50 mix-blend-overlay">
            <div class="absolute inset-0 bg-gradient-to-br from-primary/70 via-primary/60 to-secondary/40 mix-blend-multiply"></div>

            <!-- Decorative orb -->
            <div class="absolute -bottom-20 -right-20 w-64 h-64 bg-secondary rounded-full blur-3xl opacity-40"></div>

            <!-- Content -->
            <div class="relative z-20">
                <div class="text-3xl font-black mb-8 tracking-tighter font-headline">EventHub</div>
                <h1 class="text-5xl font-bold font-headline leading-tight mb-4 text-white">
                    Experience <br><span class="text-tertiary-container italic">Kinetic</span> <br>Communities.
                </h1>
                <p class="text-lg opacity-90 font-light max-w-md">Join vibrant local gatherings, share unforgettable moments, and immerse yourself in the culture of your city.</p>
            </div>

            <!-- Stats chips -->
            <div class="relative z-20">
                <div class="flex gap-4 mb-8">
                    <div class="bg-white/20 backdrop-blur-md rounded-full px-4 py-2 flex items-center gap-2">
                        <span class="material-symbols-outlined text-sm">group</span>
                        <span class="text-sm font-bold">12k+ Active Users</span>
                    </div>
                    <div class="bg-white/20 backdrop-blur-md rounded-full px-4 py-2 flex items-center gap-2">
                        <span class="material-symbols-outlined text-sm">event</span>
                        <span class="text-sm font-bold">250 Events Today</span>
                    </div>
                </div>
                <div class="text-sm opacity-70">&copy; 2026 EventHub. Let's make memories.</div>
            </div>
        </div>

        <!-- Right Form Panel -->
        <div class="p-8 md:p-20 bg-surface-container-lowest flex flex-col justify-center">
            <div class="mb-10">
                <!-- Mobile logo -->
                <div class="md:hidden text-2xl font-black font-headline text-primary tracking-tighter mb-6">EventHub</div>
                <h2 class="text-3xl font-bold font-headline mb-2 text-on-surface">Welcome Back</h2>
                <p class="text-on-surface-variant">Please enter your details to sign in.</p>
            </div>

            <!-- Success message -->
            <% String success = request.getParameter("success"); %>
            <% if ("registered".equals(success)) { %>
            <div class="mb-6 p-4 bg-green-50 text-green-700 rounded-lg border border-green-200 text-sm font-medium flex items-center gap-2">
                <span class="material-symbols-outlined text-lg">check_circle</span>
                Account created successfully! Please log in.
            </div>
            <% } else if ("loggedout".equals(success)) { %>
            <div class="mb-6 p-4 bg-blue-50 text-blue-700 rounded-lg border border-blue-200 text-sm font-medium flex items-center gap-2">
                <span class="material-symbols-outlined text-lg">info</span>
                You have been logged out.
            </div>
            <% } %>

            <!-- Error message -->
            <% String errorMsg = (String) request.getAttribute("errorMsg"); %>
            <% if (errorMsg != null) { %>
            <div class="mb-6 p-4 bg-red-50 text-red-700 rounded-lg border border-red-200 text-sm font-medium flex items-center gap-2">
                <span class="material-symbols-outlined text-lg">error</span>
                <%= errorMsg %>
            </div>
            <% } %>

            <!-- Auth error from filter redirect -->
            <% if ("auth".equals(request.getParameter("error"))) { %>
            <div class="mb-6 p-4 bg-yellow-50 text-yellow-700 rounded-lg border border-yellow-200 text-sm font-medium flex items-center gap-2">
                <span class="material-symbols-outlined text-lg">warning</span>
                Please log in to access that page.
            </div>
            <% } %>

            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/login" method="POST" class="space-y-6">
                <!-- Email field -->
                <div>
                    <label class="block text-sm font-semibold mb-2" for="email">Email Address</label>
                    <div class="relative">
                        <input type="email" id="email" name="email"
                               value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : (request.getAttribute("savedEmail") != null ? request.getAttribute("savedEmail") : "") %>"
                               required placeholder="alex@example.com"
                               class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 pr-12 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
                        <span class="material-symbols-outlined absolute right-4 top-3.5 text-on-surface-variant">mail</span>
                    </div>
                </div>

                <!-- Password field -->
                <div>
                    <div class="flex justify-between items-center mb-2">
                        <label class="block text-sm font-semibold" for="password">Password</label>
                        <a href="${pageContext.request.contextPath}/forgot-password" class="text-sm text-primary font-semibold hover:underline">Forgot Password?</a>
                    </div>
                    <div class="relative">
                        <input type="password" id="password" name="password" required placeholder="••••••••"
                               class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 pr-12 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
                        <span class="material-symbols-outlined absolute right-4 top-3.5 text-on-surface-variant">lock</span>
                    </div>
                </div>

                <!-- Remember me checkbox -->
                <div class="flex items-center">
                    <input type="checkbox" id="remember" name="remember" class="w-4 h-4 text-primary rounded border-outline-variant focus:ring-primary">
                    <label for="remember" class="ml-2 text-sm text-on-surface-variant">Remember for 30 days</label>
                </div>

                <!-- Submit button -->
                <button type="submit" class="w-full py-4 primary-gradient text-on-primary font-bold rounded-full hover:scale-[1.02] shadow-lg transition-all">
                    Sign In
                </button>
            </form>

            <!-- Social login divider -->
            <div class="mt-8 flex items-center gap-4">
                <div class="flex-1 border-t border-outline-variant/30 border-dashed"></div>
                <div class="text-sm text-on-surface-variant font-medium">or continue with</div>
                <div class="flex-1 border-t border-outline-variant/30 border-dashed"></div>
            </div>

            <!-- Social buttons -->
            <div class="mt-6 grid grid-cols-2 gap-4">
                <button class="flex items-center justify-center gap-2 py-3 rounded-full bg-surface-container-low hover:bg-surface-container transition-colors text-sm font-bold border border-outline-variant/20">
                    <img src="https://www.svgrepo.com/show/475656/google-color.svg" class="w-5 h-5" alt="Google"> Google
                </button>
                <button class="flex items-center justify-center gap-2 py-3 rounded-full bg-surface-container-low hover:bg-surface-container transition-colors text-sm font-bold border border-outline-variant/20">
                    <span class="material-symbols-outlined text-xl">smartphone</span> Apple
                </button>
            </div>

            <!-- Register link -->
            <div class="mt-10 text-center">
                <span class="text-on-surface-variant text-sm">Don't have an account? </span>
                <a href="${pageContext.request.contextPath}/register" class="text-primary font-bold text-sm hover:underline underline-offset-4">Register Now</a>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
