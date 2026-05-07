<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<style>
.contact-hero      { text-align: center; padding: 50px 20px 30px; }
.contact-hero h1   { font-size: 2.2rem; color: #c0392b; margin-bottom: 10px; font-weight: 700; }
.contact-hero p    { color: #555; max-width: 540px; margin: 0 auto; line-height: 1.8; }
.contact-layout    { display: flex; gap: 28px; max-width: 960px; margin: 0 auto 60px; padding: 0 24px; flex-wrap: wrap; }
.form-card         { flex: 1.2; min-width: 280px; background: #fff; border: 1px solid #e8e8e8; border-radius: 12px; padding: 30px 28px; }
.form-card h2      { color: #333; font-size: 1.2rem; margin-bottom: 22px; font-weight: 600; }
.form-group        { margin-bottom: 18px; }
.form-group label  { display: block; font-size: 0.88rem; font-weight: 600; color: #444; margin-bottom: 6px; }
.form-group input,
.form-group select,
.form-group textarea { width: 100%; padding: 11px 14px; border: 1px solid #ddd; border-radius: 8px; font-size: 0.94rem; color: #333; background: #fafafa; box-sizing: border-box; transition: border-color 0.2s; }
.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus { border-color: #c0392b; outline: none; background: #fff; }
.form-group textarea { resize: vertical; }
.req               { color: #c0392b; }
.hint              { font-size: 0.78rem; color: #999; margin-top: 4px; display: block; }
.btn-send          { width: 100%; padding: 13px; background: #c0392b; color: #fff; border: none; border-radius: 8px; font-size: 1rem; font-weight: 600; cursor: pointer; }
.btn-send:hover    { background: #a93226; }
.alert             { padding: 13px 16px; border-radius: 8px; margin-bottom: 18px; font-size: 0.92rem; }
.alert-ok          { background: #eafaf1; border: 1px solid #a9dfbf; color: #1e8449; }
.alert-err         { background: #fdedec; border: 1px solid #f5b7b1; color: #c0392b; }
.info-col          { flex: 1; min-width: 240px; display: flex; flex-direction: column; gap: 20px; }
.info-card         { background: #fff; border: 1px solid #e8e8e8; border-radius: 12px; padding: 24px; }
.info-card h2      { color: #333; font-size: 1.1rem; margin-bottom: 18px; font-weight: 600; }
.info-row          { display: flex; align-items: flex-start; gap: 14px; margin-bottom: 16px; }
.info-icon         { font-size: 1.3rem; flex-shrink: 0; }
.info-row strong   { display: block; font-size: 0.88rem; color: #333; }
.info-row span     { font-size: 0.84rem; color: #666; }
details            { border-bottom: 1px solid #f0f0f0; padding: 10px 0; }
details:last-child { border-bottom: none; }
summary            { cursor: pointer; font-size: 0.88rem; font-weight: 600; color: #333; list-style: none; }
details p          { font-size: 0.85rem; color: #666; line-height: 1.7; margin-top: 8px; }
@media (max-width: 640px) {
  .contact-layout { flex-direction: column; }
  .contact-hero h1 { font-size: 1.8rem; }
}
</style>

<main>
  <div class="contact-hero">
    <h1>&#128140; Contact Us</h1>
    <p>Have a question or issue? Fill in the form and we'll get back to you as soon as possible.</p>
  </div>

  <div class="contact-layout">

    <div class="form-card">
      <h2>Send a Message</h2>

      <c:if test="${not empty success}">
        <div class="alert alert-ok">&#10003; ${success}</div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-err">&#9888; ${error}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/contact" method="post">

        <div class="form-group">
          <label for="name">Full Name <span class="req">*</span></label>
          <input type="text" id="name" name="name"
                 value="${not empty fName ? fName : ''}"
                 placeholder="e.g. Sudip Parajuli" required />
        </div>

        <div class="form-group">
          <label for="email">Email Address <span class="req">*</span></label>
          <input type="email" id="email" name="email"
                 value="${not empty fEmail ? fEmail : ''}"
                 placeholder="e.g. sudip@example.com" required />
        </div>

        <div class="form-group">
          <label for="subject">Subject <span class="req">*</span></label>
          <select id="subject" name="subject" required>
            <option value="" disabled <c:if test="${empty fSubject}">selected</c:if>>-- Select a subject --</option>
            <option value="General Inquiry" <c:if test="${fSubject == 'General Inquiry'}">selected</c:if>>General Inquiry</option>
            <option value="Report an Event" <c:if test="${fSubject == 'Report an Event'}">selected</c:if>>Report an Event</option>
            <option value="Account Issue"   <c:if test="${fSubject == 'Account Issue'}">selected</c:if>>Account Issue</option>
            <option value="Feature Request" <c:if test="${fSubject == 'Feature Request'}">selected</c:if>>Feature Request</option>
            <option value="Partnership"     <c:if test="${fSubject == 'Partnership'}">selected</c:if>>Partnership</option>
            <option value="Other"           <c:if test="${fSubject == 'Other'}">selected</c:if>>Other</option>
          </select>
        </div>

        <div class="form-group">
          <label for="message">Message <span class="req">*</span></label>
          <textarea id="message" name="message" rows="5"
                    placeholder="Write your message here..."
                    required>${not empty fMessage ? fMessage : ''}</textarea>
          <span class="hint">Minimum 10 characters</span>
        </div>

        <button type="submit" class="btn-send">&#128140; Send Message</button>
      </form>
    </div>

    <div class="info-col">
      <div class="info-card">
        <h2>Get in Touch</h2>
        <div class="info-row">
          <span class="info-icon">&#128205;</span>
          <div><strong>Address</strong><span>Kathmandu, Bagmati Province, Nepal</span></div>
        </div>
        <div class="info-row">
          <span class="info-icon">&#128140;</span>
          <div><strong>Email</strong><span>support@eventhub.com</span></div>
        </div>
        <div class="info-row">
          <span class="info-icon">&#128336;</span>
          <div><strong>Support Hours</strong><span>Sun – Fri: 9:00 AM – 6:00 PM NPT</span></div>
        </div>
        <div class="info-row">
          <span class="info-icon">&#128222;</span>
          <div><strong>Phone</strong><span>+977 01-4XXXXXX</span></div>
        </div>
      </div>

      <div class="info-card">
        <h2>Frequently Asked</h2>
        <details>
          <summary>Is EventHub free to use?</summary>
          <p>Yes! Signing up, posting events, and joining events are completely free.</p>
        </details>
        <details>
          <summary>How do I report an event?</summary>
          <p>Use "Report an Event" above or the report button on any event detail page.</p>
        </details>
        <details>
          <summary>Can I edit or delete my event?</summary>
          <p>Yes — go to "My Events" on your dashboard and click Edit or Delete.</p>
        </details>
        <details>
          <summary>How long does event approval take?</summary>
          <p>Events are typically approved within 12–24 hours of submission.</p>
        </details>
      </div>
    </div>
  </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />