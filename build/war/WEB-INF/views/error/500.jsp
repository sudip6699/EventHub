<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<div class="min-h-screen flex items-center justify-center p-6">
    <div class="text-center page-transition">
        <div class="text-8xl font-black font-headline text-primary mb-4">500</div>
        <h1 class="text-2xl font-bold font-headline text-on-surface mb-3">Server Error</h1>
        <p class="text-on-surface-variant mb-8 max-w-md mx-auto">Something went wrong on our end. Please try again later or contact support if the problem persists.</p>
        <div class="flex justify-center gap-4">
            <a href="${pageContext.request.contextPath}/home" class="primary-gradient text-on-primary px-6 py-3 rounded-full font-bold text-sm hover:scale-[1.02] transition-all shadow-md">Go Home</a>
            <a href="javascript:location.reload()" class="bg-surface-container border border-outline-variant/30 text-on-surface px-6 py-3 rounded-full font-bold text-sm hover:shadow-md transition-all">Retry</a>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
