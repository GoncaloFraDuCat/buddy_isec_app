class Badge < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :image_url, presence: true
  validate :allow_blank_name

  ACTIVE_MENTOR = "active_mentor"
  FIRST_CONNECTION = "first_connection"

end

private

def allow_blank_name
  if name.blank? && image_url.present?
    errors.add(:name, "can't be blank")
  end
end
