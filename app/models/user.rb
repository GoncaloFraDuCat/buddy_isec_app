class User < ApplicationRecord
   include ActionView::Helpers::AssetUrlHelper

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise authentication_keys: [:student_id]
  validates :student_id, presence: true, uniqueness: true
  validates :area_of_study, presence: true
  validates :current_year, presence: true, numericality: { only_integer: true }
  validates :mentor, inclusion: { in: [true, false] }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :bio, length: { maximum: 500 }

  has_many :messages
  has_many :sent_requests, class_name: 'MentorshipRequest', foreign_key: 'mentor_id'
  has_many :received_requests, class_name: 'MentorshipRequest', foreign_key: 'mentee_id'
  has_one_attached :photo

 scope :by_area_of_study, ->(area) { where(area_of_study: area) if area.present?}

  def default_photo
    if photo.attached?
      Cloudinary::Utils.cloudinary_url(photo.url)
    else
      ActionController::Base.helpers.asset_url("missing-pic.png")
    end
  end

  def mentor?
    mentor
  end

  def self.find_for_authentication(warden_conditions)
    where(student_id: warden_conditions[:student_id]).first
  end

  validate :cannot_be_mentor_if_first_year

  private

  def cannot_be_mentor_if_first_year
    return unless mentor? && current_year == 1

    errors.add(:mentor, 'cannot be a mentor if in the first year')
  end
end
