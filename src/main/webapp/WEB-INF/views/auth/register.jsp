<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="relative min-h-screen flex items-center justify-center p-6 overflow-hidden">
    <!-- Decorative floating blobs -->
    <div class="fixed top-[20%] left-[8%] w-40 h-40 bg-tertiary-container/20 rounded-full blur-3xl -z-10"></div>
    <div class="fixed bottom-[10%] right-[5%] w-36 h-36 bg-primary-container/20 rounded-full blur-2xl -z-10"></div>

    <div class="w-full max-w-[1200px] grid grid-cols-1 lg:grid-cols-12 min-h-[700px] page-transition">

        <!-- Left Panel — Hidden on mobile (5/12 columns) -->
        <div class="hidden lg:flex lg:col-span-5 flex-col justify-center p-12 relative">
            <!-- Logo -->
            <div class="text-3xl font-black font-headline text-primary tracking-tighter mb-8">EventHub</div>

            <!-- Headline -->
            <h1 class="text-5xl font-bold font-headline leading-tight mb-6 text-on-surface">
                Discover <br><span class="italic bg-gradient-to-r from-primary to-primary-container bg-clip-text text-transparent">Cultural Wonders.</span>
            </h1>
            <p class="text-on-surface-variant text-lg leading-relaxed mb-10">
                Join a community of event enthusiasts. Create, discover, and participate in local events that bring people together.
            </p>

            <!-- Decorative image card -->
            <div class="relative">
                <img src="https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=500&q=80"
                     alt="Community Events" class="rounded-2xl border-4 border-white shadow-2xl w-full max-w-sm object-cover h-56">
                <div class="absolute -bottom-4 -right-4 bg-tertiary-container text-on-surface px-4 py-2 rounded-xl shadow-lg text-sm font-bold">
                    <span class="material-symbols-outlined text-sm align-middle">groups</span> 12,000+ Members
                </div>
            </div>
        </div>

        <!-- Right Panel — Registration Form (7/12 columns) -->
        <div class="lg:col-span-7 flex items-center justify-center">
            <div class="w-full max-w-lg bg-surface/80 backdrop-blur-md rounded-xl shadow-[0_24px_48px_-4px_rgba(59,38,75,0.06)] p-8 md:p-10">
                <!-- Mobile logo -->
                <div class="lg:hidden text-2xl font-black font-headline text-primary tracking-tighter mb-4">EventHub</div>

                <h2 class="text-2xl font-bold font-headline mb-2 text-on-surface">Join the community</h2>
                <p class="text-on-surface-variant text-sm mb-8">Create your free account and start exploring events.</p>

                <!-- Error message -->
                <% String errorMsg = (String) request.getAttribute("errorMsg"); %>
                <% if (errorMsg != null) { %>
                <div class="mb-6 p-4 bg-red-50 text-red-700 rounded-lg border border-red-200 text-sm font-medium flex items-center gap-2">
                    <span class="material-symbols-outlined text-lg">error</span>
                    <%= errorMsg %>
                </div>
                <% } %>

                <!-- Registration Form -->
                <form action="${pageContext.request.contextPath}/register" method="POST" class="space-y-5">
                    <!-- Full Name -->
                    <div>
                        <label class="block text-sm font-semibold mb-2" for="name">Full Name</label>
                        <div class="relative">
                            <input type="text" id="name" name="name"
                                   value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>"
                                   required placeholder="John Doe"
                                   class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 pr-12 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
                            <span class="material-symbols-outlined absolute right-4 top-3.5 text-on-surface-variant">person</span>
                        </div>
                    </div>

                    <!-- Email -->
                    <div>
                        <label class="block text-sm font-semibold mb-2" for="email">Email Address</label>
                        <div class="relative">
                            <input type="email" id="email" name="email"
                                   value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                                   required placeholder="john@example.com"
                                   class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 pr-12 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
                            <span class="material-symbols-outlined absolute right-4 top-3.5 text-on-surface-variant">mail</span>
                        </div>
                    </div>

                    <!-- Password + Confirm Password in grid -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-semibold mb-2" for="password">Password</label>
                            <div class="relative">
                                <input type="password" id="password" name="password" required placeholder="Min. 8 characters"
                                       class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 pr-12 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                                       onkeyup="checkStrength(this.value)">
                                <span class="material-symbols-outlined absolute right-4 top-3.5 text-on-surface-variant">lock</span>
                            </div>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold mb-2" for="confirmPassword">Confirm Password</label>
                            <div class="relative">
                                <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Repeat password"
                                       class="w-full bg-surface-container-low border border-outline-variant/30 rounded-lg px-4 py-3 pr-12 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all">
                                <span class="material-symbols-outlined absolute right-4 top-3.5 text-on-surface-variant">lock</span>
                            </div>
                        </div>
                    </div>

                    <!-- Password strength bar (3 segments) -->
                    <div class="flex gap-1" id="strengthBar">
                        <div class="h-1 flex-1 rounded-full bg-outline-variant/30 transition-colors" id="str1"></div>
                        <div class="h-1 flex-1 rounded-full bg-outline-variant/30 transition-colors" id="str2"></div>
                        <div class="h-1 flex-1 rounded-full bg-outline-variant/30 transition-colors" id="str3"></div>
                    </div>
                    <p class="text-xs text-on-surface-variant" id="strengthText">Password strength indicator</p>

                    <!-- Terms checkbox -->
                    <div class="flex items-start gap-2">
                        <input type="checkbox" id="terms" name="terms" required class="w-4 h-4 mt-0.5 text-primary rounded border-outline-variant focus:ring-primary">
                        <label for="terms" class="text-sm text-on-surface-variant">
                            I agree to the <a href="#" class="text-primary font-semibold hover:underline">Terms of Service</a>
                            and <a href="#" class="text-primary font-semibold hover:underline">Privacy Policy</a>
                        </label>
                    </div>

                    <!-- Submit button -->
                    <button type="submit" class="w-full py-4 primary-gradient text-on-primary font-bold rounded-full hover:scale-[1.02] shadow-lg transition-all">
                        Create Account
                    </button>
                </form>

                <!-- Social signup divider -->
                <div class="mt-8 flex items-center gap-4">
                    <div class="flex-1 border-t border-outline-variant/30 border-dashed"></div>
                    <div class="text-sm text-on-surface-variant font-medium">Or sign up with</div>
                    <div class="flex-1 border-t border-outline-variant/30 border-dashed"></div>
                </div>

                <!-- Social buttons -->
                <div class="mt-6 grid grid-cols-2 gap-4">
                    <button class="flex items-center justify-center gap-2 py-3 rounded-full bg-surface-container-low hover:bg-surface-container transition-colors text-sm font-bold border border-outline-variant/20">
                        <img src="https://www.svgrepo.com/show/475656/google-color.svg" class="w-5 h-5" alt="Google"> Google
                    </button>
                    <button class="flex items-center justify-center gap-2 py-3 rounded-full bg-surface-container-low hover:bg-surface-container transition-colors text-sm font-bold border border-outline-variant/20">
                        <span class="material-symbols-outlined text-xl">smartphone</span> Apple
                    </button>
                </div>

                <!-- Login link -->
                <div class="mt-8 text-center">
                    <span class="text-on-surface-variant text-sm">Already have an account? </span>
                    <a href="${pageContext.request.contextPath}/login" class="text-primary font-bold text-sm hover:underline underline-offset-4">Log in here</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Password strength JavaScript -->
<script>
function checkStrength(pw) {
    var s1 = document.getElementById('str1');
    var s2 = document.getElementById('str2');
    var s3 = document.getElementById('str3');
    var txt = document.getElementById('strengthText');
    var score = 0;
    if (pw.length >= 8) score++;
    if (/[A-Z]/.test(pw) && /[0-9]/.test(pw)) score++;
    if (/[^A-Za-z0-9]/.test(pw)) score++;

    s1.className = s2.className = s3.className = 'h-1 flex-1 rounded-full bg-outline-variant/30 transition-colors';
    if (score >= 1) { s1.className = 'h-1 flex-1 rounded-full bg-red-400 transition-colors'; txt.textContent = 'Weak'; }
    if (score >= 2) { s2.className = 'h-1 flex-1 rounded-full bg-yellow-400 transition-colors'; txt.textContent = 'Medium'; }
    if (score >= 3) { s3.className = 'h-1 flex-1 rounded-full bg-green-500 transition-colors'; txt.textContent = 'Strong'; }
    if (pw.length === 0) txt.textContent = 'Password strength indicator';
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
