<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<div class="min-h-screen flex items-center justify-center p-6">
    <div class="text-center page-transition">
        <div class="text-8xl font-black font-headline text-primary mb-4">404</div>
        <h1 class="text-2xl font-bold font-headline text-on-surface mb-3">Page Not Found</h1>
        <p class="text-on-surface-variant mb-8 max-w-md mx-auto">The page you're looking for doesn't exist or has been moved. Let's get you back on track.</p>
        <div class="flex justify-center gap-4">
            <a href="${pageContext.request.contextPath}/home" class="primary-gradient text-on-primary px-6 py-3 rounded-full font-bold text-sm hover:scale-[1.02] transition-all shadow-md">Go Home</a>
            <a href="${pageContext.request.contextPath}/events" class="bg-surface-container border border-outline-variant/30 text-on-surface px-6 py-3 rounded-full font-bold text-sm hover:shadow-md transition-all">Browse Events</a>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
