---

## From HW cap → Booking app (what was done / what you do)

**Done**
- **HomeController** — Removed Movie CRUD (no `Movie` model existed). It’s now a simple landing with one `index` action. Root still goes to `home#index`.

**You do next (in order)**

1. **Migrations & models**  
   Create the four tables and models so `db/seeds` can run and the app has a real data layer:
   - `Department` (name)
   - `User` (email, password_digest, name, role, department_id) — use `has_secure_password` or add Devise later
   - `Resource` (name, rtype, department_id) — `rtype` = 'room' or 'equipment'
   - `Booking` (user_id, resource_id, department_id, start_time, end_time, status)  
   Commands: `bin/rails g model Department name:string`, then same for User, Resource, Booking; add associations and indexes; then `bin/rails db:migrate`.

2. **Fix seeds**  
   After migrations, run `bin/rails db:seed`. If User uses `has_secure_password`, ensure seeds set `password` (not `password_digest`) so validations pass.

3. **Auth**  
   Add Devise (or similar) so you have sign in / sign out and `current_user`. Restrict by role (student vs admin) in controllers.

4. **Booking app controllers & routes**  
   Add controllers and routes for the booking flow, e.g.:
   - `ResourcesController` — index (list), show (for a resource)
   - `BookingsController` — index (my bookings), new/create (request), and later approve/reject for admins  
   Wire these in `config/routes.rb` and scope by department/tenant when you add multi-tenant.

5. **Views**  
   Replace `app/views/home/index.html.erb` with a simple landing (e.g. “Venue & Equipment Booking”, links to resources and bookings). Add views for resources and bookings as you build the controllers.

6. **Conflict detection & approval**  
   In the Booking model or a service, validate no overlapping bookings for the same resource. New bookings from students → status `pending`; admin list to approve/reject (Phase 2 in the list below).

---

## TODO list (order suggested)

### Phase 1 — Data & auth
- [ ] **PostgreSQL in dev**  
  - In `Gemfile`: use `pg` in development too (or keep sqlite for dev; use pg in prod).  
  - `config/database.yml`: set up `development` for your chosen DB.
- [ ] **Models**  
  - `Department` (name, tenant key).  
  - `User` (email, password, role: student/admin, `department_id`).  
  - `Resource` (name, type: room/equipment, `department_id`).  
  - `Booking` (user, resource, start_time, end_time, status: pending/approved/rejected/expired, `department_id`).
- [ ] **Migrations**  
  - `bin/rails g migration CreateDepartments ...` (and similar for User, Resource, Booking).  
  - `bin/rails db:migrate`
- [ ] **Auth**  
  - Add Devise (or similar): sign up, sign in, sign out, “current user”.  
  - Restrict actions by role (student vs admin).

### Phase 2 — Core
- [ ] **Conflict detection**  
  - Before saving a Booking, check no overlapping booking for same resource (and same tenant).  
  - Validation or service object; show a clear error if conflict.
- [ ] **Approval workflow**  
  - Student creates booking → status `pending`.  
  - Admin list: “Pending approvals”.  
  - Admin can approve or reject (and optionally set expiry).

### Phase 3 — N-1 features (from proposal)
- [ ] **ActionMailer**  
  - Email to user when booking is confirmed.  
  - Email to admin when there is a new pending approval.
- [ ] **Sidekiq + Redis**  
  - Daily digest for department admin: “Today’s bookings”, “Tomorrow’s schedule”, “Pending approvals”.
- [ ] **ActionCable**  
  - Real-time booking status updates (e.g. notify student when admin approves/rejects).
- [ ] **Chartkick**  
  - Dashboard: usage stats for venues/equipment (e.g. by department, by time).

### Phase 4 — Polish
- [ ] **Multi-tenant**  
  - Scope all queries by `department_id` (or current tenant).  
  - Ensure students/admins only see their department’s resources and bookings.
- [ ] **Responsive UI**  
  - Bootstrap (or similar) so it’s usable on mobile.
- [ ] **Tests**  
  - BDD-style: “student can request booking”, “admin can approve”, “double booking is rejected”.  
  - RSpec + request/feature tests (no need for Cucumber unless required).

---

## Useful commands (offline)

| Task | Command |
|------|--------|
| Start app | `bin/rails server` |
| Console | `bin/rails console` |
| New migration | `bin/rails g migration AddXToY ...` |
| Run migrations | `bin/rails db:migrate` |
| Rollback last migration | `bin/rails db:rollback` |
| Routes | `bin/rails routes` |
| Check Ruby/Rails | `ruby -v` and `bin/rails -v` |

---

## When you're back online

1. Pull latest: `git pull --rebase origin main`
2. Resolve any conflicts (see README), then `git add` and `git rebase --continue`
3. Push: `git push origin main`
4. Deploy (Render/Heroku) if needed — see README.

---

## Proposal reminder (data & flow)

- **Models:** Department → Users, Resources (room/equipment), Bookings (pending → approved/rejected/expired).
- **Core:** Conflict detection (no double booking); multi-stage approval (student submit → admin approve/reject).
- **Stack:** Rails 7.2.3, PostgreSQL, RSpec. N-1: ActionMailer, Sidekiq+Redis, ActionCable, Chartkick.

