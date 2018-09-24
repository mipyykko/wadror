class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by username: params[:username]
    if user&.authenticate(params[:password])
      session[:user_id] = user.id if user
      redirect_to user, notice: "Welcome back"
    else
      redirect_to signin_path, notice: "User #{params[:username]} does not exist or wrong password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end
