class MentorshipRequestsController < ApplicationController
  before_action :set_mentorship_request, only: %i[show update]
    after_action :award_first_connection_badge


  def new
    @mentorship_request = MentorshipRequest.new
  end

  def create
    @mentor = User.find(params[:mentor_id])
    @mentee = User.find(params[:mentee_id])

    @mentorship_request = MentorshipRequest.new(mentor_id: @mentor.id, mentee_id: @mentee.id, status: 'pending')

    if @mentorship_request.save
      # Notification logic here


      redirect_to matches_path(current_user), notice: 'Mentorship request sent successfully.'
    else
      redirect_to matches_path(current_user), alert: 'Failed to send mentorship request.'
    end
  end


  def index
    @mentorship_requests = MentorshipRequest.all
  end

  def accept
    @mentorship_request = MentorshipRequest.find(params[:id])

    if @mentorship_request.update(status: 'accepted')
      User.increment_counter(:active_mentorships_count, @mentorship_request.mentor.id)
      User.check_first_connection_badge
      User.check_active_mentor_badge
      redirect_to matches_path, notice: 'Mentorship request accepted.'
    else
      redirect_to matches_path, alert: 'Failed to accept mentorship request.'
    end
  end



  def cancel
    @mentorship_request = MentorshipRequest.find(params[:id])
    if @mentorship_request.update(status: 'cancelled')
      @mentorship_request.destroy
      User.check_first_connection_badge
      User.check_active_mentor_badge
      redirect_to matches_path, notice: 'Mentorship request cancelled and destroyed.'
    else
      redirect_to matches_path, alert: 'Failed to cancel and destroy mentorship request.'
    end
  end

  def show; end

  def update
    if @mentorship_request.update(mentorship_request_params)
      redirect_to @mentorship_request, notice: 'Request updated successfully.'
    else
      render :show
    end
  end

  def destroy
    @mentorship_request = MentorshipRequest.find(params[:id])
    if @mentorship_request.update(status: 'destroyed')
      @mentorship_request.destroy

      User.decrement_counter(:active_mentorships_count, @mentorship_request.mentor.id)
      User.decrement_counter(:active_mentorships_count, @mentorship_request.mentee.id)

      User.check_first_connection_badge
      User.check_active_mentor_badge

      redirect_to matches_path, notice: 'Mentorship request cancelled and destroyed.'
    else
      redirect_to matches_path, alert: 'Failed to cancel and destroy mentorship request.'
    end
  end



  def reject_request
    @request = MentorshipRequest.find(params[:id])
    @request.update(status: 'rejected')
  end

  private

  def set_mentorship_request
    @mentorship_request = MentorshipRequest.find(params[:id])
  end

  def mentorship_request_params
    params.require(:mentorship_request).permit(:mentor_id, :mentee_id, :status)
  end

end
