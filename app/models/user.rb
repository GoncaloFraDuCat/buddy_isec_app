class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :authentication_keys => [:student_id]
  validates :student_id, presence: true, uniqueness: true
  validates :area_of_study, presence: true
  validates :current_year, presence: true, numericality: { only_integer: true }
  validates :mentor, inclusion: { in: [true, false] }
  validates :name, presence: true

  def mentor?
    mentor
  end

  def self.find_for_authentication(warden_conditions)
    where(:student_id => warden_conditions[:student_id]).first
 end

 #def logout
  #sign_out(current_user)
  #redirect_to_new_user_session_path
 #end
end
