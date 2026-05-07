<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<style>
.about-wrap        { max-width: 960px; margin: 0 auto; padding: 0 24px 60px; }
.about-hero        { text-align: center; padding: 56px 20px 44px; }
.about-hero h1     { font-size: 2.4rem; color: #c0392b; margin-bottom: 12px; font-weight: 700; }
.about-hero p      { font-size: 1.05rem; color: #555; max-width: 600px; margin: 0 auto; line-height: 1.8; }
.section-card      { background: #fff; border: 1px solid #e8e8e8; border-left: 5px solid #c0392b; border-radius: 12px; padding: 30px 28px; margin-bottom: 30px; }
.section-card h2   { color: #c0392b; font-size: 1.35rem; margin-bottom: 14px; }
.section-card p    { color: #555; line-height: 1.85; margin-bottom: 10px; }
.values-row        { display: flex; gap: 20px; flex-wrap: wrap; margin-bottom: 30px; }
.value-box         { flex: 1; min-width: 200px; background: #fff; border: 1px solid #e8e8e8; border-radius: 12px; padding: 26px 20px; text-align: center; }
.value-box .icon   { font-size: 2.8rem; margin-bottom: 12px; display: block; }
.value-box h3      { font-size: 1rem; color: #333; margin-bottom: 8px; font-weight: 600; }
.value-box p       { font-size: 0.88rem; color: #666; line-height: 1.65; }
.how-box           { background: #fdf4f3; border-radius: 12px; padding: 36px 28px; margin-bottom: 30px; }
.how-box h2        { text-align: center; color: #333; font-size: 1.35rem; margin-bottom: 28px; }
.steps-row         { display: flex; gap: 24px; flex-wrap: wrap; }
.step-item         { flex: 1; min-width: 160px; text-align: center; }
.step-circle       { width: 50px; height: 50px; border-radius: 50%; background: #c0392b; color: #fff; font-size: 1.3rem; font-weight: 700; display: flex; align-items: center; justify-content: center; margin: 0 auto 14px; }
.step-item h3      { font-size: 0.97rem; color: #333; margin-bottom: 6px; }
.step-item p       { font-size: 0.85rem; color: #666; line-height: 1.65; }
.stats-row         { display: flex; gap: 16px; flex-wrap: wrap; margin-bottom: 36px; }
.stat-card         { flex: 1; min-width: 130px; background: #fff; border: 1px solid #e8e8e8; border-radius: 12px; padding: 22px 16px; text-align: center; }
.stat-card .num    { font-size: 2rem; font-weight: 700; color: #c0392b; }
.stat-card .lbl    { font-size: 0.83rem; color: #777; margin-top: 4px; }
.cta-box           { text-align: center; padding: 40px 20px; }
.cta-box h2        { font-size: 1.6rem; color: #333; margin-bottom: 10px; }
.cta-box p         { color: #666; margin-bottom: 24px; }
.btn-red           { background: #c0392b; color: #fff; padding: 12px 28px; border-radius: 8px; text-decoration: none; font-weight: 600; margin: 4px; display: inline-block; }
.btn-outline-red   { border: 2px solid #c0392b; color: #c0392b; padding: 11px 26px; border-radius: 8px; text-decoration: none; font-weight: 600; margin: 4px; display: inline-block; }
.btn-red:hover     { background: #a93226; }
.btn-outline-red:hover { background: #fdf4f3; }
@media (max-width: 600px) {
  .about-hero h1 { font-size: 1.8rem; }
  .values-row, .steps-row, .stats-row { flex-direction: column; }
}
</style>

<main>
  <div class="about-hero">
    <h1>&#127919; About EventHub</h1>
    <p>EventHub is a community-driven platform connecting people through local events, workshops,
       and cultural experiences — making it easy to discover, create, and join meaningful gatherings.</p>
  </div>

  <div class="about-wrap">

    <div class="section-card">
      <h2>&#127919; Our Mission</h2>
      <p>We believe community connection is essential to human well-being. EventHub was built to
         eliminate barriers between people and events by providing a free, accessible, and safe
         platform where anyone can share their passion, skills, or ideas with their local community.</p>
      <p>From cultural festivals in Kathmandu to coding workshops in Pokhara, EventHub empowers
         individuals to build communities — one event at a time.</p>
    </div>

    <h2 style="text-align:center;color:#333;margin-bottom:20px;font-size:1.35rem;">Our Core Values</h2>
    <div class="values-row">
      <div class="value-box">
        <span class="icon">&#129309;</span>
        <h3>Community First</h3>
        <p>Every feature is designed to strengthen community bonds and foster genuine human connection.</p>
      </div>
      <div class="value-box">
        <span class="icon">&#128737;</span>
        <h3>Trust &amp; Safety</h3>
        <p>All events are reviewed by our moderation team to ensure a safe experience for everyone.</p>
      </div>
      <div class="value-box">
        <span class="icon">&#127760;</span>
        <h3>Open Access</h3>
        <p>EventHub is completely free. Access to community events should never be limited by cost.</p>
      </div>
    </div>

    <div class="how-box">
      <h2>How EventHub Works</h2>
      <div class="steps-row">
        <div class="step-item">
          <div class="step-circle">1</div>
          <h3>Create an Account</h3>
          <p>Sign up for free and set up your profile in under a minute.</p>
        </div>
        <div class="step-item">
          <div class="step-circle">2</div>
          <h3>Discover or Create</h3>
          <p>Browse events near you or post your own for the community.</p>
        </div>
        <div class="step-item">
          <div class="step-circle">3</div>
          <h3>Connect &amp; Attend</h3>
          <p>Join events, meet new people, and build lasting connections.</p>
        </div>
      </div>
    </div>

    <div class="stats-row">
      <div class="stat-card"><div class="num">200+</div><div class="lbl">Events Created</div></div>
      <div class="stat-card"><div class="num">12k+</div><div class="lbl">Community Members</div></div>
      <div class="stat-card"><div class="num">6</div><div class="lbl">Event Categories</div></div>
      <div class="stat-card"><div class="num">50+</div><div class="lbl">Cities Covered</div></div>
    </div>

    <div class="cta-box">
      <h2>Ready to get involved?</h2>
      <p>Join thousands of people already connecting through EventHub.</p>
      <a href="${pageContext.request.contextPath}/register" class="btn-red">Create Free Account</a>
      <a href="${pageContext.request.contextPath}/contact" class="btn-outline-red">Contact Us</a>
    </div>

  </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />