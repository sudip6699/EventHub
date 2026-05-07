<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.eventhub.model.AdminAction,java.util.List" %>
<%@ page import="java.util.List, com.eventhub.model.AdminAction" %>
<%-- actionLog.jsp — Admin action audit trail --%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<% List<AdminAction> actions = (List<AdminAction>) request.getAttribute("actions"); %>

<main class="page-transition max-w-5xl mx-auto px-6 py-10">
    <div class="mb-8">
        <h1 class="text-3xl font-bold font-headline text-on-surface mb-1">Action Log</h1>
        <p class="text-on-surface-variant text-sm">Complete audit trail of all administrative actions.</p>
    </div>

    <% if (actions != null && !actions.isEmpty()) { %>
    <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead class="bg-surface-container-low">
                    <tr>
                        <th class="px-6 py-4 text-left text-xs font-bold text-on-surface-variant uppercase tracking-wider">Timestamp</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-on-surface-variant uppercase tracking-wider">Admin</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-on-surface-variant uppercase tracking-wider">Action</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-on-surface-variant uppercase tracking-wider">Target</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-on-surface-variant uppercase tracking-wider">Notes</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-outline-variant/10">
                    <% for (AdminAction action : actions) { %>
                    <tr class="hover:bg-surface-container-low/50 transition-colors">
                        <td class="px-6 py-4 text-sm text-on-surface-variant whitespace-nowrap"><%= action.getActionAt() %></td>
                        <td class="px-6 py-4 text-sm font-semibold text-on-surface"><%= action.getAdminName() %></td>
                        <td class="px-6 py-4">
                            <span class="px-3 py-1 rounded-full text-xs font-bold
                                <% if (action.getActionType().contains("APPROVE")) { %>bg-green-100 text-green-700
                                <% } else if (action.getActionType().contains("REJECT") || action.getActionType().contains("DELETE")) { %>bg-red-100 text-red-700
                                <% } else { %>bg-blue-100 text-blue-700<% } %>">
                                <%= action.getActionType() %>
                            </span>
                        </td>
                        <td class="px-6 py-4 text-sm text-on-surface-variant">
                            <%= action.getTargetType() %> #<%= action.getTargetId() %>
                        </td>
                        <td class="px-6 py-4 text-sm text-on-surface-variant"><%= action.getNotes() != null ? action.getNotes() : "" %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } else { %>
    <div class="text-center py-20 bg-surface-container-lowest rounded-xl border border-outline-variant/15">
        <span class="material-symbols-outlined text-6xl text-outline-variant mb-4">history</span>
        <h3 class="text-xl font-bold font-headline text-on-surface mb-2">No actions logged yet</h3>
        <p class="text-on-surface-variant">Admin actions will appear here once moderation begins.</p>
    </div>
    <% } %>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
