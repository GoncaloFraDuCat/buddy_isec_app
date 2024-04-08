require 'devise/strategies/authenticatable'

module Devise
 module Strategies
    class StudentIdAuthenticatable < Authenticatable
      def valid?
        params[:user] && params[:user][:student_id].present? && params[:user][:email].present?
      end

      def authenticate!
        user = User.find_by(student_id: params[:user][:student_id], email: params[:user][:email])
        if user
          success!(user)
        else
          fail!('Invalid student ID or email')
        end
      end
    end
 end
end

Warden::Strategies.add(:student_id_authenticatable, Devise::Strategies::StudentIdAuthenticatable)
