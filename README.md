# MarketFlow
### Gestao Inteligente de Inventario

![Ruby on Rails](https://img.shields.io/badge/Ruby_on_Rails-7.1-CC0000?logo=rubyonrails&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-336791?logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)

## 📌 Descricao

O **MarketFlow** e uma solucao robusta para gestao de estoque em mercados, desenvolvida com foco em **performance operacional** e **inteligencia de dados**.  
O sistema centraliza o controle de produtos, facilita a analise financeira do inventario e entrega uma experiencia moderna para acompanhamento das operacoes.

## 🚀 Funcionalidades Principais

- 🔐 **Autenticacao segura com Bcrypt** para cadastro e login de usuarios.
- 📦 **CRUD completo de produtos** com validacoes de integridade (campos obrigatorios, SKU unico e regras de estoque/preco).
- 📊 **Dashboard Inteligente** com calculos de valor total do estoque.
- 📈 **Visualizacao de dados com graficos** (distribuicao por categoria e ranking de produtos por valor em estoque).
- 📄 **Exportacao de relatorios em CSV** para apoio a analises e tomadas de decisao.

## 🛠️ Tecnologias Utilizadas

- Ruby on Rails 7
- PostgreSQL
- Docker / Docker Compose
- Tailwind CSS
- Chartkick

## ▶️ Como Rodar o Projeto

### 1) Clonar o repositorio

```bash
git clone https://github.com/willian-mendes-dev/dev-flow-manager.git
cd dev-flow-manager
```

### 2) Subir os servicos com build

```bash
docker-compose up --build
```

### 3) Preparar o banco de dados (create + migrate)

```bash
docker-compose run web rails db:prepare
```

### 4) Popular com dados de exemplo

```bash
docker-compose run web rails db:seed
```

### 5) Acessar a aplicacao

```text
http://localhost:3000
```

## 📋 Gestao do Projeto

A organizacao das tarefas segue metodologia **Kanban** utilizando **GitHub Projects**.

- Board: [MarketFlow - Kanban](https://github.com/users/willian-mendes-dev/projects)

## ✅ Status do Projeto

**AC3 Finalizado - Estavel**
