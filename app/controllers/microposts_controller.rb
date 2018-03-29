class MicropostsController < ApplicationController
  before_action :require_login
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_micropost, only: [:edit, :update, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'message created...'
      redirect_to root_url
    else
      @microposts = current_user.microposts.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'failed...'
      render 'toppages/index'
    end
  end

  def edit
    @microposts = current_user.microposts.order('created_at DESC').page(params[:page])
  end

  def update
    if @micropost.update(micropost_params)
      flash[:success] = 'message updated...'
      redirect_to root_url
    else
      @microposts = current_user.microposts.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'failed...'
      render 'microposts/edit'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'message deleted...'
    redirect_back(fallback_location: root_path)
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end

  def set_micropost
    @micropost = current_user.microposts.find_by(id: params[:id])
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    unless @micropost
      redirect_to root_url
    end
  end
end
