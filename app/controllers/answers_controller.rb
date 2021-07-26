# frozen_string_literal: true

class AnswersController < ApplicationController
  def show
    @answer = Answer.find(params[:id])
  end

  def new
    @question = Question.find(params[:question_id])
    @answer = Answer.new
  end
end
