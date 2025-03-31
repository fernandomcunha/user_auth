# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserAuthenticationService do
  let(:password) { 'PaSsWoRd!@123' }
  let(:hashed_password) { BCrypt::Password.create(password) }
  let(:session) { { users: { 'foo@bar.com' => { 'password' => hashed_password } } } }
  let(:params) { { email: 'foo@bar.com', password: password } }

  subject { described_class.new(session, params) }

  describe '#authenticate' do
    context 'with valid credentials' do
      it 'returns the user data' do
        expect(subject.authenticate).to eq(session[:users]['foo@bar.com'])
      end
    end

    context 'with invalid credentials' do
      let(:params) { { email: 'foo@bar.com', password: 'wrong' } }

      it 'returns nil' do
        expect(subject.authenticate).to be_nil
      end
    end
  end
end
