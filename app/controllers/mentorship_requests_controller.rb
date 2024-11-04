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
      # Check if the mentor exists and is valid
      award_badge(@mentorship_request.mentor)
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
    @mentorship_request = MentorshipRequest.find(params[:id])
    if @mentorship_request.update(status: 'destroyed')
      @mentorship_request.destroy
      User.decrement_counter(:active_mentorships_count, @mentorship_request.mentor.id)
      # Get the current count for the mentor
      current_count = User.where(id: @mentorship_request.mentor.id).sum('active_mentorships_count')
      # Remove the badge only if the count is 0
      if current_count == 0
        @mentorship_request.mentor.remove_badge("Mentor Ativo")
      end
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

  def award_first_connection_badge
    mentor = current_user
    mentor.badges.where(name: "1ª Conexão").exists? ? nil :
    Badge.create!(
      user_id: mentor.id,
      name: "1ª Conexão",
      image_url: "first_connection_badge.png"
    )
  end

  def award_badge(user)
    return unless user && user.valid?

    if user.badges.where(name: "Mentor Ativo").empty?
      Badge.create!(
        user_id: user.id,
        name: "Mentor Ativo",
        image_url: "mentor_ativo.png"
      )
    end
  end

  def remove_mentor_ativo_badge
    badges.where(name: "Mentor Ativo").destroy_all
  end


  def increment_user_mentorships
    user.increment_active_mentorships
  end

  def decrement_user_mentorships
    user.decrement_active_mentorships
  end
end
