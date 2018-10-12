class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    return nil if session[:user_id].nil?

    User.find_by(id: session[:user_id])
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice: 'Sign in' if current_user.nil?
  end

  def ensure_that_admin
    redirect_to request.referrer, notice: 'You must be admin to do this' if !current_user.admin
  end
end
