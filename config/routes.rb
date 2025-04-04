# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'users#sign_in'

  match 'users/sign_in', to: 'users#sign_in', via: %i[get post], as: :sign_in
  get 'users/user_page', to: 'users#user_page', as: :user_page

  resources :users, param: :email, only: %i[new create destroy], constraints: { email: %r{[^/]+} }

  if Rails.env.test?
    namespace :test do
      resource :session, only: %i[create]
    end
  end
end
