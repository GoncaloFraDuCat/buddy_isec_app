class User < ApplicationRecord
  include ActionView::Helpers::AssetUrlHelper

  USER_DATA_QUERY = 'SELECT * FROM users WHERE email = ?'.freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise authentication_keys: [:student_id]
  devise :omniauthable, omniauth_providers: %i[google_oauth2]

  validates :student_id, presence: true, uniqueness: true
  validates :area_of_study, presence: true
  validates :current_year, presence: true, numericality: { only_integer: true }
  validates :mentor, inclusion: { in: [true, false] }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :bio, length: { maximum: 500 }
  validate :cannot_be_mentor_if_first_year
  validates :active_mentorships_count, numericality: { greater_than_or_equal_to: 0 }
  validate :allow_blank_name



  has_many :messages
  has_many :sent_requests, class_name: 'MentorshipRequest', foreign_key: 'mentor_id'
  has_many :received_requests, class_name: 'MentorshipRequest', foreign_key: 'mentee_id'
  has_one_attached :photo
  has_many :posts, dependent: :destroy
  has_many :badges



  scope :by_area_of_study, ->(area) { where(area_of_study: area) if area.present? }
  scope :mentors, -> { where(mentor: true) }
  scope :students, -> { where(mentor: false) }

  def self.find_for_authentication(warden_conditions)
    where(student_id: warden_conditions[:student_id]).first
  end

  def default_photo
    if photo.attached?
      Cloudinary::Utils.cloudinary_url(photo.url)
    else
      ActionController::Base.helpers.asset_url('missing-pic.png')
    end
  end

  def mentor?
    mentor
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    # If the user doesn't exist, create a new one
    user ||= User.new(
      email: data['email'],
      name: data['name'],
      mentor: false
    )
    user
  end

  def cannot_be_mentor_if_first_year
    return unless mentor? && current_year == 1

    errors.add(:mentor, 'cannot be a mentor if in the first year')
  end

  def active_mentorships_count
    received_requests.where(status: 'active').count
  end


  def increment_active_mentorships
    User.increment_counter(:active_mentorships_count, id)
  end

  def decrement_active_mentorships
    User.decrement_counter(:active_mentorships_count, id)
  end

  def increment_user_mentorships
    User.increment_counter(:active_mentorships_count, mentor.id)
    User.increment_counter(:active_mentorships_count, mentee.id)
  end

  def decrement_user_mentorships
    User.decrement_counter(:active_mentorships_count, mentor.id)
    User.decrement_counter(:active_mentorships_count, mentee.id)
  end

  def check_first_connection_badge
    if user.has_badge?(Badge::FIRST_CONNECTION)
      return
    elsif user.mentee? && user.mentorship_requests.accepted.count == 1
      award_badge!(Badge::FIRST_CONNECTION)
    end
  end

  def check_active_mentor_badge
    if user.has_badge?(Badge::ACTIVE_MENTOR) && user.active_mentorships.count > 0
      return
    elsif user.active_mentorships.count > 0 && user.mentor?
      award_badge!(Badge::ACTIVE_MENTOR)
    else
      remove_badge!(Badge::ACTIVE_MENTOR)
    end
  end

  def award_badge!(badge_name)
    return if badges.pluck(:name).include?(badge_name)

    Badge.create!(user: self, name: badge_name, image_url: "#{badge_name}_badge.png")
  end

  def remove_badge!(badge_name)
    badge = badges.find_by(name: badge_name)
    badge.destroy if badge.present?
  end

  def has_badge?(badge_name)
    badges.pluck(:name).include?(badge_name)
  end


  private

  def cannot_be_mentor_if_first_year
    return unless mentor? && current_year == 1

    errors.add(:mentor, 'cannot be a mentor if in the first year')
  end
  def allow_blank_name
    if name.blank? && image_url.present?
      errors.add(:name, "can't be blank")
    end
  end

end
