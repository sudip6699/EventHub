<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
    <div class="text-center page-transition">
        <div class="text-8xl font-black font-headline text-primary mb-4">403</div>
        <h1 class="text-2xl font-bold font-headline text-on-surface mb-3">Access Denied</h1>
        <p class="text-on-surface-variant mb-8 max-w-md mx-auto">You don't have permission to access this page. If you believe this is an error, please contact the administrator.</p>
        <div class="flex justify-center gap-4">
            <a href="${pageContext.request.contextPath}/home" class="primary-gradient text-on-primary px-6 py-3 rounded-full font-bold text-sm hover:scale-[1.02] transition-all shadow-md">Go Home</a>
            <a href="javascript:history.back()" class="bg-surface-container border border-outline-variant/30 text-on-surface px-6 py-3 rounded-full font-bold text-sm hover:shadow-md transition-all">Go Back</a>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
