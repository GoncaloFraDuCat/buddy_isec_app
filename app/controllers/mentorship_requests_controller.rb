class MentorshipRequestsController < ApplicationController
  before_action :set_mentorship_request, only: [:show, :update]

  def new
     @mentorship_request = MentorshipRequest.new
  end

  def create
  mentor = User.find_by(id: params[:mentor_id])
  mentee = User.find_by(id: params[:mentee_id])

  if mentor && mentee
    @mentorship_request = MentorshipRequest.new(mentor_id: mentor.id, mentee_id: mentee.id, status: 'pending')
    if @mentorship_request.save
      redirect_to matches_path(current_user), notice: 'Mentorship request sent successfully.'
    else
      redirect_to matches_path(current_user), alert: 'Failed to send mentorship request.'
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
    @mentorship_request.update(status: 'accepted')
    redirect_to matches_path, notice: 'Mentorship request accepted.'
  end

  def cancel
    @mentorship_request = MentorshipRequest.find(params[:id])
    @mentorship_request.update(status: 'cancelled')
    redirect_to matches_path, notice: 'Mentorship request cancelled.'
  end

  def show
  end

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

  private

  def set_mentorship_request
     @mentorship_request = MentorshipRequest.find(params[:id])
  end

  def mentorship_request_params
     params.require(:mentorship_request).permit(:mentor_id, :mentee_id, :status)
  end
 end
