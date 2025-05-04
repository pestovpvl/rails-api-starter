# Base stage
FROM ruby:3.3.0-slim AS base
WORKDIR /app
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev postgresql-client nodejs git && \
    gem install bundler
COPY Gemfile* ./
RUN bundle install

# Development stage
FROM base AS dev
COPY . .
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0"]

# Production stage
FROM base AS prod
ENV RAILS_ENV=production
COPY . .
RUN RAILS_ENV=production bundle exec rails assets:precompile
CMD ["bash", "-c", "bundle exec rails s -b 0.0.0.0"]

# Test stage
FROM base AS test
COPY . .
CMD ["bash", "-c", "bundle exec rspec"]
