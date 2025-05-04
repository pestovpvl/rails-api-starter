# rails-api-starter

A reusable Rails API boilerplate with Docker and GitHub Actions for automated CI/CD and clean development.

---

## ✅ Features

- Rails API-only mode
- Docker-based dev, test, and prod environments
- PostgreSQL setup
- GitHub Actions for CI and deploy via SSH
- RSpec, FactoryBot, Faker, Rubocop
- Standardized Makefile for commands

---

## 📁 Project Structure

```
├── app/
├── config/
├── db/
├── Dockerfile
├── docker-compose.yml
├── docker-compose.dev.yml
├── docker-compose.test.yml
├── docker-compose.prod.yml
├── .env.dev
├── .env.test
├── .env.prod
├── .github/workflows/deploy.yml
├── Makefile
├── Gemfile
└── README.md
```

---

## ⚙️ Setup Instructions

```bash
git clone https://github.com/YOUR_USERNAME/rails-api-starter.git
cd rails-api-starter
cp .env.dev.example .env.dev
make dev
```

---

## 🐳 Makefile Commands

```bash
make dev        # Run dev env
dev-down        # Stop dev env
make build      # Build images
make sh         # Open app shell
make migrate    # Run migrations
make reset      # Drop and recreate DB
make rspec      # Run tests
make deploy     # Deploy to production
```

---

## 🔐 GitHub Actions CI/CD (.github/workflows/deploy.yml)

```yaml
name: CI & Deploy

on:
  push:
    branches:
      - main

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-ruby@v1
        with:
          ruby-version: 3.3.0
      - name: Set up Docker
        uses: docker/setup-buildx-action@v2
      - name: Run tests
        run: |
          docker compose -f docker-compose.test.yml --env-file .env.test run --rm app bundle exec rspec

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: success()
    steps:
      - name: SSH Deploy
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.SSH_HOST }}
          username: ${{ secrets.SSH_USER }}
          key: ${{ secrets.SSH_KEY }}
          script: |
            cd /path/to/rails-api-starter
            git pull origin main
            docker compose -f docker-compose.prod.yml --env-file .env.prod up -d --build
```

---

## ✨ Customize for Each App
- Change `APP_NAME` in Makefile
- Replace SSH values in deploy.yml or use GitHub Secrets
- Add services (Redis, Sidekiq, etc.) as needed
