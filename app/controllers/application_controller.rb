class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  def require_login
    unless logged_in?
      redirect_to login_url
    end
  end

  def counts(user)
    @micropost_count = user.microposts.count
    @followings_count = user.followings.count
    @followers_count = user.followers.count
  end
end
