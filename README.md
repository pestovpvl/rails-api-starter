# rails-api-starter

Starter Rails 8 API-only project with:
- Docker (dev, test, prod)
- JWT authentication
- RSpec tests
- GitHub Actions CI/CD
- SSH deploy (on main branch)

## 🚀 Getting Started

```bash
git clone git@github.com:your-name/rails-api-starter.git
cd rails-api-starter
cp .env.example .env
docker compose up --build
```

## ✅ Running Tests

```bash
docker compose -f docker-compose.test.yml run --rm app bundle exec rspec
```

## 🚢 Deployment

1. Push to `main` branch
2. GitHub Actions will run tests and deploy via SSH if tests pass
