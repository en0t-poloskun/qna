# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show destroy update]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.build
    @answers = @question.answers
    gon.question_id = @question.id
    gon.current_user_id = current_user&.id
  end

  def new
    @question = Question.new
    @question.links.build
    @question.reward = Reward.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
    publish_question
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      redirect_to question_path(@question), alert: "You can't delete questions from other users."
    end
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url],
                                                    reward_attributes: %i[name image])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast 'questions_channel', question_template
  end

  def question_template
    ApplicationController.render(partial: 'action_cable/question', locals: { question: @question })
  end
end
