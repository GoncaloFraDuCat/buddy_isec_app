class MentorshipRequestsController < ApplicationController
  before_action :set_mentorship_request, only: %i[show update]
    after_action :award_first_connection_badge


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
      @mentorship_request.mentor.increment_active_mentorships!
      @mentorship_request.mentee.increment_active_mentorships!

      # Check if the mentor exists and is valid
      if @mentorship_request.mentor && @mentorship_request.mentor.valid?
        # Create the badge if the mentor doesn't have it yet
        if @mentorship_request.mentor.badges.where(name: "Mentor Ativo").empty?
          Badge.create!(
            user_id: @mentorship_request.mentor.id,
            name: "Mentor Ativo",
            image_url: "mentor_ativo.png"
          )
        end
      end

      redirect_to matches_path, notice: 'Mentorship request accepted.'
    else
      redirect_to matches_path, alert: 'Failed to accept mentorship request.'
    end
  end



  def cancel
    @mentorship_request = MentorshipRequest.find(params[:id])
    if @mentorship_request.update(status: 'cancelled')
      @mentorship_request.destroy
      @mentorship_request.mentor.remove_badge("Mentor Ativo")
      @mentorship_request.mentee.remove_badge("Mentor Ativo")

      @mentorship_request.mentor.decrement_active_mentorships!
      @mentorship_request.mentee.decrement_active_mentorships!

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
    if @request.destroy
      @request.mentor.remove_badge("Mentor Ativo")
      @request.mentee.remove_badge("Mentor Ativo")

      @request.mentor.decrement_active_mentorships!
      @request.mentee.decrement_active_mentorships!

      redirect_to matches_path, notice: 'Mentorship request was cancelled.'
    else
      redirect_to matches_path, alert: 'Failed to cancel mentorship request.'
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

  def award_mentor_ativo_badge
    return unless mentor? && active_mentorships_count > 0

    Badge.create!(
      user_id: id,
      name: "Mentor Ativo",
      image_url: "mentor_ativo_badge.png"
    )
  end

  def remove_mentor_ativo_badge
    badges.where(name: "Mentor Ativo").destroy_all
  end

end
