# frozen_string_literal: true

class UsersController < ApplicationController
  def sign_in
    @user = User.new
  end

  def new
    @user = User.new
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
  end
end
