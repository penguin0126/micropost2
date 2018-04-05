class RelationshipsController < ApplicationController
  before_action :require_login
  def create
    user = User.find(params[:follow_id])
    current_user.follow(user)
    flash[:success] = 'following this user'
    redirect_to user
  end

  def destroy
    user = User.find(params[:follow_id])
    current_user.unfollow(user)
    flash[:success] = 'unfollowing this user'
    redirect_to user
  end
end
