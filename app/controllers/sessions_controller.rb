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

  def create_oauth
    userinfo = request.env['omniauth.auth'].info

    redirect_to signin_path, notice: "Something went balls up with github auth" if userinfo.nil?

    newuser = false
    user = User.find_by username: userinfo.nickname

    if !user
      random_password = ('A'..'Z').to_a.sample(4).join +
                        ('0'..'9').to_a.sample(4).join

      user = User.create!(username: userinfo.nickname, password: random_password,
                          password_confirmation: random_password, github: true)

      redirect_to signin_path, notice: "Couldn't create new user" if !user

      newuser = true
    end

    redirect_to signin_path, notice: "Your account is disabled" if user&.disabled

    session[:user_id] = user.id
    redirect_to user, notice: "Welcome #{newuser ? '' : 'back'}"
  end
end
