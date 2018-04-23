class Micropost < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }
  validate :picture_size

  def picture_size
    if picture.size > 5.megabyte
      errors.add(:add, 'should be less than 5MB')
    end
  end
end
