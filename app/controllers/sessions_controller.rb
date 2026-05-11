class SessionsController < ApplicationController

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

  def destroy
    session[:user_id] = nil
    reset_session
    redirect_to login_path, notice: "Até logo!"
  end

  private
end
