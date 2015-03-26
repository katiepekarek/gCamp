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

  def member_auth
    unless current_user.project_member_verify(@project)
      flash[:danger] = 'You do not have access to that project'
      redirect_to projects_path
    end
  end

  def project_owner
    unless current_user.project_owner_verify(@project)
      flash[:danger] = 'You do not have access'
      redirect_to project_path(@project)
    end
  end

  def current_user_or_admin(user)
    user == current_user || current_user.admin
  end

  def access_error
    unless current_user_or_admin(@user)
      render file: 'public/404.html', status: :not_found, layout: false
    end
  end

end
