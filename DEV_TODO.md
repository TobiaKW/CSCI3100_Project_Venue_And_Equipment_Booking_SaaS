## Booking App Progress Tracker

Last updated: 2026-03-23

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

### In progress
- [ ] ActionCable real-time booking status updates (channel + broadcast + client subscriber).
- [ ] Verify production ActionCable setup on Render (`REDIS_URL`, allowed origins).

### Next (priority order)
1. **Finish ActionCable MVP**
   - [ ] Update `app/channels/application_cable/connection.rb` to use Devise/Warden (`env["warden"]`), not `cookies.encrypted[:user_id]`.
   - [ ] Add `BookingsChannel` subscription scope (user-level stream first).
   - [ ] Broadcast on admin approve/reject in `admin/bookings_controller.rb`.
   - [ ] Add frontend subscription and update booking status badge without refresh.

2. **UI and product polish**
   - [ ] Improve validation error copy in `Booking` model + booking form.
   - [ ] Add clearer status labels/colors in user and admin booking lists.

3. **Stability**
   - [ ] Add tests for booking validation and approval auto-reject behavior.
   - [ ] Add index for overlap queries (`resource_id`, `status`, time columns).

4. **N-1 features**
   - [ ] Sidekiq + Redis digest jobs.
   - [ ] Chartkick usage dashboard.

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
