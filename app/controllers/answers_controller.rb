# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted
  before_action :authenticate_user!
  before_action :find_answer, only: %i[destroy update mark_best]

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    @answer.save
    publish_answer
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  def mark_best
    @question = @answer.question
    MarkBestService.new(@answer, @question.reward).call
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast "question_#{@question.id}_answers",
                                 { author_id: @answer.author.id,
                                   question_author_id: @question.author.id,
                                   template: answer_template }
  end

  def answer_template
    ApplicationController.render(partial: 'action_cable/answer', locals: { answer: @answer })
  end
end
