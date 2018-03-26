class UsersController < ApplicationController
  before_action :require_login, { only: [:index, :show, :edit]}
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Successfully created..."
      redirect_to @user
    else
      flash.now[:danger] = '失敗'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = "Successfully updated..."
      redirect_to @user
    else
      flash.now[:danger] = '失敗'
      render :edit
    end
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
