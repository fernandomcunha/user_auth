# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe 'GET #sign_in' do
    it 'renders the sign_in template' do
      get sign_in_path

      expect(response).to have_http_status(:ok)
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
