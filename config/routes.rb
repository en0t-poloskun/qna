# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users
  root to: 'questions#index'

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  concern :votable do
    member do
      post :vote_for
      post :vote_against
      delete :destroy_vote
    end
  end

  resources :questions, except: :edit, concerns: [:votable] do
    resources :comments, only: %i[create], defaults: { commentable: 'questions' }
    resources :answers, shallow: true, only: %i[create destroy update], concerns: [:votable] do
      resources :comments, only: %i[create], defaults: { commentable: 'answers' }
      member do
        patch :mark_best
      end
    end
    resources :subscriptions, shallow: true, only: %i[create destroy]
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, shallow: true, only: %i[index show create update destroy]
      end
    end
  end

  mount ActionCable.server => '/cable'
end
