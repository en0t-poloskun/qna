# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, only: %i[new create show index destroy] do
    resources :answers, shallow: true, only: %i[new create show]
  end
end
