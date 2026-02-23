# Proj

Minimal Ruby on Rails SaaS skeleton. Root path shows "Hello World".

## Run locally

```bash
bundle install
bin/rails server
```

Open http://localhost:3000

## Deploy to Heroku

```bash
heroku create
heroku addons:create heroku-postgresql:essential-0   # optional for this skeleton
git push heroku main
```

Then open your app URL (e.g. `https://your-app.herokuapp.com`).
