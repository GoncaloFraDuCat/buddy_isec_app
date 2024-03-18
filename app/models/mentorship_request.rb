class MentorshipRequest < ApplicationRecord
  belongs_to :mentor, class_name: 'User'
  belongs_to :mentee, class_name: 'User'

  validates :status, presence: true

  after_update :destroy_if_rejected, if: :rejected?

  private

  def rejected?
    status == 'rejected'
  end

  def destroy_if_rejected
    destroy
  end
end
