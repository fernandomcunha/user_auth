# frozen_string_literal: true

require 'rails_helper'
require 'pry-rails'

RSpec.describe User, type: :model do
  let(:attrs) { { name: 'FooBar', email: 'foo@bar.com', password: 'PaSsWoRd!@123' } }

  subject { described_class.new(attrs) }

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(5).is_at_most(128) }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(10).is_at_most(72) }
    it { should validate_presence_of(:email) }
    it { should allow_value('test@example.com').for(:email) }
    it { should_not allow_value('invalid-email').for(:email) }
    it { should_not allow_value('test@').for(:email) }
    it { should_not allow_value('@example.com').for(:email) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid with an email local part longer than 64 characters' do
      subject.email = "#{'a' * 65}@bar.com"
      expect(subject).not_to be_valid
    end

    it 'is not valid with an email domain longer than 128 characters' do
      subject.email = "foo@#{'a' * 129}.com"
      expect(subject).not_to be_valid
    end

    it 'is not valid with a password missing digit characters' do
      subject.password = 'PaSsWoRd!@'
      expect(subject).not_to be_valid
    end

    it 'is not valid with a password missing uppercase characters' do
      subject.password = 'password!@123'
      expect(subject).not_to be_valid
    end

    it 'is not valid with a password missing lowercase characters' do
      subject.password = 'PASSWORD!@123'
      expect(subject).not_to be_valid
    end

    it 'is not valid with a password missing special characters' do
      subject.password = 'PaSsWoRd123'
      expect(subject).not_to be_valid
    end

    describe 'email_uniqueness_in_session validation' do
      let(:session) do
        { users: { subject.email => { name: subject.name, email: subject.email, password: subject.password_digest } } }
      end

      it 'is valid when the email is not already in the session' do
        user = User.new(name: 'BarFoo', email: 'bar@foo.com', password: 'PaSsWoRd!@123', session: session)

        expect(user).to be_valid
      end

      it 'is invalid when the email is already in the session' do
        user = User.new(attrs.merge(session: session))

        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('email is already taken')
      end
    end
  end
end
