class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image


  validate :user_is_mentor

  def default_image
    if image.attached?
      Cloudinary::Utils.cloudinary_url(image.url)
    else
      ActionController::Base.helpers.asset_url('missing-pic.png')
    end
  rescue StandardError => e
    Rails.logger.error "Error generating default image: #{e.message}"
    ActionController::Base.helpers.asset_url('missing-pic.png')
  end

  def created_at
    read_attribute(:created_at) || Time.now
  end



    private

  def user_is_mentor
    errors.add(:user, "must be a mentor to create a post") unless user&.mentor?
  end

end
