class Chatroom < ApplicationRecord
  belongs_to :mentorship_request
  has_many :messages
  has_one :mentor, through: :mentorship_request
  has_one :mentee, through: :mentorship_request


  def other_user(user)
      user == mentor ? mentee : mentor
  end
end
