# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :login_required, only: [:user_page]

  def sign_in
    request.post? ? authenticate_user : initialize_user
  end

  def user_page
    @current_user ||= session[:current_user].with_indifferent_access

    ip_address = request.remote_ip

    ip_info = IpInfoService.fetch_ip_info(ip_address)
    @city = ip_info['city']
    @region = ip_info['region']
    @country = ip_info['country']
  rescue IpInfoService::IpInfoError => e
    flash[:alert] = "Failed to fetch IP info: #{e.message}"
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

  def destroy
    email = params[:email]

    if session[:current_user]&.dig('email') == email
      session.delete(:current_user)

      flash[:notice] = 'You have been signed out successfully.'

      redirect_to root_path
    else
      flash[:alert] = "User with email #{email} not found."

      redirect_to user_page_path
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

      redirect_to user_page_path
    else
      handle_invalid_credentials
    end
  end

  def initialize_user
    @user = User.new
  end

  def find_user_in_session
    session[:users]&.dig(user_params[:email])
  end

  def valid_user_credentials?(user_data)
    user_data && BCrypt::Password.new(user_data['password']) == user_params[:password]
  end

  def store_current_user(user_data)
    session[:current_user] = user_data
  end

  def handle_invalid_credentials
    flash[:alert] = 'Invalid email or password'

    @user = User.new(email: user_params[:email])

    render :sign_in
  end

  def login_required
    return if session[:current_user]

    flash[:alert] = 'You must be signed in to access this page.'

    redirect_to sign_in_path
  end

  def form_action_path
    action_name == 'sign_in' ? sign_in_path : users_path
  end

  helper_method :form_action_path
end
