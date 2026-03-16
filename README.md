# MarketFlow - Projeto de Software (Ruby on Rails 7)

Sistema para controle de entrada/saida de mercadorias, gestao de fornecedores e alertas de estoque baixo.

## Stack

- Ruby on Rails 7
- PostgreSQL
- Tailwind CSS
- Docker e Docker Compose

## Funcionalidades implementadas

- Autenticacao real com cadastro e login
- Cadastro de usuario com `name` e senha criptografada com `bcrypt`
- Login com validacao de credenciais (`authenticate`)
- Sessao persistida com `session[:user_id]`
- Dashboard com navegacao por `?view=dashboard|produtos|estoque_baixo`
- Logout limpando sessao e redirecionando para login

## Estrutura principal

- `app/controllers/sessions_controller.rb`: login, home e logout
- `app/controllers/users_controller.rb`: cadastro de usuarios
- `app/models/user.rb`: `has_secure_password` e validacoes
- `app/views/sessions/login.html.erb`: tela de login
- `app/views/users/new.html.erb`: tela de cadastro
- `app/views/sessions/home.html.erb`: dashboard e tabelas
- `app/views/layouts/application.html.erb`: layout SaaS com sidebar
- `db/migrate/20260315194500_create_users.rb`: cria tabela users
- `db/migrate/20260316003000_add_password_digest_to_users.rb`: adiciona `password_digest`
- `docker-compose.yml`: servicos `web` e `db`
- `bin/docker-entrypoint`: prepara banco e sobe app

## Como rodar com Docker

1. Build e subida dos containers:

```bash
docker compose up --build
```

2. Instalar gems (apos alterar Gemfile):

```bash
docker compose run --entrypoint "" web bundle install
```

3. Criar banco e rodar migrations:

```bash
docker compose run web rails db:create db:migrate
```

4. Acessar:

`http://localhost:3000`

## Rotas principais

- `GET /login`: tela de login
- `POST /login`: autentica usuario existente
- `GET /signup`: tela de cadastro
- `POST /signup`: cria usuario e loga automaticamente
- `GET /home`: dashboard protegido (requer sessao)
- `DELETE /logout` (ou `GET /logout`): encerra sessao
