# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    authorize! :subscribe, @question

    @question.subscribers.push(current_user)
  end
end
