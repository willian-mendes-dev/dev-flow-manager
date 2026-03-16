FROM ruby:3.2.2

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends build-essential libpq-dev postgresql-client && \
    rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=development \
    BUNDLE_PATH=/usr/local/bundle

WORKDIR /app

COPY Gemfile ./
RUN bundle install

COPY . .

RUN chmod +x bin/rails bin/rake bin/docker-entrypoint

EXPOSE 3000

ENTRYPOINT ["./bin/docker-entrypoint"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
