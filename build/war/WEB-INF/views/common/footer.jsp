

<!-- Footer -->
<footer class="bg-on-surface text-white mt-20">
    <div class="max-w-7xl mx-auto px-6 py-16">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-10">
            <!-- Brand -->
            <div class="col-span-1">
                <h3 class="text-2xl font-black font-headline tracking-tighter mb-4">EventHub</h3>
                <p class="text-sm opacity-70 leading-relaxed">Discover, create and join local events. Build connections that last a lifetime.</p>
            </div>
            <!-- Quick Links -->
            <div>
                <h4 class="font-bold font-headline mb-4 text-sm uppercase tracking-wider opacity-60">Explore</h4>
                <ul class="space-y-2 text-sm opacity-80">
                    <li><a href="${pageContext.request.contextPath}/events" class="hover:opacity-100 transition-opacity">Browse Events</a></li>
                    <li><a href="${pageContext.request.contextPath}/events/create" class="hover:opacity-100 transition-opacity">Create Event</a></li>
                    <li><a href="${pageContext.request.contextPath}/events/joined" class="hover:opacity-100 transition-opacity">My Tickets</a></li>
                </ul>
            </div>
            <!-- Account -->
            <div>
                <h4 class="font-bold font-headline mb-4 text-sm uppercase tracking-wider opacity-60">Account</h4>
                <ul class="space-y-2 text-sm opacity-80">
                    <li><a href="${pageContext.request.contextPath}/login" class="hover:opacity-100 transition-opacity">Login</a></li>
                    <li><a href="${pageContext.request.contextPath}/register" class="hover:opacity-100 transition-opacity">Register</a></li>
                    <li><a href="${pageContext.request.contextPath}/profile" class="hover:opacity-100 transition-opacity">Profile</a></li>
                </ul>
            </div>
            <!-- Contact -->
            <div>
                <h4 class="font-bold font-headline mb-4 text-sm uppercase tracking-wider opacity-60">Connect</h4>
                <ul class="space-y-2 text-sm opacity-80">
                    <li class="flex items-center gap-2"><span class="material-symbols-outlined text-sm">mail</span> info@eventhub.com</li>
                    <li class="flex items-center gap-2"><span class="material-symbols-outlined text-sm">location_on</span> Kathmandu, Nepal</li>
                </ul>
            </div>
        </div>
        <!-- Copyright -->
        <div class="border-t border-white/10 mt-12 pt-8 text-center text-sm opacity-50">
            &copy; 2026 EventHub. All rights reserved. Built with Jakarta EE + JSP.
        </div>
    </div>
</footer>

</body>
</html>
