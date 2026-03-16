class SessionsController < ApplicationController
  before_action :require_login, only: :home

  def login; end

  def create
    @name = params[:name].to_s.strip

    if @name.blank?
      flash.now[:alert] = "Nome é obrigatório"
      render :login, status: :unprocessable_entity
      return
    end

    user = User.find_by(name: @name)

    if user&.authenticate(params[:password].to_s)
      session[:user_id] = user.id
      redirect_to home_path, notice: "Login realizado com sucesso."
    else
      flash.now[:alert] = "Nome ou senha inválidos."
      render :login, status: :unprocessable_entity
    end
  end

  def home
    @username = User.find(session[:user_id]).name
    @view = params[:view] || "dashboard"

    @products = [
      { sku: "PRD-001", name: "Arroz Tipo 1 - 5kg", category: "Mercearia", stock: 42 },
      { sku: "PRD-002", name: "Feijão Carioca - 1kg", category: "Mercearia", stock: 31 },
      { sku: "PRD-003", name: "Óleo de Soja - 900ml", category: "Mercearia", stock: 12 },
      { sku: "PRD-004", name: "Leite Integral - 1L", category: "Laticínios", stock: 9 }
    ]

    @low_stock_items = [
      { sku: "PRD-004", name: "Leite Integral - 1L", stock: 9, minimum: 20 },
      { sku: "PRD-010", name: "Café Torrado - 500g", stock: 6, minimum: 18 },
      { sku: "PRD-017", name: "Açúcar Refinado - 1kg", stock: 4, minimum: 15 }
    ]

    @movements = [
      { date: "15/03/2026 09:15", product: "Arroz Tipo 1 - 5kg", type: "Entrada", quantity: 30 },
      { date: "15/03/2026 11:40", product: "Leite Integral - 1L", type: "Saída", quantity: 12 },
      { date: "15/03/2026 14:05", product: "Café Torrado - 500g", type: "Saída", quantity: 8 }
    ]
  end

  def destroy
    session[:user_id] = nil
    reset_session
    redirect_to login_path, notice: "Até logo!"
  end

  private
end
