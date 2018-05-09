class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    @user = User.find_by(email: email)
    if @user.try(:activated?)
      if login(email, password)
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        flash[:success] = "Successfully logged in..."
        redirect_to @user
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
