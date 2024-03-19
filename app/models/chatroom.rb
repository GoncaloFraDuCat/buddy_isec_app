class Chatroom < ApplicationRecord
  belongs_to :mentorship_request
  has_many :messages
end
