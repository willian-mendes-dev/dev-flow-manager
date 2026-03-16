class ApplicationController < ActionController::Base
  private

  def require_login
    return if session[:user_id].present?

    redirect_to login_path, alert: "Faça login para continuar."
  end
end
