class MatchesController < ApplicationController
  def index
    @mentee_requests = if current_user.mentor?
                         MentorshipRequest.where(mentor_id: current_user.id)
                       else
                         MentorshipRequest.where(mentee_id: current_user.id).where(status: %w[pending accepted])
                       end
  end
end
