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

  def member_or_admin_auth
    unless (current_user.project_member_verify(@project) || current_user.admin)
      flash[:danger] = 'You do not have access to that project'
      redirect_to projects_path
    end
  end

  def project_owner_or_admin
    unless (current_user.project_owner_verify(@project) || current_user.admin)
      flash[:danger] = 'You do not have access'
      redirect_to project_path(@project)
    end
  end

  def project_owner_or_admin_or_member
    if current_user.project_owner_verify(@project) || current_user.admin || current_user.project_member_verify(@project)
      @membership.destroy
      flash[:success] = "#{@membership.user.full_name} was                      successfully removed"
      redirect_to projects_path
    else
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

  def verify_ownership
    if @project.memberships.where(role: "owner").count < 1 && @membership.role == "owner"
      flash[:danger] = "Projects must have at least one owner"
      redirect_to project_memberships_path(@project)
    end
  end

end
