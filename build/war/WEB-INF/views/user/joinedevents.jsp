<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.List, com.eventhub.model.Event" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<style>
.joined-wrap       { max-width: 960px; margin: 0 auto; padding: 40px 24px 60px; }
.page-header h1    { font-size: 1.9rem; color: #c0392b; font-weight: 700; margin-bottom: 6px; }
.page-header p     { color: #666; margin-bottom: 28px; }
.events-grid       { display: flex; flex-wrap: wrap; gap: 20px; }
.event-card        { flex: 1; min-width: 260px; max-width: 320px; background: #fff;
                     border: 1px solid #e8e8e8; border-radius: 12px; overflow: hidden; }
.event-card-top    { height: 6px; background: #27ae60; }
.event-card-body   { padding: 20px; }
.event-badge       { display: inline-block; background: #eafaf1; color: #27ae60;
                     font-size: 0.75rem; font-weight: 600; padding: 3px 10px;
                     border-radius: 20px; margin-bottom: 10px; }
.event-title       { font-size: 1rem; font-weight: 700; color: #333; margin-bottom: 8px; }
.event-meta        { font-size: 0.83rem; color: #777; margin-bottom: 6px; }
.btn-leave         { width: 100%; padding: 9px; background: #fdedec; color: #c0392b;
                     border: 1px solid #f5b7b1; border-radius: 6px; font-size: 0.85rem;
                     font-weight: 600; cursor: pointer; margin-top: 14px; }
.btn-leave:hover   { background: #f5b7b1; }
.btn-view          { display: block; text-align: center; padding: 9px; background: #f5f5f5;
                     color: #333; border: 1px solid #ddd; border-radius: 6px;
                     text-decoration: none; font-size: 0.85rem; font-weight: 600; margin-top: 8px; }
.btn-view:hover    { background: #eee; }
.empty-state       { text-align: center; padding: 60px 20px; color: #999; }
.empty-state h3    { font-size: 1.2rem; margin-bottom: 10px; color: #555; }
.btn-discover      { background: #c0392b; color: #fff; padding: 12px 28px; border-radius: 8px;
                     text-decoration: none; font-weight: 600; display: inline-block; margin-top: 16px; }
</style>

<main>
  <div class="joined-wrap">

    <div class="page-header">
     <h1>&#127915; My Tickets</h1>
      <p>Events you have joined. Leave an event if your plans change.</p>
    </div>

    <c:choose>
      <c:when test="${not empty joinedEvents}">
        <div class="events-grid">
          <c:forEach var="event" items="${joinedEvents}">
            <div class="event-card">
              <div class="event-card-top"></div>
              <div class="event-card-body">
                <span class="event-badge">${event.category}</span>
                <div class="event-title">${event.title}</div>
                <div class="event-meta">&#128197; <fmt:formatDate value="${event.eventDate}" pattern="dd MMM yyyy"/></div>
                <div class="event-meta">&#128205; ${event.location}</div>
                <div class="event-meta">&#128101; ${event.participantCount} joined</div>

                <a href="${pageContext.request.contextPath}/events/detail?id=${event.eventId}" class="btn-view">&#128065; View Details</a>

                <form action="${pageContext.request.contextPath}/events/join" method="post">
                  <input type="hidden" name="action" value="leave"/>
                  <input type="hidden" name="eventId" value="${event.eventId}"/>
                  <button type="submit" class="btn-leave"
                          onclick="return confirm('Leave this event?')">&#10060; Leave Event</button>
                </form>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:when>
      <c:otherwise>
        <div class="empty-state">
<div style="font-size:3rem;margin-bottom:12px;">&#127915;</div>
          <h3>No tickets yet</h3>
          <p>You haven't joined any events yet. Discover events and start joining!</p>
          <a href="${pageContext.request.contextPath}/events" class="btn-discover">&#128269; Discover Events</a>
        </div>
      </c:otherwise>
    </c:choose>

  </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>