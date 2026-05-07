# EventHub – Fixed Project

This is the corrected version of the Event Hub Dynamic Web Project. All the
register/login/admin/event flows have been verified end-to-end against XAMPP
MySQL + Apache Tomcat 11.

## What was wrong (and fixed)

1. **`LoginServlet`** was forwarding to `/WEB-INF/views/user/home.jsp` instead of `/WEB-INF/views/auth/login.jsp`.
2. **All other controllers** were forwarding to `/WEB-INF/pages/...` paths that don't exist – the JSPs live under `/WEB-INF/views/...`. Filenames were also wrong-cased (`createEvent.jsp` vs `createevent.jsp`, etc.).
3. **Servlets set `setAttribute("error", ...)`** but the JSPs read `errorMsg`/`error` inconsistently. All servlets now set both names where appropriate.
4. **`UserDashboardServlet`** wasn't setting the attributes the JSP actually reads (`joinedEvents`, `myEventCount`, `totalApproved`, `totalUsers`).
5. **`AdminDashboardServlet`** wasn't loading admin actions, approved/rejected counts, or organiser names.
6. **`EventDetailServlet`** was setting `joined` but the JSP reads `isJoined`, and never set `isOwner` or `participantCount`.
7. **`ProfileServlet`** wasn't loading `myEventCount`/`joinedCount` and didn't accept the form's `currentPassword` field name.
8. **Three admin servlets were missing entirely** – `AdminEventServlet` (approve/reject), `AdminUserServlet` (lock/unlock), `AdminLogServlet` (audit trail).
9. **`AdminActionDAO`** referenced `description`/`created_at` columns that don't exist – fixed to `notes`/`action_at` matching the schema.
10. **`EventDAO.insert()`** was passing `Date.toString()` (e.g. `"Thu Jan 01 18:00:00 GMT+05:45 1970"`) into a `TIME` column – fixed to use `setTime(java.sql.Time)`.
11. **`ParticipantServlet`** was mapped only to `/participant`, but the event detail JSP posts to `/participants/join` and `/participants/leave`. Added both URL patterns and dispatch by URL suffix.
12. **`ValidationUtil.isValidPassword`** message claimed 8+ chars with mixed case + special, but the rule is 6+ chars. Aligned the message.

A `database/setup.sql` file is included with the schema that matches the Java
code (including `phone`, `bio`, `status` columns on `users`, `host_id` on
`events`, and `participants`/`admin_actions` named the way the DAOs expect).

## How to run

### 1. Start MySQL (XAMPP works as-is)

```bash
sudo /Applications/XAMPP/xamppfiles/xampp start
```

### 2. Create the schema

```bash
/Applications/XAMPP/xamppfiles/bin/mysql -u root < database/setup.sql
```

### 3. Build the WAR (already done — `build/eventhub.war`)

```bash
# from the project root
PROJ="$(pwd)"
SRV="/opt/homebrew/opt/tomcat/libexec"   # or your Tomcat home
LIB="$PROJ/src/main/webapp/WEB-INF/lib"
CP="$SRV/lib/servlet-api.jar:$SRV/lib/jsp-api.jar:$LIB/*"
mkdir -p build/classes
find src/main/java -name '*.java' -print0 | xargs -0 -I {} echo '"{}"' > /tmp/sources.txt
javac -d build/classes -cp "$CP" @/tmp/sources.txt
rm -rf build/war && mkdir -p build/war/WEB-INF/classes
cp -R src/main/webapp/* build/war/
cp -R build/classes/*  build/war/WEB-INF/classes/
(cd build/war && jar -cf ../eventhub.war .)
```

### 4. Deploy and start Tomcat

```bash
cp build/eventhub.war /opt/homebrew/opt/tomcat/libexec/webapps/
/opt/homebrew/opt/tomcat/libexec/bin/catalina.sh start
```

### 5. Use it

* Open **http://localhost:8080/eventhub/login**
* Register a new user, log in, create events, etc.
* To get an admin user: register normally, then promote yourself with
  `UPDATE users SET role='admin' WHERE email='you@example.com';`
* Admin URLs: `/admin/dashboard`, `/admin/events`, `/admin/users`, `/admin/logs`

### Eclipse Dynamic Web Project usage

If you import this folder into Eclipse as a Dynamic Web Project:

1. **Project → Properties → Project Facets** → Java 17+, Dynamic Web Module 6.0.
2. Add a Tomcat 11 server runtime under **Servers**.
3. Right-click the project → **Run As → Run on Server**.
4. The WAR is already structured exactly the way Eclipse expects
   (`src/main/java`, `src/main/webapp`, `WEB-INF/lib`).

## Verified flows (end-to-end smoke test)

| Flow | Status |
| --- | --- |
| Register new user | ✅ |
| Login (user + admin) | ✅ |
| Logout | ✅ |
| User dashboard with stats | ✅ |
| Create event (with date + time) | ✅ |
| My events list | ✅ |
| Browse events | ✅ |
| Event detail page | ✅ |
| Join event | ✅ |
| Leave event | ✅ |
| Joined events page | ✅ |
| Profile update | ✅ |
| Change password | ✅ |
| Admin dashboard | ✅ |
| Admin event moderation (approve/reject) | ✅ |
| Admin user management | ✅ |
| Admin action log | ✅ |
