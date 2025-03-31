# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  def set_session(vars = {})
    post test_session_path, params: { session_vars: vars }

    expect(response).to have_http_status(:created)

    vars.each_key do |var|
      expect(session[var]).to be_present
    end
  end

  let(:password) { 'PaSsWoRd!@123' }
  let(:hashed_password) { BCrypt::Password.create(password) }
  let(:current_user_data) do
    {
      current_user: { name: 'Foo Bar', email: 'foo@bar.com', password: hashed_password }
    }
  end

  describe 'GET #sign_in' do
    it 'renders the sign_in template' do
      get sign_in_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #sign_in' do
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
        post sign_in_path, params: { user: { email: 'foo@bar.com', password: password } }

        expect(session[:current_user]).to eq({
                                               'name' => 'Foo Bar',
                                               'email' => 'foo@bar.com',
                                               'password' => hashed_password
                                             })
        expect(response).to redirect_to(user_page_path)
        expect(flash[:notice]).to eq('Signed in successfully!')
      end
    end

    context 'with invalid credentials' do
      it 'does not set current_user in the session' do
        post sign_in_path, params: { user: { email: 'foo@bar.com', password: 'baz' } }

        expect(session[:current_user]).to be_nil
        expect(flash[:alert]).to eq('Invalid email or password')
      end
    end
  end

  describe 'GET #user_page' do
    context 'when signed in' do
      let(:ip_info) do
        {
          ip: '191.55.82.254',
          hostname: '191-055-082-254.xd-dynamic.algartelecom.com.br',
          city: 'Patos de Minas',
          region: 'Minas Gerais',
          country: 'BR',
          loc: '-18.5789,-46.5181',
          org: 'AS53006 ALGAR TELECOM S/A',
          postal: '38700-000',
          timezone: 'America/Sao_Paulo'
        }
      end

      before do
        set_session(current_user_data)
        allow_any_instance_of(IpInfoService).to receive(:fetch_ip_info).and_return(ip_info)
      end

      it 'render user_page template' do
        get user_page_path

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not signed in' do
      it 'redirects to the sign_in page with an alert' do
        get user_page_path

        expect(response).to redirect_to(sign_in_path)
        expect(flash[:alert]).to eq('You must be signed in to access this page.')
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

  describe 'DELETE #destroy' do
    before do
      set_session(current_user_data)
    end

    context 'when the email matches the current user' do
      it 'removes the current user from the session and redirects to root_path' do
        delete user_path('foo@bar.com')

        expect(session[:current_user]).to be_nil
        expect(flash[:notice]).to eq('You have been signed out successfully.')
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when the email does not match the current user' do
      it 'does not remove the current user and redirects to user_page_path' do
        delete user_path('bar@foo.com')

        expect(session[:current_user]).to eq({
                                               'name' => 'Foo Bar',
                                               'email' => 'foo@bar.com',
                                               'password' => hashed_password
                                             })
        expect(flash[:alert]).to eq('User with email bar@foo.com not found.')
        expect(response).to redirect_to(user_page_path)
      end
    end
  end
end
