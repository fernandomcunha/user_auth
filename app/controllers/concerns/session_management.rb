# frozen_string_literal: true

module SessionManagement
  extend ActiveSupport::Concern

  def store_user_in_session(user)
    session[:users] ||= {}
    session[:users][user.email] = {
      name: user.name,
      email: user.email,
      password: user.password_digest
    }
  end

  def store_current_user(user_data)
    session[:current_user] = user_data
  end

  def current_user
    session[:current_user]&.with_indifferent_access
  end
end
