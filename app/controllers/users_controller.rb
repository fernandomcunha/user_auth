# frozen_string_literal: true

class UsersController < ApplicationController
  include SessionManagement

  before_action :login_required, only: [:user_page]

  def sign_in
    request.post? ? handle_sign_in_post : handle_sign_in_get
  end

  def user_page
    @current_user = current_user
    @ip_info = IpInfoService.fetch_ip_info(request.remote_ip)
  rescue IpInfoService::IpInfoError => e
    flash[:alert] = e.message
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.merge(session: session))

    if @user.valid?
      store_user_in_session(@user)

      flash[:notice] = 'User created successfully!'

      redirect_to sign_in_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user&.dig('email') == params[:email]
      session.delete(:current_user)

      flash[:notice] = 'You have been signed out successfully.'

      redirect_to sign_in_path, status: :see_other
    else
      flash[:alert] = "User with email #{params[:email]} not found."

      redirect_to user_page_path, status: :see_other
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def login_required
    return if current_user

    flash[:alert] = 'You must be signed in to access this page.'

    redirect_to sign_in_path
  end

  def handle_sign_in_post
    user_data = UserAuthenticationService.new(session, user_params).authenticate

    if user_data
      store_current_user(user_data)

      flash[:notice] = 'Signed in successfully!'

      redirect_to user_page_path
    else
      flash[:alert] = 'Invalid email or password'

      @user = User.new(email: user_params[:email])

      render :sign_in, status: :unprocessable_entity
    end
  end

  def handle_sign_in_get
    redirect_to user_page_path if current_user

    @user = User.new
  end

  def form_action_path
    action_name == 'sign_in' ? sign_in_path : users_path
  end

  helper_method :form_action_path
end
