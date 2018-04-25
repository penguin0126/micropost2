class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user and user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
=begin
  def create
    email = params[:hoge][:email].downcase
    password = params[:hoge][:password]
    @user = User.find_by(email: email)
    if @user.activated?
      if login(email, password)
        params[:hoge][:remember_me] == '1' ? remember(@user) : forget(@user)
        flash[:success] = "Successfully logged in..."
        redirect_back_or user
      else
        flash.now[:danger] = 'Invalid email/password combination'
        render :new
      end
    else
      message  = "Account not activated. "
      message += "Check your email for the activation link."
      flash[:danger] = message
      redirect_to root_url
    end
  end

  def destroy
    if logged_in?
      forget(current_user)
      session[:user_id] = nil  #logout
      flash[:success] = "logout"
      redirect_to root_url
    end
  end
=end
  private

  def login(email, password)
    if @user && @user.authenticate(password)
      session[:user_id] = @user.id
      return true
    else
      return false
    end
  end
end
