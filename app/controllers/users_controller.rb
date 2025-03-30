# frozen_string_literal: true

class UsersController < ApplicationController
  def sign_in
    request.post? ? authenticate_user : initialize_user
  end

  def new
    initialize_user
  end

  def create
    @user = build_user

    if @user.valid?
      store_user_in_session

      flash[:notice] = 'User created successfully!'

      redirect_to root_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def build_user
    User.new(user_params.merge(session: session))
  end

  def store_user_in_session
    session[:users] ||= {}
    session[:users][@user.email] = {
      name: @user.name,
      email: @user.email,
      password: @user.password_digest
    }

    store_current_user(session[:users][@user.email])
  end

  def authenticate_user
    user_data = find_user_in_session

    if valid_user_credentials?(user_data)
      store_current_user(user_data)

      flash[:notice] = 'Signed in successfully!'

      redirect_to root_path
    else
      handle_invalid_credentials
    end
  end

  def initialize_user
    @user = User.new
  end

  def find_user_in_session
    session[:users]&.dig(params[:email])
  end

  def valid_user_credentials?(user_data)
    user_data && BCrypt::Password.new(user_data['password']) == params[:password]
  end

  def store_current_user(user_data)
    session[:current_user] = user_data
  end

  def handle_invalid_credentials
    flash.now[:alert] = 'Invalid email or password'

    @user = User.new(email: params[:email])

    render :sign_in
  end
end
