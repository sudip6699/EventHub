<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.eventhub.model.Event,java.util.List" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<%
    Event event = (Event) request.getAttribute("event");
    int participantCount = (request.getAttribute("participantCount") != null) ? (int) request.getAttribute("participantCount") : 0;
    boolean isJoined = (request.getAttribute("isJoined") != null) ? (boolean) request.getAttribute("isJoined") : false;
    boolean isOwner  = (request.getAttribute("isOwner")  != null) ? (boolean) request.getAttribute("isOwner")  : false;
    boolean isLoggedIn = (session != null && session.getAttribute("userId") != null);
    boolean isFull   = (event.getMaxParticipants() > 0 && participantCount >= event.getMaxParticipants());
    boolean isPaid   = event.isPaid();
    double  price    = event.getTicketPrice();
    String  ctx      = request.getContextPath();
%>

<style>
/* Payment Modal */
.modal-overlay {
    display:none; position:fixed; inset:0; background:rgba(0,0,0,0.5);
    z-index:1000; align-items:center; justify-content:center;
}
.modal-overlay.active { display:flex; }
.modal-box {
    background:white; border-radius:20px; padding:36px;
    max-width:480px; width:90%; box-shadow:0 24px 80px rgba(0,0,0,0.2);
    animation:slideUp .3s ease;
}
@keyframes slideUp { from{transform:translateY(30px);opacity:0} to{transform:translateY(0);opacity:1} }
.modal-title { font-size:20px; font-weight:800; color:#3E2000; margin-bottom:6px; }
.modal-price { font-size:32px; font-weight:800; color:#c0392b; margin-bottom:20px; }
.pay-methods { display:flex; gap:12px; margin-bottom:24px; }
.pay-opt {
    flex:1; border:2px solid #e0e0e0; border-radius:14px;
    padding:16px 12px; text-align:center; cursor:pointer; transition:all .2s;
    background:#fafafa;
}
.pay-opt:hover { border-color:#c0392b; }
.pay-opt.selected { border-color:#c0392b; background:#fdedec; }
.pay-opt img { height:40px; object-fit:contain; margin:0 auto 8px; display:block; }
.pay-opt span { font-size:13px; font-weight:700; color:#444; display:block; }
.btn-confirm {
    width:100%; padding:14px; background:#c0392b; color:white;
    border:none; border-radius:12px; font-size:16px; font-weight:700;
    cursor:pointer; transition:all .2s; margin-bottom:10px;
}
.btn-confirm:hover { background:#a93226; }
.btn-cancel-pay {
    width:100%; padding:12px; background:#f5f5f5; color:#666;
    border:1px solid #ddd; border-radius:12px; font-size:14px; font-weight:600;
    cursor:pointer; transition:all .2s;
}
.btn-cancel-pay:hover { background:#eee; }
.pay-note { font-size:12px; color:#999; text-align:center; margin-top:12px; }
</style>

<main class="page-transition max-w-4xl mx-auto px-6 py-10">

    <!-- Back button -->
    <a href="<%= ctx %>/events" class="inline-flex items-center gap-1 text-sm text-on-surface-variant hover:text-primary transition-colors mb-6">
        <span class="material-symbols-outlined text-lg">arrow_back</span> Back to Events
    </a>

    <!-- Event Card -->
    <div class="bg-surface-container-lowest rounded-xl border border-outline-variant/15 shadow-sm overflow-hidden">

        <!-- Cover image or color strip -->
        <% if (event.getImagePath() != null && !event.getImagePath().isEmpty()) { %>
        <div style="height:280px;overflow:hidden;">
            <img src="<%= ctx %>/<%= event.getImagePath() %>" alt="<%= event.getTitle() %>"
                 style="width:100%;height:100%;object-fit:cover;">
        </div>
        <% } else { %>
        <div class="h-3 primary-gradient"></div>
        <% } %>

        <div class="p-8 md:p-10">
            <!-- Status + Category + Price badges -->
            <div class="flex flex-wrap gap-2 mb-4">
                <span class="px-3 py-1 rounded-full text-xs font-bold bg-primary/10 text-primary"><%= event.getCategory() %></span>
                <% if ("approved".equals(event.getStatus())) { %>
                <span class="px-3 py-1 rounded-full text-xs font-bold bg-green-100 text-green-700">✓ Approved</span>
                <% } else if ("pending".equals(event.getStatus())) { %>
                <span class="px-3 py-1 rounded-full text-xs font-bold bg-yellow-100 text-yellow-700">⏳ Pending Review</span>
                <% } else { %>
                <span class="px-3 py-1 rounded-full text-xs font-bold bg-red-100 text-red-700">✕ Rejected</span>
                <% } %>
                <% if (isPaid) { %>
                <span class="px-3 py-1 rounded-full text-xs font-bold bg-red-100 text-red-700">💰 Rs. <%= (int)price %></span>
                <% } else { %>
                <span class="px-3 py-1 rounded-full text-xs font-bold bg-green-100 text-green-700">🆓 Free</span>
                <% } %>
            </div>

            <!-- Title -->
            <h1 class="text-3xl font-bold font-headline text-on-surface mb-4"><%= event.getTitle() %></h1>

            <!-- Organizer -->
            <% if (event.getOrganizerName() != null) { %>
            <div class="flex items-center gap-3 mb-6">
                <div class="w-10 h-10 rounded-full primary-gradient flex items-center justify-center text-white font-bold">
                    <%= event.getOrganizerName().charAt(0) %>
                </div>
                <div>
                    <div class="text-sm font-semibold text-on-surface"><%= event.getOrganizerName() %></div>
                    <div class="text-xs text-on-surface-variant">Event Organizer</div>
                </div>
            </div>
            <% } %>

            <!-- Event details grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8 p-5 bg-surface-container-low rounded-xl">
                <div class="flex items-center gap-3">
                    <span class="material-symbols-outlined text-primary">calendar_today</span>
                    <div>
                        <div class="text-xs text-on-surface-variant">Date</div>
                        <div class="font-semibold text-on-surface"><%= event.getEventDate() %></div>
                    </div>
                </div>
                <div class="flex items-center gap-3">
                    <span class="material-symbols-outlined text-primary">schedule</span>
                    <div>
                        <div class="text-xs text-on-surface-variant">Time</div>
                        <div class="font-semibold text-on-surface"><%= event.getEventTime() != null ? event.getEventTime() : "TBA" %></div>
                    </div>
                </div>
                <div class="flex items-center gap-3">
                    <span class="material-symbols-outlined text-primary">location_on</span>
                    <div>
                        <div class="text-xs text-on-surface-variant">Location</div>
                        <div class="font-semibold text-on-surface"><%= event.getLocation() %></div>
                    </div>
                </div>
                <div class="flex items-center gap-3">
                    <span class="material-symbols-outlined text-primary">group</span>
                    <div>
                        <div class="text-xs text-on-surface-variant">Participants</div>
                        <div class="font-semibold text-on-surface"><%= participantCount %><% if (event.getMaxParticipants() > 0) { %> / <%= event.getMaxParticipants() %><% } else { %> (Unlimited)<% } %></div>
                    </div>
                </div>
            </div>

            <!-- Capacity bar -->
            <% if (event.getMaxParticipants() > 0) { %>
            <div class="mb-8">
                <div class="flex justify-between text-sm mb-1">
                    <span class="text-on-surface-variant">Capacity</span>
                    <span class="font-semibold text-on-surface"><%= Math.round((double) participantCount / event.getMaxParticipants() * 100) %>%</span>
                </div>
                <div class="w-full h-2 bg-surface-container rounded-full overflow-hidden">
                    <div class="h-full primary-gradient rounded-full transition-all" style="width: <%= Math.min(100, Math.round((double) participantCount / event.getMaxParticipants() * 100)) %>%"></div>
                </div>
            </div>
            <% } %>

            <!-- Description -->
            <div class="mb-8">
                <h2 class="text-lg font-bold font-headline text-on-surface mb-3">About This Event</h2>
                <p class="text-on-surface-variant leading-relaxed whitespace-pre-line"><%= event.getDescription() %></p>
            </div>

            <!-- Action buttons -->
            <div class="flex flex-wrap gap-3">
                <% if (isLoggedIn && "approved".equals(event.getStatus())) { %>
                    <% if (isOwner) { %>
                    <a href="<%= ctx %>/events/edit?id=<%= event.getEventId() %>"
                       class="px-6 py-3 bg-surface-container border border-outline-variant/30 rounded-full font-bold text-sm hover:shadow-md transition-all flex items-center gap-2">
                        <span class="material-symbols-outlined text-lg">edit</span> Edit Event
                    </a>
                    <% } else if (isJoined) { %>
                    <form action="<%= ctx %>/participants/leave" method="POST">
                        <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                        <button type="submit" class="px-6 py-3 bg-red-50 text-red-700 border border-red-200 rounded-full font-bold text-sm hover:bg-red-100 transition-all flex items-center gap-2">
                            <span class="material-symbols-outlined text-lg">event_busy</span> Leave Event
                        </button>
                    </form>
                    <% } else if (!isFull) { %>
                        <% if (isPaid) { %>
                        <!-- PAID: show payment modal first -->
                        <button onclick="openPaymentModal()" class="px-8 py-3 primary-gradient text-on-primary rounded-full font-bold text-sm hover:scale-[1.02] shadow-lg transition-all flex items-center gap-2">
                            <span class="material-symbols-outlined text-lg">payment</span> Pay & Join — Rs. <%= (int)price %>
                        </button>
                        <!-- Hidden join form submitted after payment -->
                        <form id="joinForm" action="<%= ctx %>/participants/join" method="POST" style="display:none;">
                            <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                            <input type="hidden" name="paymentMethod" id="selectedPaymentMethod" value="">
                        </form>
                        <% } else { %>
                        <!-- FREE: join directly -->
                        <form action="<%= ctx %>/participants/join" method="POST">
                            <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                            <button type="submit" class="px-8 py-3 primary-gradient text-on-primary rounded-full font-bold text-sm hover:scale-[1.02] shadow-lg transition-all flex items-center gap-2">
                                <span class="material-symbols-outlined text-lg">event_available</span> Join Event — Free
                            </button>
                        </form>
                        <% } %>
                    <% } else { %>
                    <button disabled class="px-8 py-3 bg-surface-container text-on-surface-variant rounded-full font-bold text-sm cursor-not-allowed opacity-60">
                        Event Full
                    </button>
                    <% } %>
                <% } else if (!isLoggedIn) { %>
                <a href="<%= ctx %>/login" class="px-8 py-3 primary-gradient text-on-primary rounded-full font-bold text-sm hover:scale-[1.02] shadow-lg transition-all">
                    Login to Join
                </a>
                <% } %>
            </div>
        </div>
    </div>
</main>

<!-- ── PAYMENT MODAL ── -->
<div class="modal-overlay" id="paymentModal">
    <div class="modal-box">
        <div class="modal-title">Complete Payment</div>
        <div style="color:#666;font-size:14px;margin-bottom:12px;"><%= event.getTitle() %></div>
        <div class="modal-price">Rs. <%= (int)price %></div>

        <div style="font-size:13px;font-weight:700;color:#444;margin-bottom:10px;">Select Payment Method</div>
        <div class="pay-methods">
            <div class="pay-opt" id="opt-esewa" onclick="selectPayment('esewa')">
                <img src="<%= ctx %>/images/esewa.jpg" alt="eSewa">
                <span>eSewa</span>
            </div>
            <div class="pay-opt" id="opt-khalti" onclick="selectPayment('khalti')">
                <img src="<%= ctx %>/images/khalti.jpg" alt="Khalti">
                <span>Khalti</span>
            </div>
        </div>

        <button class="btn-confirm" id="confirmBtn" onclick="confirmPayment()" disabled
                style="opacity:0.5;cursor:not-allowed;">
            ✓ Confirm Payment — Rs. <%= (int)price %>
        </button>
        <button class="btn-cancel-pay" onclick="closePaymentModal()">Cancel</button>
        <div class="pay-note">🔒 Secure simulated payment for demo purposes</div>
    </div>
</div>

<script>
let selectedMethod = null;

function openPaymentModal() {
    document.getElementById('paymentModal').classList.add('active');
}

function closePaymentModal() {
    document.getElementById('paymentModal').classList.remove('active');
    selectedMethod = null;
    document.querySelectorAll('.pay-opt').forEach(o => o.classList.remove('selected'));
    const btn = document.getElementById('confirmBtn');
    btn.disabled = true;
    btn.style.opacity = '0.5';
    btn.style.cursor = 'not-allowed';
}

function selectPayment(method) {
    selectedMethod = method;
    document.querySelectorAll('.pay-opt').forEach(o => o.classList.remove('selected'));
    document.getElementById('opt-' + method).classList.add('selected');
    const btn = document.getElementById('confirmBtn');
    btn.disabled = false;
    btn.style.opacity = '1';
    btn.style.cursor = 'pointer';
}

function confirmPayment() {
    if (!selectedMethod) return;
    document.getElementById('selectedPaymentMethod').value = selectedMethod;
    document.getElementById('confirmBtn').textContent = 'Processing...';
    document.getElementById('confirmBtn').disabled = true;
    setTimeout(() => {
        document.getElementById('joinForm').submit();
    }, 1200);
}

// Close modal on overlay click
document.getElementById('paymentModal').addEventListener('click', function(e) {
    if (e.target === this) closePaymentModal();
});
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
