class User < ApplicationRecord
  include ActionView::Helpers::AssetUrlHelper

  after_create :assign_mentor_ativo_badge_if_needed



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


  def has_first_connection?
    Badge.where(user_id: self.id).exists?(name: "1ª Conexão")
  end

  def first_connection_badge
    Badge.first_connection unless has_first_connection?
  end


  def active_mentorships_count
    received_requests.where(status: 'active').count
  end

  def is_mentor_active?
    active_mentorships_count > 0
  end

  def award_active_mentor_badge
    return unless mentor? && active_mentorships_count > 0

    Badge.create!(
      user_id: self.id,
      name: "Active Mentor",
      image_url: "active_mentor.png"
    )
  end

  def remove_active_mentor_badge
    badges.where(name: "Active Mentor").destroy_all
  end




  def increment_active_mentorships!
    update(active_mentorships_count: active_mentorships_count + 1)
  end

  def decrement_active_mentorships!
    update(active_mentorships_count: [active_mentorships_count - 1, 0].max)
  end

  def remove_mentor_ativo_badge
    logger.info "Removing Mentor Ativo badge for user #{self.id}"
    badges.where(name: "Mentor Ativo").destroy_all
  end

  def remove_active_mentor_badge
    logger.info "Removing Active Mentor badge for user #{self.id}"
    badges.where(name: "Active Mentor").destroy_all
  end

  def remove_badge(name)
    logger.info "Removing badge '#{name}' for user #{self.id}"
    badges.where(name: name).destroy_all
  end


  private

  def cannot_be_mentor_if_first_year
    return unless mentor? && current_year == 1

    errors.add(:mentor, 'cannot be a mentor if in the first year')
  end


end
