class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    return if session[:user_id].blank?

    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_login
    return if current_user.present?

    redirect_to login_path, alert: "Faça login para continuar."
  end
end
