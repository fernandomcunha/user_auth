# frozen_string_literal: true

require 'rails_helper'
require 'pry-rails'

RSpec.describe UsersController, type: :request do
  def set_session(vars = {})
    post test_session_path, params: { session_vars: vars }
    
    expect(response).to have_http_status(:created)

    vars.each_key do |var|
      expect(session[var]).to be_present
    end
  end

  describe 'GET #sign_in' do
    it 'renders the sign_in template' do
      get sign_in_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #sign_in' do
    let(:password) { 'PaSsWoRd!@123' }
    let(:hashed_password) { BCrypt::Password.create(password) }
    let(:session_data) do
      {
        users: {
          'foo@bar.com' => { name: 'Foo Bar', email: 'foo@bar.com', password: hashed_password }
        }
      }
    end

    before do
      set_session(session_data)
    end

    context 'with valid credentials' do
      it 'authenticates the user and sets current_user in the session' do
        post sign_in_path, params: { email: 'foo@bar.com', password: password }

        expect(session[:current_user]).to eq({
                                               'name' => 'Foo Bar',
                                               'email' => 'foo@bar.com',
                                               'password' => hashed_password
                                             })
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Signed in successfully!')
      end
    end

    context 'with invalid credentials' do
      it 'does not set current_user in the session' do
        post sign_in_path, params: { email: 'foo@bar.com', password: 'baz' }

        expect(session[:current_user]).to be_nil
        expect(flash[:alert]).to eq('Invalid email or password')
      end
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get new_user_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { user: { name: 'Foo Bar', email: 'foo@bar.com', password: 'PaSsWoRd!@123' } } }
    let(:invalid_params) { { user: { name: 'foo', email: 'bar', password: 'baz' } } }

    context 'with valid params' do
      it 'creates a new user and stores it in the session' do
        post users_path, params: valid_params

        expect(session[:users]).to include('foo@bar.com')
        expect(session[:users]['foo@bar.com'][:name]).to eq('Foo Bar')
        expect(flash[:notice]).to eq('User created successfully!')
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid params' do
      it 'does not store the user in the session' do
        post users_path, params: invalid_params

        expect(session[:users]).to be_nil
      end
    end
  end
end
