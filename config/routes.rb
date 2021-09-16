# frozen_string_literal: true

Rails.application.routes.draw do
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
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show]
    end
  end
  mount ActionCable.server => '/cable'
end
