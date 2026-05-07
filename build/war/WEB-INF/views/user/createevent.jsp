<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<style>
.create-wrap       { max-width: 760px; margin: 0 auto; padding: 40px 24px 60px; }
.create-wrap h1    { font-size: 1.9rem; color: #c0392b; margin-bottom: 6px; font-weight: 700; }
.create-wrap p     { color: #666; margin-bottom: 28px; }
.form-card         { background: #fff; border: 1px solid #e8e8e8; border-radius: 12px; padding: 32px; }
.form-group        { margin-bottom: 20px; }
.form-group label  { display: block; font-size: 0.88rem; font-weight: 600; color: #444; margin-bottom: 6px; }
.form-group input,
.form-group select,
.form-group textarea {
    width: 100%; padding: 11px 14px; border: 1px solid #ddd; border-radius: 8px;
    font-size: 0.94rem; color: #333; background: #fafafa; box-sizing: border-box; transition: border-color 0.2s;
}
.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus { border-color: #c0392b; outline: none; background: #fff; }
.form-group textarea       { resize: vertical; }
.form-row          { display: flex; gap: 16px; flex-wrap: wrap; }
.form-row .form-group { flex: 1; min-width: 200px; }
.req               { color: #c0392b; }
.hint              { font-size: 0.78rem; color: #999; margin-top: 4px; display: block; }
.btn-create        { background: #c0392b; color: #fff; padding: 13px 32px; border: none;
                     border-radius: 8px; font-size: 1rem; font-weight: 600; cursor: pointer; }
.btn-create:hover  { background: #a93226; }
.btn-cancel        { background: #f5f5f5; color: #555; padding: 13px 24px; border: 1px solid #ddd;
                     border-radius: 8px; font-size: 1rem; font-weight: 600; cursor: pointer;
                     text-decoration: none; margin-right: 12px; }
.btn-cancel:hover  { background: #eee; }
.alert-err         { background: #fdedec; border: 1px solid #f5b7b1; color: #c0392b;
                     padding: 13px 16px; border-radius: 8px; margin-bottom: 20px; }
.alert-ok          { background: #eafaf1; border: 1px solid #a9dfbf; color: #1e8449;
                     padding: 13px 16px; border-radius: 8px; margin-bottom: 20px; }
@media (max-width: 600px) { .form-row { flex-direction: column; } }
</style>

<main>
  <div class="create-wrap">
    <h1>&#127775; Host an Event</h1>
    <p>Share your passion with the community. Fill in the details below to create your event.</p>

    <div class="form-card">

      <c:if test="${not empty error}">
        <div class="alert-err">&#9888; ${error}</div>
      </c:if>
      <c:if test="${not empty success}">
        <div class="alert-ok">&#10003; ${success}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/events/create" method="post">

        <!-- Title -->
        <div class="form-group">
          <label for="title">Event Title <span class="req">*</span></label>
          <input type="text" id="title" name="title"
                 value="${not empty param.title ? param.title : ''}"
                 placeholder="e.g. Java Web Dev Workshop" required />
        </div>

        <!-- Description -->
        <div class="form-group">
          <label for="description">Description <span class="req">*</span></label>
          <textarea id="description" name="description" rows="4"
                    placeholder="Describe your event in detail..."
                    required>${not empty param.description ? param.description : ''}</textarea>
        </div>

        <!-- Date and Time -->
        <div class="form-row">
          <div class="form-group">
            <label for="eventDate">Date <span class="req">*</span></label>
            <input type="date" id="eventDate" name="eventDate" required />
          </div>
          <div class="form-group">
            <label for="eventTime">Time <span class="req">*</span></label>
            <input type="time" id="eventTime" name="eventTime" required />
          </div>
        </div>

        <!-- Location -->
        <div class="form-group">
          <label for="location">Location <span class="req">*</span></label>
          <input type="text" id="location" name="location"
                 value="${not empty param.location ? param.location : ''}"
                 placeholder="e.g. Room 301, IT Building, Kathmandu" required />
        </div>

        <!-- Category and Capacity -->
        <div class="form-row">
          <div class="form-group">
            <label for="category">Category <span class="req">*</span></label>
            <select id="category" name="category" required>
              <option value="" disabled selected>-- Select category --</option>
              <option value="Workshop">Workshop</option>
              <option value="Seminar">Seminar</option>
              <option value="Meetup">Meetup</option>
              <option value="Cultural">Cultural</option>
              <option value="Sports">Sports</option>
              <option value="Other">Other</option>
            </select>
          </div>
          <div class="form-group">
            <label for="maxParticipants">Max Participants</label>
            <input type="number" id="maxParticipants" name="maxParticipants"
                   min="1" placeholder="e.g. 50 (leave blank for unlimited)" />
            <span class="hint">Leave blank for unlimited capacity</span>
          </div>
        </div>

        <!-- Buttons -->
        <div style="margin-top: 10px;">
          <a href="${pageContext.request.contextPath}/dashboard" class="btn-cancel">Cancel</a>
          <button type="submit" class="btn-create">&#127775; Create Event</button>
        </div>

      </form>
    </div>
  </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>