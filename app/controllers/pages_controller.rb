class PagesController < ApplicationController
  before_action :authenticate_user!

  def search
    @mentors = User.where(mentor: true).sample(8) || []
  end

  def profile
    @user = current_user
  end

  def homepage; end

  def matches
    @requests = if current_user.mentor?
                  MentorshipRequest.where(mentor_id: current_user.id)
                else
                  MentorshipRequest.where(mentee_id: current_user.id) # .where(status: ['pending', 'accepted'])

                end
  end
end
