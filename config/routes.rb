# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  concern :votable do
    member do
      post :vote_for
      post :vote_against
    end
  end

  resources :questions, except: :edit, concerns: [:votable] do
    resources :answers, shallow: true, only: %i[create destroy update], concerns: [:votable] do
      member do
        patch :mark_best
      end
    end
  end
end
