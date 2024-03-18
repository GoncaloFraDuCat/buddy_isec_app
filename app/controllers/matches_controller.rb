class MatchesController < ApplicationController
  def index
    if current_user.mentor?
      @mentee_requests = MentorshipRequest.where(mentor_id: current_user.id)
    else
      @mentee_requests = MentorshipRequest.where(mentee_id: current_user.id).where(status: ['pending', 'accepted'])
    end
  end
end
