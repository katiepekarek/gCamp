class ApplicationController < ActionController::Base

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
