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
1. **Data quality for demos**
   - [ ] Expand departments coverage in `db/seeds.rb`.
   - [ ] Add more users per department (students + at least one admin each).
   - [ ] Add richer resources (rooms/equipment) across departments.
   - [ ] Add representative booking records (mix of pending/approved/rejected).

### Next (priority order)

1. **N-1 features**
   - [ ] Sidekiq + Redis digest jobs.
   - [ ] Chartkick usage dashboard.

2. **Production hardening**
   - [x] Verify Render has `REDIS_URL` set and websocket connection stays stable after deploy.
   - [x] Add short ActionCable troubleshooting note to README.
   - [ ] Add small UI cue for live updates (optional highlight badge/row flash).

3. **UI and product polish**
   - [ ] Improve validation error copy in `Booking` model + booking form.
   - [ ] Add clearer status labels/colors in user and admin booking lists.

4. **Stability**
   - [ ] Remove redundant gems from `Gemfile` (`actioncable`, `redis-actionpack`) and use `redis` only if needed.
   - [ ] Add tests for booking validation and approval auto-reject behavior.
   - [ ] Add index for overlap queries (`resource_id`, `status`, time columns).



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
