class User < ApplicationRecord
attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 50 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  before_create :create_activation_digest
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

  #timeline function
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end

  # remember me / acctivate / reset password 共通
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  #remember me function
  def remember
    @remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(@remember_token))
  end
    #self.remember_token = User.new_token
    #User.digest(remember_token) (self.remember_token)

  def forget
    update_attribute(:remember_digest, nil)
  end

  #activate account function
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  #reset password function
  def create_password_digest
    @reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(@reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_expired?
    reset_sent_at < 2.hours.ago
  end

  private

   def downcase_email
     @email = email.downcase #self
   end

   def create_activation_digest
     self.activation_token = User.new_token
     self.activation_digest = User.digest(activation_token)
   end
end
