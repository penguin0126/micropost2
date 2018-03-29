class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:hoge][:email].downcase
    password = params[:hoge][:password]
    if login(email, password)
      #remember @user
      flash[:success] = "Successfully logged in..."
      redirect_to @user
    else
      flash.now[:danger] = 'Login failed'
      render :new
    end
  end
=begin
  user = User.find_by(email: params[:session][:email])
  if user && user.authenticate(password: params[:session][:password])
    login(user)
    redirect_to user
  else
    render ...
  end
=end
  def destroy
    session[:user_id] = nil  #logout
    flash[:success] = "logout"
    redirect_to root_url
  end

  private

  def login(email, password)
    @user = User.find_by(email: email)
    if @user && @user.authenticate(password)
      session[:user_id] = @user.id
      return true
    else
      return false
    end
  end
end
