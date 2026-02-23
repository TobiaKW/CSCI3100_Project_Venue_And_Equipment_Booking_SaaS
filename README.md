## 1. Heroku
Run locally

```bash
bundle install
bin/rails server
```

## Deploy to Heroku

```bash
heroku create
git push heroku main
```

```
heroku ps:scale web=0 -a secret-sierra-05778 --turn off
heroku ps:scale web=1 -a secret-sierra-05778 --turn on
```
## 2. Render (We are using this!)

1. Push this repo to **GitHub** (if you haven’t).
2. Go to [dashboard.render.com](https://dashboard.render.com) and sign in with GitHub.
3. **New → Web Service** (or **New → Blueprint** if you want to use `render.yaml`).
4. Connect the repo and pick this project.
5. Use these settings:
   - **Build Command:** `./bin/render-build.sh`
   - **Start Command:** `bin/rails server -p $PORT -e production`
   - **Environment:**
     - `RAILS_MASTER_KEY` = contents of your local `config/master.key`
     - `WEB_CONCURRENCY` = `2`
6. Click **Create Web Service**. After the build, the app will be at `https://<name>.onrender.com`.

Free plan: app sleeps after ~15 min of no traffic; first request may take 30–60s to wake.