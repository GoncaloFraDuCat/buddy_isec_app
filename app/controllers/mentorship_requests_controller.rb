class MentorshipRequestsController < ApplicationController
  before_action :set_mentorship_request, only: %i[show update]

  def new
    @mentorship_request = MentorshipRequest.new
  end

  def create
    mentor = User.find_by(id: params[:mentor_id])
    mentee = User.find_by(id: params[:mentee_id])

    if mentor && mentee
      existing_request = MentorshipRequest.find_by(mentor_id: mentor.id, mentee_id: mentee.id)
      if existing_request
        redirect_to matches_path(current_user), alert: 'You already have a pending request with this mentor.'
      else
        @mentorship_request = MentorshipRequest.new(mentor_id: mentor.id, mentee_id: mentee.id, status: 'pending')
        if @mentorship_request.save
          redirect_to matches_path(current_user), notice: 'Mentorship request sent successfully.'
        else
          redirect_to matches_path(current_user), alert: 'Failed to send mentorship request.'
        end
      end
    else
      redirect_to matches_path(current_user), alert: 'Invalid mentor or mentee ID.'
    end
  end

  def index
    @mentorship_requests = MentorshipRequest.all
  end

  def accept
    @mentorship_request = MentorshipRequest.find(params[:id])
    if @mentorship_request.update(status: 'accepted')
      # Assuming the chatroom is created or associated with the mentorship request
      redirect_to matches_path, notice: 'Mentorship request accepted.'
    else
      redirect_to matches_path, alert: 'Failed to accept mentorship request.'
    end
  end

  def cancel
    @mentorship_request = MentorshipRequest.find(params[:id])
    if @mentorship_request.update(status: 'cancelled')
      @mentorship_request.destroy
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
    @request = MentorshipRequest.find(params[:id])
    @request.destroy
    redirect_to matches_path, notice: 'Request was cancelled.'
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
