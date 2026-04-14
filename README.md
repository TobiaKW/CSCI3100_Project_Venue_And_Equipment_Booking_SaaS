# CSCI3100 Group project<br>CUHK Venue and Equipment Booking SaaS

Course project @CUHK 2026 Spring

Members:

- Wong Cheuk Yin (1155192671)   https://github.com/TobiaKW
- Li Yun Sum (1155212047)   https://github.com/Samuelliys
- Wong Sheung Chit (1155212592)   https://github.com/jw1101
- Hsieh Chong Ho (1155213925)   https://github.com/Qwerty-Pi
- Ng Shing Hin (1155214379) https://github.com/Eason2123

## Basic Features
| Feature Name | Primary Developer | Secondary Developer | Notes |
|---|---|---|---|
| Deployment & Database | Wong Cheuk Yin | | Render environment setup, maintain the Postgre database in production |
| UI & Styling | Wong Sheung Chit |  | Pure CSS Styling of All Pages |
| User Authentication & Authorization | Wong Cheuk Yin | | Devise gem with admin/user roles |
| Booking Management & Conflict Detection | Wong Cheuk Yin | | Real-time validation, overlap prevention |
| Admin Dashboard & Charts | Wong Cheuk Yin | | Chartkick with Redis caching |
| Testing | Hsieh Chong Ho | Li Yun Sum | Rspec & Cucumber |
| Responsive Layout | Wong Sheung Chit |  | CSS Media Queries |
| Demo Video | Wong Sheung Chit |  | Recording, Narration & Editing |

## N-1 Advanced Features
| Feature Name | Primary Developer | Secondary Developer | Notes |
|---|---|---|---|
| Real-time Updates | Wong Cheuk Yin | | ActionCable + Redis integration |
| Email Notifications | Wong Cheuk Yin | | Sendgrid Mailer |
| Google Maps Integration | Ng Shing Hin | | Insert |
| Resource Search & Filtering | Hsieh Chong Ho | Wong Cheuk Yin | Search by Multiple Criteria, Fuzzy Search |


## Disclaimer
This repository contains academic work and is published for record and reference purposes only. Do not copy or reuse the code as it may constitute academic misconduct. The code is specific to our course project and should be used solely for learning and understanding the concepts. For your own good, please do your project with your own understanding and knowledge. We are not responsible for any academic misconduct caused by the code in this repository.

## Setup Guide

1. Fork this repo

2. Register SendGrid Account and validate your email

3. Set up a Redis database and Postgre Database in Render

   To create Redis database, **New → Key Value**, choose the same project of the web deployment. Maxmemory policy choose `noeviction` 

   To create Redis database, **New → Postgres**, choose the same project of the web deployment. Version=18.

4. Deploy Web service to Render
   Go to [dashboard.render.com](https://dashboard.render.com) and sign in with GitHub.
   **New → Blueprint** , use `render.yaml`
   Connect the forked repo and pick this project.
   Use these settings:
   - **Build Command:** `./bin/render-build.sh`
   - **Start Command:** `bin/rails server -p $PORT -e production`
   - **Environment:**
     - `RAILS_MASTER_KEY` = contents of `config/master.key`
     - `WEB_CONCURRENCY` = `2`
     - `DATABASE_URL` = internal URL of a PostgreSQL database in Render
     - `MAIL_FROM` = the email notification sender (need to setup in SendGrid)
     - `REDIS_URL` = URL of Redis database (for real-time feature)
     - `SMTP_USERNAME` = `apikey`
     - `SMTP_PASSWORD` = API key of the SendGrid account
     - `USE_SENDGRID_HTTP_API` = true
     - `GOOGLE_MAPS_API_KEY`
5. Click **Create Web Service**. After the build, the app will be at `https://<name>.onrender.com`.

Free plan: app sleeps after ~15 min of no traffic; first request may take 30–60s to wake.
Now the web service is deployed on render via this repository, check deployment.

You shd have the 3 services below on Render:
![](rendersetup.png)
1. the main web service depolyment
2. Postgre Database
3. Redis Database


## Database PSQL (Only for local)

connecting

```bash
psql -d proj_development        # connect to DB
\q                              # quit
```

See structure

```
\dt                             -- list tables
\d users                        -- describe users table (columns, indexes)
\d+ bookings                    -- same, with extra info
```

Basic Enquires

```sql
SELECT * FROM users;            -- all users
SELECT id, email FROM users;    -- specific columns
SELECT * FROM users WHERE email = 'abc@example.com';
SELECT COUNT(*) FROM bookings;  -- how many rows

SELECT id, name, email, role, department_id  FROM users;
```

update/insert/delete rows

```sql
INSERT INTO departments (name) VALUES ('Engineering');

UPDATE users
SET role = 'admin'
WHERE email = 'abc@example.com';

DELETE FROM users
WHERE email = 'abc@example.com';
```

## SimpleCov Report
![](./SimpleCov%20Report.png)