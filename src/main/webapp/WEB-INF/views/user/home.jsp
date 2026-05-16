<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String ctx = request.getContextPath();
    String role = (String) session.getAttribute("userRole");
    if (role != null) {
        if ("admin".equals(role)) {
            response.sendRedirect(ctx + "/admin/dashboard");
        } else {
            response.sendRedirect(ctx + "/dashboard");
        }
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventHub Nepal — Discover Local Events</title>
    <link href="https://fonts.googleapis.com/css2?family=Yatra+One&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --saffron: #FF6B00;
            --crimson: #C0392B;
            --gold:    #F0A500;
            --cream:   #FFFBF4;
            --warm:    #FFF3E0;
            --brown:   #3E2000;
            --muted:   #7A5C3E;
            --white:   #FFFFFF;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Plus Jakarta Sans',sans-serif; background:var(--cream); color:var(--brown); overflow-x:hidden; }

        /* NAV */
        nav {
            position:fixed; top:0; left:0; right:0; z-index:200;
            display:flex; justify-content:space-between; align-items:center;
            padding:14px 60px;
            background:rgba(255,251,244,0.95);
            backdrop-filter:blur(16px);
            border-bottom:2px solid var(--gold);
            box-shadow:0 2px 24px rgba(240,165,0,0.12);
        }
        .logo { font-family:'Yatra One',cursive; font-size:26px; color:var(--crimson); text-decoration:none; display:flex; align-items:center; gap:8px; }
        .nav-links { display:flex; gap:24px; align-items:center; }
        .nav-links a { color:var(--brown); text-decoration:none; font-size:14px; font-weight:600; transition:color .2s; }
        .nav-links a:hover { color:var(--saffron); }
        .btn-login { border:2px solid var(--crimson); color:var(--crimson) !important; padding:8px 20px; border-radius:24px; font-weight:700 !important; transition:all .2s; }
        .btn-login:hover { background:var(--crimson); color:white !important; }
        .btn-register { background:var(--saffron); color:white !important; padding:10px 22px; border-radius:24px; font-weight:700 !important; box-shadow:0 4px 16px rgba(255,107,0,.3); transition:all .2s; }
        .btn-register:hover { background:var(--crimson); transform:translateY(-1px); }

        /* HERO */
        .hero {
            min-height:100vh; display:grid; grid-template-columns:1fr 1fr;
            align-items:center; gap:60px; padding:110px 60px 80px;
            background:linear-gradient(135deg, #FFFBF4 0%, #FFE8C8 60%, #FFD4A8 100%);
            position:relative; overflow:hidden;
        }
        .hero::before {
            content:''; position:absolute; width:500px; height:500px;
            background:radial-gradient(circle, rgba(240,165,0,.15) 0%, transparent 70%);
            top:-100px; right:-100px; border-radius:50%;
            animation:pulse 4s ease-in-out infinite;
        }
        @keyframes pulse { 0%,100%{transform:scale(1);opacity:1} 50%{transform:scale(1.1);opacity:.7} }
        .hero-left { position:relative; z-index:2; }
        .hero-badge {
            display:inline-flex; align-items:center; gap:8px;
            background:rgba(255,107,0,.1); border:1.5px solid rgba(255,107,0,.3);
            color:var(--saffron); padding:7px 16px; border-radius:20px;
            font-size:12px; font-weight:800; letter-spacing:.5px; text-transform:uppercase; margin-bottom:24px;
        }
        .hero h1 { font-family:'Yatra One',cursive; font-size:62px; line-height:1.1; color:var(--brown); margin-bottom:20px; }
        .hero h1 .s { color:var(--saffron); }
        .hero h1 .r { color:var(--crimson); }
        .hero-desc { font-size:18px; color:var(--muted); line-height:1.8; margin-bottom:36px; max-width:480px; }
        .hero-btns { display:flex; gap:14px; flex-wrap:wrap; margin-bottom:40px; }
        .btn-explore { background:var(--saffron); color:white; padding:14px 32px; border-radius:28px; text-decoration:none; font-size:15px; font-weight:700; box-shadow:0 6px 20px rgba(255,107,0,.35); transition:all .25s; display:inline-flex; align-items:center; gap:8px; }
        .btn-explore:hover { background:var(--crimson); transform:translateY(-2px); }
        .btn-host { background:white; color:var(--brown); padding:14px 32px; border-radius:28px; text-decoration:none; font-size:15px; font-weight:700; border:2px solid rgba(62,32,0,.15); transition:all .25s; display:inline-flex; align-items:center; gap:8px; }
        .btn-host:hover { border-color:var(--saffron); color:var(--saffron); transform:translateY(-2px); }
        .culture-pills { display:flex; flex-wrap:wrap; gap:10px; }
        .pill { background:white; border:1.5px solid rgba(240,165,0,.4); padding:7px 15px; border-radius:18px; font-size:12px; font-weight:600; color:var(--brown); box-shadow:0 2px 8px rgba(0,0,0,.06); }

        /* HERO IMAGE GRID */
        .hero-right { display:grid; grid-template-columns:1fr 1fr; grid-template-rows:260px 200px; gap:14px; position:relative; z-index:2; }
        .h-img { border-radius:18px; overflow:hidden; box-shadow:0 8px 28px rgba(0,0,0,.18); position:relative; cursor:pointer; }
        .h-img:first-child { grid-row:span 2; border-radius:22px; }
        .h-img img { width:100%; height:100%; object-fit:cover; transition:transform .5s; display:block; }
        .h-img:hover img { transform:scale(1.06); }
        .h-img-cap { position:absolute; bottom:0; left:0; right:0; background:linear-gradient(transparent, rgba(0,0,0,.65)); padding:20px 14px 14px; color:white; font-size:12px; font-weight:700; }

        /* STATS */
        .stats-bar { background:var(--brown); padding:28px 60px; display:flex; justify-content:center; gap:80px; flex-wrap:wrap; }
        .stat { text-align:center; }
        .stat-n { font-family:'Yatra One',cursive; font-size:36px; color:var(--gold); display:block; }
        .stat-l { font-size:12px; color:rgba(255,251,244,.6); margin-top:2px; }

        /* EVENTS */
        .events-sec { padding:90px 60px; background:var(--warm); }
        .sec-hdr { display:flex; justify-content:space-between; align-items:flex-end; margin-bottom:48px; }
        .sec-tag { color:var(--saffron); font-size:11px; font-weight:800; letter-spacing:2px; text-transform:uppercase; margin-bottom:8px; }
        .sec-title { font-family:'Yatra One',cursive; font-size:40px; color:var(--brown); margin-bottom:8px; }
        .sec-sub { color:var(--muted); font-size:16px; }
        .see-all { color:var(--saffron); text-decoration:none; font-weight:700; font-size:14px; border-bottom:2px solid var(--saffron); padding-bottom:2px; white-space:nowrap; }
        .events-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(300px,1fr)); gap:24px; }
        .ec { background:white; border-radius:20px; overflow:hidden; box-shadow:0 4px 20px rgba(0,0,0,.07); border:1.5px solid rgba(240,165,0,.12); transition:all .3s; }
        .ec:hover { transform:translateY(-6px); box-shadow:0 16px 48px rgba(255,107,0,.14); border-color:var(--gold); }
        .ec-img { height:200px; position:relative; overflow:hidden; }
        .ec-img img { width:100%; height:100%; object-fit:cover; transition:transform .4s; display:block; }
        .ec:hover .ec-img img { transform:scale(1.06); }
        .ec-cat { position:absolute; top:12px; left:12px; background:var(--saffron); color:white; padding:5px 12px; border-radius:12px; font-size:11px; font-weight:800; text-transform:uppercase; }
        .ec-price { position:absolute; top:12px; right:12px; background:var(--crimson); color:white; padding:5px 12px; border-radius:12px; font-size:11px; font-weight:800; }
        .ec-free { position:absolute; top:12px; right:12px; background:#27ae60; color:white; padding:5px 12px; border-radius:12px; font-size:11px; font-weight:800; }
        .ec-body { padding:18px 20px 20px; }
        .ec-title { font-size:16px; font-weight:800; color:var(--brown); margin-bottom:10px; line-height:1.3; }
        .ec-meta { display:flex; flex-direction:column; gap:5px; margin-bottom:12px; }
        .ec-meta span { font-size:12px; color:var(--muted); display:flex; align-items:center; gap:6px; }
        .ec-desc { font-size:13px; color:#999; line-height:1.5; margin-bottom:14px; }
        .ec-foot { display:flex; justify-content:space-between; align-items:center; border-top:1px solid rgba(240,165,0,.2); padding-top:12px; }
        .ec-spots { font-size:12px; color:var(--muted); }
        .btn-join { background:var(--saffron); color:white; padding:8px 18px; border-radius:18px; text-decoration:none; font-size:13px; font-weight:700; transition:all .2s; }
        .btn-join:hover { background:var(--crimson); }

        /* CULTURE */
        .culture-strip { padding:90px 60px; background:white; }
        .culture-grid { display:grid; grid-template-columns:1fr 1fr; gap:60px; align-items:center; max-width:1100px; margin:0 auto; }
        .c-imgs { display:grid; grid-template-columns:1fr 1fr; gap:14px; }
        .c-img { border-radius:16px; overflow:hidden; box-shadow:0 6px 24px rgba(0,0,0,.1); }
        .c-img img { width:100%; display:block; object-fit:cover; }
        .c-img:first-child { grid-column:span 2; }
        .c-img:first-child img { height:240px; }
        .c-img img { height:150px; }
        .c-feats { display:flex; flex-direction:column; gap:14px; margin-top:28px; }
        .c-feat { display:flex; gap:14px; align-items:flex-start; padding:14px 16px; background:var(--warm); border-radius:12px; border-left:4px solid var(--saffron); }
        .c-feat-icon { font-size:22px; flex-shrink:0; }
        .c-feat h4 { font-size:14px; font-weight:800; color:var(--brown); margin-bottom:4px; }
        .c-feat p { font-size:12px; color:var(--muted); }

        /* HOW */
        .how-sec { padding:90px 60px; background:var(--brown); }
        .how-sec .sec-tag { color:var(--gold); }
        .how-sec .sec-title { color:#FFFBF4; }
        .how-sec .sec-sub { color:rgba(255,251,244,.6); }
        .steps { display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:24px; margin-top:52px; }
        .step { background:rgba(255,255,255,.06); border:1px solid rgba(240,165,0,.2); border-radius:18px; padding:32px 24px; text-align:center; transition:all .3s; }
        .step:hover { background:rgba(255,107,0,.12); border-color:var(--saffron); transform:translateY(-4px); }
        .step-n { width:50px; height:50px; background:var(--saffron); border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:20px; font-weight:800; color:white; margin:0 auto 18px; }
        .step h3 { color:#FFFBF4; font-size:17px; font-weight:700; margin-bottom:8px; }
        .step p { color:rgba(255,251,244,.55); font-size:13px; line-height:1.6; }

        /* PAYMENT */
        .pay-sec { padding:90px 60px; background:var(--warm); text-align:center; }
        .pay-cards { display:flex; gap:28px; justify-content:center; flex-wrap:wrap; margin-top:48px; }
        .pay-card { background:white; border-radius:20px; padding:32px 44px; box-shadow:0 6px 28px rgba(0,0,0,.07); border:2px solid rgba(240,165,0,.15); transition:all .3s; min-width:220px; text-align:center; }
        .pay-card:hover { transform:translateY(-4px); border-color:var(--saffron); box-shadow:0 14px 40px rgba(255,107,0,.12); }
        .pay-logo-img { width:140px; height:60px; object-fit:contain; margin-bottom:16px; display:block; margin-left:auto; margin-right:auto; }
        .pay-logo-free { font-size:44px; margin-bottom:16px; display:block; }
        .pay-name { font-size:18px; font-weight:800; color:var(--brown); margin-bottom:6px; }
        .pay-desc { font-size:13px; color:var(--muted); line-height:1.6; }

        /* CTA */
        .cta-sec { padding:90px 60px; text-align:center; background:var(--saffron); position:relative; overflow:hidden; }
        .cta-sec h2 { font-family:'Yatra One',cursive; font-size:50px; color:white; margin-bottom:16px; }
        .cta-sec p { color:rgba(255,255,255,.85); font-size:18px; margin-bottom:36px; }
        .cta-btn { background:white; color:var(--saffron); padding:16px 44px; border-radius:28px; text-decoration:none; font-size:16px; font-weight:800; box-shadow:0 8px 28px rgba(0,0,0,.2); transition:all .25s; display:inline-block; }
        .cta-btn:hover { transform:translateY(-3px); }

        /* FOOTER */
        footer { background:var(--brown); padding:60px 60px 28px; }
        .foot-grid { display:grid; grid-template-columns:2fr 1fr 1fr 1fr; gap:48px; margin-bottom:48px; }
        .foot-logo { font-family:'Yatra One',cursive; font-size:26px; color:var(--gold); display:block; margin-bottom:10px; }
        .foot-brand p { color:rgba(255,251,244,.5); font-size:13px; line-height:1.8; }
        .foot-col h4 { color:var(--gold); font-size:11px; font-weight:800; letter-spacing:2px; text-transform:uppercase; margin-bottom:16px; }
        .foot-col a { display:block; color:rgba(255,251,244,.5); text-decoration:none; font-size:13px; margin-bottom:10px; transition:color .2s; }
        .foot-col a:hover { color:var(--gold); }
        .foot-bottom { border-top:1px solid rgba(255,251,244,.08); padding-top:24px; display:flex; justify-content:space-between; color:rgba(255,251,244,.3); font-size:12px; flex-wrap:wrap; gap:8px; }

        @media(max-width:900px) {
            nav { padding:12px 20px; }
            .hero { grid-template-columns:1fr; padding:90px 20px 60px; }
            .hero h1 { font-size:40px; }
            .hero-right { display:none; }
            .events-sec,.culture-strip,.how-sec,.pay-sec,.cta-sec { padding:60px 20px; }
            .culture-grid { grid-template-columns:1fr; }
            .foot-grid { grid-template-columns:1fr 1fr; }
            .stats-bar { gap:32px; padding:24px 20px; }
        }
    </style>
</head>
<body>

<!-- NAV -->
<nav>
    <a href="<%=ctx%>/home" class="logo">🪷 EventHub Nepal</a>
    <div class="nav-links">
        <a href="#events">Events</a>
        <a href="#culture">Culture</a>
        <a href="#how">How It Works</a>
        <a href="<%=ctx%>/login" class="btn-login">Log In</a>
        <a href="<%=ctx%>/register" class="btn-register">Join Free</a>
    </div>
</nav>

<!-- HERO -->
<section class="hero">
    <div class="hero-left">
        <div class="hero-badge">🇳🇵 Nepal's Community Event Platform</div>
        <h1>Discover<br><span class="s">Kathmandu's</span><br><span class="r">Living Culture</span></h1>
        <p class="hero-desc">From the prayer wheels of Bouddha Stupa to hiking the Himalayan trails — find events that connect you to Nepal's vibrant heartbeat.</p>
        <div class="hero-btns">
            <a href="#events" class="btn-explore">🎯 Explore Events</a>
            <a href="<%=ctx%>/register" class="btn-host">➕ Host an Event</a>
        </div>
        <div class="culture-pills">
            <span class="pill">🏛️ Bouddha Stupa</span>
            <span class="pill">🎪 Indra Jatra</span>
            <span class="pill">🍜 Newari Bhoj</span>
            <span class="pill">🦅 Bird Watching</span>
            <span class="pill">🏔️ Hiking</span>
            <span class="pill">🧘 Monastery Visit</span>
        </div>
    </div>
    <div class="hero-right">
        <div class="h-img">
            <img src="<%=ctx%>/images/bouddha.jpg" alt="Bouddhanath Stupa">
            <div class="h-img-cap">🏛️ Bouddhanath Stupa Events</div>
        </div>
        <div class="h-img">
            <img src="<%=ctx%>/images/jatra.jpg" alt="Jatra Festival">
            <div class="h-img-cap">🎪 Jatra Festivals</div>
        </div>
        <div class="h-img">
            <img src="<%=ctx%>/images/hiking.jpg" alt="Hiking Nepal">
            <div class="h-img-cap">🏔️ Himalayan Hikes</div>
        </div>
    </div>
</section>

<!-- STATS -->
<div class="stats-bar">
    <div class="stat"><span class="stat-n">12k+</span><span class="stat-l">Active Members</span></div>
    <div class="stat"><span class="stat-n">250+</span><span class="stat-l">Events Hosted</span></div>
    <div class="stat"><span class="stat-n">77</span><span class="stat-l">Districts Covered</span></div>
    <div class="stat"><span class="stat-n">98%</span><span class="stat-l">Happy Attendees</span></div>
</div>

<!-- EVENTS -->
<section class="events-sec" id="events">
    <div class="sec-hdr">
        <div>
            <div class="sec-tag">🔥 Featured Events</div>
            <h2 class="sec-title">Explore What's Happening</h2>
            <p class="sec-sub">Hand-picked events from across Nepal</p>
        </div>
        <a href="<%=ctx%>/login" class="see-all">View All Events →</a>
    </div>
    <div class="events-grid">

        <!-- Event 1 — DB ID 5 -->
        <div class="ec">
            <div class="ec-img">
                <img src="<%=ctx%>/images/bouddha.jpg" alt="Bouddha Stupa">
                <span class="ec-cat">Cultural</span>
                <span class="ec-free">FREE</span>
            </div>
            <div class="ec-body">
                <div class="ec-title">Morning Meditation Walk at Bouddha Stupa</div>
                <div class="ec-meta">
                    <span>📅 Every Sunday, 6:00 AM</span>
                    <span>📍 Bouddhanath, Kathmandu</span>
                </div>
                <div class="ec-desc">A peaceful morning walk around the sacred Bouddha Stupa with meditation, chanting and spiritual reflection.</div>
                <div class="ec-foot">
                    <span class="ec-spots">👥 50 spots</span>
                    <a href="<%=ctx%>/events/join?id=5" class="btn-join">Join Event →</a>
                </div>
            </div>
        </div>

        <!-- Event 2 — DB ID 6 -->
        <div class="ec">
            <div class="ec-img">
                <img src="<%=ctx%>/images/birdwatching.jpg" alt="Bird Watching">
                <span class="ec-cat">Nature</span>
                <span class="ec-price">Rs. 500</span>
            </div>
            <div class="ec-body">
                <div class="ec-title">Bird Watching Tour — Chitwan Jungle</div>
                <div class="ec-meta">
                    <span>📅 Sat, 30 May 2026, 5:30 AM</span>
                    <span>📍 Chitwan National Park</span>
                </div>
                <div class="ec-desc">Spot rare hornbills, peacocks, and 500+ bird species in the lush jungles of Chitwan with expert guides.</div>
                <div class="ec-foot">
                    <span class="ec-spots">👥 20 spots</span>
                    <a href="<%=ctx%>/events/join?id=6" class="btn-join">Join Event →</a>
                </div>
            </div>
        </div>

        <!-- Event 3 — DB ID 7 -->
        <div class="ec">
            <div class="ec-img">
                <img src="<%=ctx%>/images/hiking.jpg" alt="Hiking">
                <span class="ec-cat">Adventure</span>
                <span class="ec-price">Rs. 800</span>
            </div>
            <div class="ec-body">
                <div class="ec-title">Shivapuri Hill Trek — Sunrise Hike</div>
                <div class="ec-meta">
                    <span>📅 Thu, 5 Jun 2026, 4:00 AM</span>
                    <span>📍 Shivapuri National Park</span>
                </div>
                <div class="ec-desc">Trek through misty trails to Shivapuri peak for a breathtaking sunrise over the Himalayas.</div>
                <div class="ec-foot">
                    <span class="ec-spots">👥 15 spots</span>
                    <a href="<%=ctx%>/events/join?id=7" class="btn-join">Join Event →</a>
                </div>
            </div>
        </div>

        <!-- Event 4 — DB ID 8 -->
        <div class="ec">
            <div class="ec-img">
                <img src="<%=ctx%>/images/monastery.jpg" alt="Monastery">
                <span class="ec-cat">Spiritual</span>
                <span class="ec-price">Rs. 400</span>
            </div>
            <div class="ec-body">
                <div class="ec-title">A Day with the Monks — Monastery Experience</div>
                <div class="ec-meta">
                    <span>📅 Sun, 7 Jun 2026, 7:00 AM</span>
                    <span>📍 Kopan Monastery, Kathmandu</span>
                </div>
                <div class="ec-desc">Spend a day living like a monk — morning prayers, meditation sessions, and traditional lunch.</div>
                <div class="ec-foot">
                    <span class="ec-spots">👥 12 spots</span>
                    <a href="<%=ctx%>/events/join?id=8" class="btn-join">Join Event →</a>
                </div>
            </div>
        </div>

        <!-- Event 5 — DB ID 9 -->
        <div class="ec">
            <div class="ec-img">
                <img src="<%=ctx%>/images/comedy.jpg" alt="Comedy Show">
                <span class="ec-cat">Entertainment</span>
                <span class="ec-price">Rs. 600</span>
            </div>
            <div class="ec-body">
                <div class="ec-title">Kathmandu Comedy Festival 2026</div>
                <div class="ec-meta">
                    <span>📅 Wed, 10 Jun 2026, 7:00 PM</span>
                    <span>📍 City Hall, New Baneshwor</span>
                </div>
                <div class="ec-desc">Nepal's biggest stand-up comedy night featuring top comedians. Laugh the night away!</div>
                <div class="ec-foot">
                    <span class="ec-spots">👥 200 spots</span>
                    <a href="<%=ctx%>/events/join?id=9" class="btn-join">Join Event →</a>
                </div>
            </div>
        </div>

        <!-- Event 6 — DB ID 10 -->
        <div class="ec">
            <div class="ec-img">
                <img src="<%=ctx%>/images/indrajatra.jpg" alt="Indra Jatra">
                <span class="ec-cat">Festival</span>
                <span class="ec-free">FREE</span>
            </div>
            <div class="ec-body">
                <div class="ec-title">Indra Jatra Cultural Procession Tour</div>
                <div class="ec-meta">
                    <span>📅 Mon, 15 Jun 2026, 3:00 PM</span>
                    <span>📍 Basantapur Durbar Square</span>
                </div>
                <div class="ec-desc">Experience Indra Jatra — masked dancers, chariot processions, and Kumari's appearance.</div>
                <div class="ec-foot">
                    <span class="ec-spots">👥 100 spots</span>
                    <a href="<%=ctx%>/events/join?id=10" class="btn-join">Join Event →</a>
                </div>
            </div>
        </div>

    </div>

    <c:if test="${not empty featuredEvents}">
        <div style="text-align:center;padding:40px 0 24px;color:var(--muted);font-size:14px;font-weight:600;">✨ Also from your community</div>
        <div class="events-grid">
            <c:forEach var="event" items="${featuredEvents}">
                <div class="ec">
                    <div class="ec-img" style="background:linear-gradient(135deg,#FFE0B2,#FFCCBC);display:flex;align-items:center;justify-content:center;font-size:64px;">
                        <c:choose>
                            <c:when test="${event.category eq 'Music'}">🎵</c:when>
                            <c:when test="${event.category eq 'Food'}">🍜</c:when>
                            <c:when test="${event.category eq 'Cultural'}">🪷</c:when>
                            <c:when test="${event.category eq 'Sports'}">🏃</c:when>
                            <c:when test="${event.category eq 'Tech'}">💻</c:when>
                            <c:otherwise>🎪</c:otherwise>
                        </c:choose>
                        <span class="ec-cat">${event.category}</span>
                    </div>
                    <div class="ec-body">
                        <div class="ec-title">${event.title}</div>
                        <div class="ec-meta">
                            <span>📅 <fmt:formatDate value="${event.eventDate}" pattern="EEE, dd MMM yyyy"/></span>
                            <span>📍 ${event.location}</span>
                        </div>
                        <div class="ec-desc">${event.excerpt}</div>
                        <div class="ec-foot">
                            <span class="ec-spots">👥 ${event.maxParticipants} spots</span>
                            <a href="<%=ctx%>/events/join?id=${event.id}" class="btn-join">Join Event →</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
</section>

<!-- CULTURE -->
<section class="culture-strip" id="culture">
    <div class="culture-grid">
        <div class="c-imgs">
            <div class="c-img"><img src="<%=ctx%>/images/jatra.jpg" alt="Jatra"></div>
            <div class="c-img"><img src="<%=ctx%>/images/indrajatra.jpg" alt="Indrajatra"></div>
            <div class="c-img"><img src="<%=ctx%>/images/pottery.jpg" alt="Pottery"></div>
        </div>
        <div class="c-text">
            <div class="sec-tag">🪷 Our Mission</div>
            <h2 class="sec-title">Celebrating Nepal's Living Heritage</h2>
            <p class="sec-sub">From the spinning prayer wheels of Bouddha to the thunderous drums of Indra Jatra — EventHub brings Nepal's cultural tapestry to your fingertips.</p>
            <div class="c-feats">
                <div class="c-feat">
                    <div class="c-feat-icon">🏛️</div>
                    <div>
                        <h4>Cultural Events</h4>
                        <p>Jatras, Newari feasts, religious ceremonies, and traditional festivals</p>
                    </div>
                </div>
                <div class="c-feat">
                    <div class="c-feat-icon">🏔️</div>
                    <div>
                        <h4>Adventure & Nature</h4>
                        <p>Hiking, bird watching, jungle safaris across Nepal's natural wonders</p>
                    </div>
                </div>
                <div class="c-feat">
                    <div class="c-feat-icon">💳</div>
                    <div>
                        <h4>Pay with eSewa & Khalti</h4>
                        <p>Secure local payments — no foreign cards needed</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- HOW IT WORKS -->
<section class="how-sec" id="how">
    <div class="sec-tag">Simple Process</div>
    <h2 class="sec-title" style="color:#FFFBF4;">How It Works</h2>
    <p class="sec-sub">Get started in under 2 minutes</p>
    <div class="steps">
        <div class="step">
            <div class="step-n">1</div>
            <h3>Create Account</h3>
            <p>Sign up free. No credit card required. Just name and email.</p>
        </div>
        <div class="step">
            <div class="step-n">2</div>
            <h3>Discover Events</h3>
            <p>Browse cultural events, hikes, food festivals and more across Nepal.</p>
        </div>
        <div class="step">
            <div class="step-n">3</div>
            <h3>Book Your Spot</h3>
            <p>Join free events instantly or pay with eSewa / Khalti for paid events.</p>
        </div>
        <div class="step">
            <div class="step-n">4</div>
            <h3>Attend & Enjoy</h3>
            <p>Show your digital ticket and experience something unforgettable.</p>
        </div>
    </div>
</section>

<!-- PAYMENT -->
<section class="pay-sec" id="payment">
    <div class="sec-tag">Secure Payments</div>
    <h2 class="sec-title">Pay the Nepali Way</h2>
    <p class="sec-sub" style="margin:0 auto;">We support Nepal's most trusted payment platforms</p>
    <div class="pay-cards">
        <div class="pay-card">
            <img src="<%=ctx%>/images/esewa.jpg" alt="eSewa" class="pay-logo-img">
            <div class="pay-name">eSewa</div>
            <div class="pay-desc">Nepal's #1 digital wallet.<br>Instant & secure payments.</div>
        </div>
        <div class="pay-card">
            <img src="<%=ctx%>/images/khalti.jpg" alt="Khalti" class="pay-logo-img">
            <div class="pay-name">Khalti</div>
            <div class="pay-desc">Fast digital payments.<br>Trusted by millions in Nepal.</div>
        </div>
        <div class="pay-card">
            <span class="pay-logo-free">🆓</span>
            <div class="pay-name">Free Events</div>
            <div class="pay-desc">Many events are free.<br>Just register & attend!</div>
        </div>
    </div>
</section>

<!-- CTA -->
<section class="cta-sec">
    <h2>Join Nepal's Event Community</h2>
    <p>Thousands discovering amazing events every day. Don't miss out!</p>
    <a href="<%=ctx%>/register" class="cta-btn">🚀 Get Started Free</a>
</section>

<!-- FOOTER -->
<footer>
    <div class="foot-grid">
        <div class="foot-brand">
            <span class="foot-logo">🪷 EventHub Nepal</span>
            <p>Discover, create and join local events across Nepal.<br>Built with ❤️ for Nepal's vibrant community.</p>
        </div>
        <div class="foot-col">
            <h4>Explore</h4>
            <a href="<%=ctx%>/login">Browse Events</a>
            <a href="<%=ctx%>/register">Create Event</a>
            <a href="<%=ctx%>/login">My Tickets</a>
        </div>
        <div class="foot-col">
            <h4>Account</h4>
            <a href="<%=ctx%>/login">Login</a>
            <a href="<%=ctx%>/register">Register</a>
            <a href="<%=ctx%>/forgot-password">Reset Password</a>
        </div>
        <div class="foot-col">
            <h4>Connect</h4>
            <a href="#">📧 info@eventhub.com.np</a>
            <a href="#">📍 Kathmandu, Nepal</a>
            <a href="#">🐙 GitHub</a>
        </div>
    </div>
    <div class="foot-bottom">
        <span>© 2026 EventHub Nepal. All rights reserved.</span>
        <span>Made with 🪷 in Nepal 🇳🇵</span>
    </div>
</footer>

</body>
</html>
