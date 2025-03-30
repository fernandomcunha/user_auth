# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'users#sign_in'

  get 'users/sign_in', to: 'users#sign_in', as: :sign_in

  resources :users, only: %i[new create]
end
