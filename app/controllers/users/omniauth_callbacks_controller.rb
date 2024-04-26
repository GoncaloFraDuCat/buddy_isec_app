# app/controllers/users/omniauth_callbacks_controller.rb
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # This will throw if @user is not activated
      set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    else 
      
      mysql_db = ActiveRecord::Base.establish_connection(:mysql).connection
      user_data = mysql_db.exec_query(User::USER_DATA_QUERY, [@user.email]).first
      
      
      if user_data
        binding.pry
        user_data = user_data.symbolize_keys
        transformed_user_data = {
          student_id: user_data[:student_id],
          area_of_study: user_data[:area_of_study],
          current_year: user_data[:current_year],
          name: user_data[:name],
          mentor: user_data[:current_year] != 1
        }

        @user.update(transformed_user_data)
      else
        redirect_to root_url
      end
    end
  end

  private

  def after_omniauth_failure_path_for(_scope)
    new_user_session_path
  end
end
