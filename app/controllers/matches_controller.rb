class MatchesController < ApplicationController
  def index
    @mentee_requests = if @user.mentor?
                        MentorshipRequest.where(mentor_id: @user.id)
                      else
                        MentorshipRequest.where(mentee_id: @user.id).where(status: %w[pending accepted])
                      end
  end
end
