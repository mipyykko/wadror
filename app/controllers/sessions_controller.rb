class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by username: params[:username]
    if user&.authenticate(params[:password])
      if user&.disabled
        redirect_to signin_path, notice: "Your account is disabled"
      else
        session[:user_id] = user.id if user
        redirect_to user, notice: "Welcome back"
      end
    else
      redirect_to signin_path, notice: "User #{params[:username]} does not exist or wrong password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end
