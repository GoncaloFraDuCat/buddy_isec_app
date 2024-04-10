class PagesController < ApplicationController
  before_action :authenticate_user!

  def search
    # Start with all mentors
    mentors = User.where(mentor: true)

    # Filter mentors by area_of_study if a parameter is provided and not "All Areas of Study"
    mentors = mentors.by_area_of_study(params[:area_of_study]) unless params[:area_of_study] == 'Todas as Areas'

    # Select 8 random mentors from the filtered list
    @pagy, @mentors = pagy(mentors, items: 8)
  end

  def profile
    @user = current_user
  end

  def matches
    @requests = if current_user.mentor?
                  MentorshipRequest.where(mentor_id: current_user.id)
                else
                  MentorshipRequest.where(mentee_id: current_user.id) # .where(status: ['pending', 'accepted'])

                end
  end
end
