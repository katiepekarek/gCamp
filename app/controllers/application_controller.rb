class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    User.find_by(id: session[:user_id])
  end

  helper_method :current_user

  def authorize
    unless current_user
      flash[:danger] = 'You must sign in'
      redirect_to signin_path
    end
  end
end
