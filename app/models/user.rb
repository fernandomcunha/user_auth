# frozen_string_literal: true

require 'bcrypt'

class User
  include ActiveModel::Model
  include ActiveModel::SecurePassword
  include BCrypt

  attr_accessor :name, :email, :password_digest, :session

  has_secure_password validations: false

  validates :name, presence: true, length: { minimum: 5, maximum: 128 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :email_validations
  validate :password_validations
  validate :email_uniqueness_in_session

  private

  def email_validations
    local_part, domain = email&.split('@')

    return if local_part.nil? || domain.nil?

    errors.add(:email, 'local-part too long') if local_part.length > 64
    errors.add(:email, 'domain too long') if domain.length > 128

    return if domain.match?(/\A[a-zA-Z0-9\-.]+\z/)

    errors.add(:email, 'invalid domain')
  end

  def password_validations
    if password.nil? || password.length < 10 || password.length > 72
      errors.add(:password, 'must be between 10 and 72 characters')
      return
    end

    validate_password_complexity
  end

  def validate_password_complexity
    digit_count = count_characters(password, '0-9')
    uppercase_count = count_characters(password, 'A-Z')
    lowercase_count = count_characters(password, 'a-z')
    special_count = count_characters(password, ' !"#$%&\'()*+,-./:;<=>?@[\]^_`{|}~')

    return unless digit_count < 2 || uppercase_count < 2 || lowercase_count < 2 || special_count < 2

    errors.add(
      :password,
      'must contain at least 2 digits, 2 uppercase letters, 2 lowercase letters, and 2 special characters.'
    )
  end

  def count_characters(string, pattern)
    string.count(pattern)
  end

  def email_uniqueness_in_session
    return unless session && session[:users]&.key?(email)

    errors.add(:email, 'email is already taken')
  end
end
