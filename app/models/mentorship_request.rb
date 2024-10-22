class MentorshipRequest < ApplicationRecord
  belongs_to :mentor, class_name: 'User'
  belongs_to :mentee, class_name: 'User'
  has_one :chatroom

  before_create :create_chatroom



  validates :status, presence: true

  after_update :destroy_if_rejected, if: :rejected?

  private

  def rejected?
    status == 'rejected'
  end

  def destroy_if_rejected
    destroy
  end

  def create_chatroom
    self.chatroom = Chatroom.create(mentorship_request_id: id)
  end

  def increment_user_mentorships
    User.increment_counter(:active_mentorships_count, mentor.id)
    User.increment_counter(:active_mentorships_count, mentee.id)
  end

  def decrement_user_mentorships
    User.decrement_counter(:active_mentorships_count, mentor.id)
    User.decrement_counter(:active_mentorships_count, mentee.id)
  end


end
