class MentorshipRequest < ApplicationRecord
  belongs_to :mentor, class_name: 'User'
  belongs_to :mentee, class_name: 'User'
  has_one :chatroom

  before_create :create_chatroom

  after_create :increment_mentor_and_mentee_counts
  after_destroy :decrement_mentor_and_mentee_counts

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

  def increment_mentor_and_mentee_counts
    mentor.increment_active_mentorships!
    mentee.increment_active_mentorships!
  end

  def decrement_mentor_and_mentee_counts
    mentor.decrement_active_mentorships!
    mentee.decrement_active_mentorships!
  end


end
