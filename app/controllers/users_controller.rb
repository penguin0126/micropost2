class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :set_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update, :destroy]
  def index
    @users = User.where(activated: true).page(params[:page])
  end

  def show
    @microposts = @user.microposts.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Successfully updated..."
      redirect_to @user
    else
      flash.now[:danger] = '失敗'
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def followings
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end

  def followers
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end

  def favorite_posts
    @microposts = @user.favorite_microposts.page(params[:page])
    counts(@user)
  end

  private

   def user_params
     params.require(:user).permit(:name, :email, :password, :password_confirmation)
   end

   def set_user
     @user = User.find(params[:id])
   end

   def correct_user
     @user = User.find(params[:id])
     redirect_to root_url unless @user == current_user
   end
end
