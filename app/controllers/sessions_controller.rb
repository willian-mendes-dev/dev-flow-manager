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
    @view = params[:view] || "dashboard"
    @products = Product.order(created_at: :desc)
    @low_stock_items = Product.where(stock_quantity: 0..20).order(:stock_quantity, :name)
    @total_products = @products.count
    @low_stock_count = @products.where(stock_quantity: 1..20).count
    @out_of_stock_count = @products.where(stock_quantity: 0).count
    @recent_products = @products.limit(10)
  end

  def destroy
    session[:user_id] = nil
    reset_session
    redirect_to login_path, notice: "Até logo!"
  end

  private
end
