# frozen_string_literal: true

Rails.application.routes.draw do
  resources :questions, only: %i[new create show index] do
    resources :answers, shallow: true, only: %i[new create show]
  end
end
