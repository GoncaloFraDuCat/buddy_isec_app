require 'devise/strategies/authenticatable'
require 'oci8'

module Devise
  module Strategies
    class StudentIdAuthenticatable < Authenticatable
      def valid?
        return true
        # Check if the request contains the necessary parameters for authentication
        params[:user] && params[:user][:email] && params[:user][:password]
      end

      def authenticate!
        user = nil

        # Establish a connection to the Oracle database
        binding.pry
        # oracle_db = ActiveRecord::Base.establish_connection(:oracle_db).connection
        conn = OCI8.new('your_username', 'your_password', '//your_database_host:port/service_name')
        # Query the Oracle database for the user's credentials
        conn.exec("SELECT * FROM NOME_DA_TABLE_NO_ORACLE WHERE email = '#{params[:email]}' AND password = '#{params[:password]}'") do |row|
          user = row
        end
        # user = oracle_db.exec_query("SELECT * FROM NOME_DA_TABLE_NO_ORACLE WHERE email = '#{params[:email]}' AND password = '#{params[:password]}'")

        if user # If the user is found in the Oracle database
          # If the user is found, fetch additional data and save it to the local PostgreSQL database
          # Assuming you have a User model in your Rails app
          attrs = user.to_a.first
          local_user = User.find_by(email: attrs['email'])

          if local_user.nil? # This is user's first time logging in to the Rails app
            user_data = nil
            local_user = User.create(email: params[:email])

            # query oracle for additional data
            # user_data = oracle_db.exec_query('').first
            conn.exec('') do |row|
              user_data = row
            end

            local_user.update(user_data)

            conn.logoff # disconnect from the Oracle database
          end

          # Sign in the user
          success!(local_user)
        else
          conn.logoff # disconnect from the Oracle database

          # If the user is not found, fail the authentication
          fail!('Invalid email or password')
        end
      end
    end
  end
end

Warden::Strategies.add(:student_id_authenticatable, Devise::Strategies::StudentIdAuthenticatable)
