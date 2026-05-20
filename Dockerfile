FROM ruby:3.2.2

# Instala dependências de sistema (necessárias para Rails e Assets)
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends build-essential libpq-dev postgresql-client nodejs npm && \
    rm -rf /var/lib/apt/lists/*
RUN npm install -g yarn

# Define ambiente de PRODUÇÃO
ENV RAILS_ENV=production
ENV NODE_ENV=production

WORKDIR /app

# Instala as gems de forma otimizada para Docker
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'true' && \
    bundle install

COPY . .

# Pré-compila os Assets (Tailwind e JS) usando uma chave temporária
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Garante permissão nos executáveis
RUN chmod +x bin/rails bin/rake

EXPOSE 3000

# Comando de inicialização
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails db:migrate && bundle exec rails server -b 0.0.0.0"]