class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 50 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_relationships, class_name: 'Relationship', foreign_key: :follow_id, dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :user
  has_many :favorites, dependent: :destroy
  has_many :favorite_microposts, through: :favorites, source: :micropost

  #follow function
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  #favorite function
  def like(micropost)
    self.favorites.find_or_create_by(micropost_id: micropost.id)
  end

  def unlike(micropost)
    favorite = self.favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end

  def like?(micropost)
    self.favorite_microposts.include?(micropost)
  end

  #remember me function
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(:remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  #timeline function
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
end
