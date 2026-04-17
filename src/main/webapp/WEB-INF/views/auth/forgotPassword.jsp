<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="min-h-screen flex items-center justify-center p-6">
    <div class="w-full max-w-md bg-surface-container-lowest rounded-xl shadow-lg p-8 page-transition">
        <!-- Logo -->
        <div class="text-center mb-8">
            <div class="text-2xl font-black font-headline text-primary tracking-tighter mb-2">EventHub</div>
            <h2 class="text-2xl font-bold font-headline text-on-surface">Reset Password</h2>
            <p class="text-on-surface-variant text-sm mt-2">Enter your email and we'll send you instructions to reset your password.</p>
        </div>

        <!-- Success message -->
        <% String successMsg = (String) request.getAttribute("successMsg"); %>
        <% if (successMsg != null) { %>
        <div class="mb-6 p-4 bg-green-50 text-green-700 rounded-lg border border-green-200 text-sm font-medium flex items-center gap-2">
            <span class="material-symbols-outlined text-lg">check_circle</span>
            <%= successMsg %>
        </div>
        <% } %>

        <!-- Form -->
        <form action="${pageContext.request.contextPath}/forgot-password" method="POST" class="space-y-6">
            <div>
                <label class="block text-sm font-semibold mb-2" for="email">Email Address</label>
                <div class="relative">
                    <input type="email" id="email" name="email" required placeholder="your@email.com"
                           value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                           class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 pr-12 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
                    <span class="material-symbols-outlined absolute right-4 top-3.5 text-on-surface-variant">mail</span>
                </div>
            </div>
            <button type="submit" class="w-full py-4 primary-gradient text-on-primary font-bold rounded-full hover:scale-[1.02] shadow-lg transition-all">
                Send Reset Link
            </button>
        </form>

        <div class="mt-8 text-center">
            <a href="${pageContext.request.contextPath}/login" class="text-primary font-bold text-sm hover:underline underline-offset-4 flex items-center justify-center gap-1">
                <span class="material-symbols-outlined text-lg">arrow_back</span> Back to Login
            </a>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
