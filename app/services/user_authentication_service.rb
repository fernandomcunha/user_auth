# frozen_string_literal: true

class UserAuthenticationService
  def initialize(session, params)
    @session = session
    @params = params
  end

  def authenticate
    user_data = find_user_in_session

    return unless valid_user_credentials?(user_data)

    user_data
  end

  private

  def find_user_in_session
    @session[:users]&.dig(@params[:email])
  end

  def valid_user_credentials?(user_data)
    user_data && BCrypt::Password.new(user_data['password']) == @params[:password]
  end
end
