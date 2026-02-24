## CSCI3100 Group project --- CUHK Venue and Equipment Booking SaaS

Course project @CUHK 2026 Spring

Members:

- Wong Cheuk Yin (1155192671)   https://github.com/TobiaKW
- Li Yun Sum (1155212047)   https://github.com/Samuelliys
- insert
- insert
- insert
- insert

## Disclaimer
This repository contains academic work and is published for record and reference purposes only. Do not copy or reuse the code as it may constitute academic misconduct. The code is specific to our course project and should be used solely for learning and understanding the concepts. For your own good, please do your project with your own understanding and knowledge. We are not responsible for any academic misconduct caused by the code in this repository.

## Notes for collaborators: We are using ruby version 3.3.10, rails 7.2.3 for this project, so make sure you install correct version before working.

Starting from an empty local folder...
```bash
git clone https://github.com/TobiaKW/CSCI3100_Project_Venue_And_Equipment_Booking_SaaS.git
git pull --rebase origin main
```

Then, for each change session:

```bash
git pull --rebase origin main #get latest change
# then do the modification
git add .       # or specific files
git commit -m "commit message"
git push origin main    #may need to add --set-upstream for first time
```

If push is rejected:

1. Pull and rebase: `git pull --rebase origin main`
2. If Git reports a **conflict**, open the listed file(s), resolve the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`), then:

```bash
git add .
git rebase --continue
```
Repeat step 2 if more conflicts appear. When the rebase finishes:

```bash
git push origin main
```

When prompted by git for authentication:

```bash
username for 'https://github.com': <your-github-username>
password for 'https://github.com': <your-github-personal-token>
```

your token should include the `repo` scope.

## Web service deployment choice 1: Heroku
Run locally

```bash
bundle install
bin/rails server
```

**Deploy to Heroku**
```bash
heroku create
git push heroku main
```

**To turn on/off the website**
```
heroku ps:scale web=0 -a secret-sierra-05778 # turn off
heroku ps:scale web=1 -a secret-sierra-05778 # turn on 
(last arg is the domain name)
```
## Web service deployment choice 2: Render (We are using this!)

1. Push this repo to **GitHub** (if you haven’t).
2. Go to [dashboard.render.com](https://dashboard.render.com) and sign in with GitHub.
3. **New → Web Service** (or **New → Blueprint** if you want to use `render.yaml`).
4. Connect the repo and pick this project.
5. Use these settings:
   - **Build Command:** `./bin/render-build.sh`
   - **Start Command:** `bin/rails server -p $PORT -e production`
   - **Environment:**
     - `RAILS_MASTER_KEY` = contents of local `config/master.key`
     - `WEB_CONCURRENCY` = `2`
6. Click **Create Web Service**. After the build, the app will be at `https://<name>.onrender.com`.

Free plan: app sleeps after ~15 min of no traffic; first request may take 30–60s to wake.
Now the web service is deployed on render via this repository, check deployment.

## TODO: One-page proposal. Please check the directory "Proposal".
