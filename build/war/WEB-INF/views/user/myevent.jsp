<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.List, com.eventhub.model.Event" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Event> myEvents = (List<Event>) request.getAttribute("myEvents");
%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<style>
.myevents-wrap     { max-width: 960px; margin: 0 auto; padding: 40px 24px 60px; }
.page-header       { margin-bottom: 28px; }
.page-header h1    { font-size: 1.9rem; color: #c0392b; font-weight: 700; margin-bottom: 6px; }
.page-header p     { color: #666; }
.events-grid       { display: flex; flex-wrap: wrap; gap: 20px; }
.event-card        { flex: 1; min-width: 260px; max-width: 320px; background: #fff;
                     border: 1px solid #e8e8e8; border-radius: 12px; overflow: hidden; }
.event-card-top    { height: 6px; background: #c0392b; }
.event-card-body   { padding: 20px; }
.event-badge       { display: inline-block; background: #fdf4f3; color: #c0392b;
                     font-size: 0.75rem; font-weight: 600; padding: 3px 10px;
                     border-radius: 20px; margin-bottom: 10px; }
.event-title       { font-size: 1rem; font-weight: 700; color: #333; margin-bottom: 8px; }
.event-meta        { font-size: 0.83rem; color: #777; margin-bottom: 6px; }
.status-pending    { color: #e67e22; font-weight: 600; font-size: 0.82rem; }
.status-approved   { color: #27ae60; font-weight: 600; font-size: 0.82rem; }
.status-rejected   { color: #c0392b; font-weight: 600; font-size: 0.82rem; }
.card-actions      { display: flex; gap: 8px; margin-top: 14px; }
.btn-edit          { flex: 1; padding: 8px; background: #f5f5f5; color: #333; border: 1px solid #ddd;
                     border-radius: 6px; text-align: center; text-decoration: none; font-size: 0.85rem; font-weight: 600; }
.btn-delete        { flex: 1; padding: 8px; background: #fdedec; color: #c0392b; border: 1px solid #f5b7b1;
                     border-radius: 6px; text-align: center; text-decoration: none; font-size: 0.85rem; font-weight: 600; cursor: pointer; }
.btn-edit:hover    { background: #eee; }
.btn-delete:hover  { background: #f5b7b1; }
.empty-state       { text-align: center; padding: 60px 20px; color: #999; }
.empty-state h3    { font-size: 1.2rem; margin-bottom: 10px; color: #555; }
.btn-create        { background: #c0392b; color: #fff; padding: 12px 28px; border-radius: 8px;
                     text-decoration: none; font-weight: 600; display: inline-block; margin-top: 16px; }
.alert-ok          { background: #eafaf1; border: 1px solid #a9dfbf; color: #1e8449;
                     padding: 13px 16px; border-radius: 8px; margin-bottom: 20px; }
</style>

<main>
  <div class="myevents-wrap">

    <div class="page-header">
      <h1>&#128197; My Events</h1>
      <p>Events you have created. Manage, edit, or delete them here.</p>
    </div>

    <%-- Success message --%>
    <c:if test="${param.success == 'created'}">
      <div class="alert-ok">&#10003; Your event has been submitted for review!</div>
    </c:if>
    <c:if test="${param.success == 'deleted'}">
      <div class="alert-ok">&#10003; Event deleted successfully.</div>
    </c:if>

    <c:choose>
      <c:when test="${not empty myEvents}">
        <div class="events-grid">
          <c:forEach var="event" items="${myEvents}">
            <div class="event-card">
              <div class="event-card-top"></div>
              <div class="event-card-body">
                <span class="event-badge">${event.category}</span>
                <div class="event-title">${event.title}</div>
                <div class="event-meta">&#128197; <fmt:formatDate value="${event.eventDate}" pattern="dd MMM yyyy"/></div>
                <div class="event-meta">&#128205; ${event.location}</div>
                <div class="event-meta">
                  Status:
                  <span class="status-${event.status}">${event.status}</span>
                </div>
                <div class="card-actions">
                  <a href="${pageContext.request.contextPath}/events/edit?id=${event.eventId}" class="btn-edit">&#9998; Edit</a>
                  <form action="${pageContext.request.contextPath}/events/my" method="post" style="flex:1;">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="eventId" value="${event.eventId}"/>
                    <button type="submit" class="btn-delete"
                            onclick="return confirm('Delete this event?')">&#128465; Delete</button>
                  </form>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:when>
      <c:otherwise>
        <div class="empty-state">
          <div style="font-size:3rem;margin-bottom:12px;">&#128197;</div>
          <h3>No events yet</h3>
          <p>You haven't created any events. Start by hosting your first event!</p>
          <a href="${pageContext.request.contextPath}/events/create" class="btn-create">&#127775; Create Your First Event</a>
        </div>
      </c:otherwise>
    </c:choose>

  </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>