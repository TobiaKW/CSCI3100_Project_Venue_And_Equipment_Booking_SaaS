## Booking App Progress Tracker

Last updated: 2026-03-24

### Done
- [x] Core data model and migration created (`Department`, `User`, `Resource`, `Booking`).
- [x] Devise authentication integrated (`devise_for :users`, sign in/out, role-aware flow).
- [x] Booking routes/controllers wired (`resources`, `bookings`, `admin/bookings`).
- [x] Seed data works on fresh DB (`bin/rails db:migrate db:seed`).
- [x] Booking validations implemented:
  - [x] `start_time` / `end_time` presence
  - [x] end after start
  - [x] minimum duration 1 hour
  - [x] no overlap with existing `approved` booking on same resource
  - [x] at least 7 days in advance
  - [x] no overnight booking for venue (`rtype == "room"`)
- [x] Approval workflow: when admin approves one booking, overlapping pending bookings are auto-rejected.
- [x] Mail setup switched to SMTP baseline + optional SendGrid HTTP delivery fallback.
- [x] ActionCable framework enabled in app config.
- [x] `config/cable.yml` environment sections created.
- [x] ActionCable channel base and connection auth configured (`ApplicationCable::Channel`, Warden user lookup).
- [x] `BookingsChannel` streams set up for user and admin-department updates.
- [x] Broadcast on booking create (student -> admin dashboard) and admin decision (admin -> student status).
- [x] Frontend subscription wired via importmap (`@rails/actioncable`, `app/javascript/channels/*`).
- [x] Booking row partial extracted for realtime prepend in admin dashboard.

### In progress
1. **HTML to CSS refactoring**
   - [ ] Convert remaining inline styles to reusable CSS classes.
   - [ ] Consolidate styles into `home.css`, `forms.css`, and responsive styles.
   - [ ] Polish layout consistency across user/admin/auth pages.

2. **Data quality for demos (mostly done)**
   - [x] Expand departments coverage in `db/seeds.rb`.
   - [x] Add more users per department (students + at least one admin each).
   - [x] Add richer room resources across departments.
   - [ ] Continue enriching equipment dataset for better digest/usage presentation.

### Next (priority order)

1. **N-1 features**
   - [ ] Sidekiq + Redis digest jobs.
   - [ ] Chartkick usage dashboard.

2. **Production hardening**
   - [x] Verify Render has `REDIS_URL` set and websocket connection stays stable after deploy.
   - [x] Add short ActionCable troubleshooting note to README.
   - [ ] Add small UI cue for live updates (optional highlight badge/row flash).

3. **RSpec testing**
   - [x] Set up `rspec-rails` and baseline test helpers.
   - [x] Add model specs for booking validations (duration, overlap, seven-day, overnight).
   - [x] Add request specs for admin approval + auto-reject overlapping pending bookings.
   - [ ] Add request spec for admin authorization protection.



---

## Commands you use most

| Task | Command |
|---|---|
| Start app | `bin/rails server` |
| Run migrations | `bin/rails db:migrate` |
| Rebuild local DB | `bin/rails db:drop db:create db:migrate db:seed` |
| Seed only | `bin/rails db:seed` |
| Show routes | `bin/rails routes` |
| Rails console | `bin/rails console` |
| RuboCop | `bundle exec rubocop` |

---

## Render notes

- `startCommand` currently runs migrate on boot (`db:migrate && rails server`).
- `DATABASE_URL` on web service should use Render internal DB URL.
- For ActionCable in production, set `REDIS_URL`.

## 📋 HTML to CSS Refactoring Checklist

1. VIEW FILES TO REFACTOR (11 main views)

 - app/views/home/index.html.erb - Landing page (most complex)
 - app/views/bookings/index.html.erb - User bookings list
 - app/views/bookings/new.html.erb - Booking creation form
 - app/views/admin/bookings/index.html.erb - Admin dashboard
 - app/views/admin/bookings/_booking_row.html.erb - Partial
 - app/views/devise/sessions/new.html.erb - Login
 - app/views/devise/registrations/new.html.erb - Sign up
 - app/views/devise/registrations/edit.html.erb - Edit profile
 - app/views/layouts/application.html.erb - Main layout
 - app/views/devise/shared/_links.html.erb - Auth links partial
 - app/views/devise/shared/_error_messages.html.erb - Error messages

2. INLINE STYLES TO MOVE (6 instances currently)

Move these from style="..." attributes to CSS classes in app/assets/stylesheets/:

 - style="font-weight: 600;" - Create .font-weight-bold or .label-bold
 - Search form styling
 - Filter section styling
 - Label styling

3. CSS FILES ORGANIZATION

Current structure (good):

 - application.css - Global styles
 - layout.css - Navigation, layout
 - components.css - Reusable components
 - bookings.css - Booking-specific
 - dashboard.css - Admin dashboard

What needs work:

 - Consolidate related styles (some duplication likely exists)
 - Add home.css for landing page styles
 - Add forms.css for Devise forms (login, signup, edit profile)

4. KEY REFACTORING TASKS

A. Extract Inline Styles (Priority: HIGH)

 home/index.html.erb:
   - style="font-weight: 600;" on labels → .label-bold
   - Search form layout styles → .search-section, .search-form, .search-input-group
   - Filter checkbox styling → .filter-checkboxes, .filter-checkbox-label
   - Resource grid styling → .resources-grid, .resource-card

B. Clean Up HTML Structure (Priority: MEDIUM)

 - Reduce nested divs in forms
 - Use semantic HTML (nav, section, article, aside)
 - Improve accessibility (ARIA labels, proper heading hierarchy)
 - Check for redundant wrapper divs

C. Create Missing CSS Files (Priority: MEDIUM)

 - forms.css - All Devise form styling (login, signup, edit)
 - home.css - Landing page specific styles
 - responsive.css - Media queries for mobile/tablet

D. CSS Best Practices (Priority: LOW)

 - Establish naming convention (BEM, SMACSS, or custom)
 - Define color palette variables (currently using inline hex?)
 - Create reusable utility classes
 - Document CSS class structure

5. SPECIFIC AREAS TO CHECK

| File | Issue Type | What to Look For |
|---|---|---|
| `home/index.html.erb` | Inline styles, structure | Search form, resource cards, filters |
| `admin/bookings/index.html.erb` | Complex table, styling | Status badges, action buttons |
| `bookings/new.html.erb` | Form styling | Date/time pickers, submit buttons |
| `devise/sessions/new.html.erb` | Form layout | Login form styling |
| `layouts/application.html.erb` | Global markup | Navigation, alerts, footer |

6. REFACTORING ORDER (Recommended)

 1. Phase 1: Extract inline styles (quick wins)
 2. Phase 2: Create missing CSS files (forms.css, home.css)
 3. Phase 3: Reorganize HTML structure (semantic HTML, reduce nesting)
 4. Phase 4: Implement responsive design and mobile-first approach
 5. Phase 5: Establish CSS naming conventions and document
