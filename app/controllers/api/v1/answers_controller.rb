# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      load_and_authorize_resource
      before_action :find_question, only: %i[index create]

      def index
        @question = Question.find(params[:question_id])
        render json: @question.answers
      end

      def show
        render json: @answer
      end

      def create
        @answer = @question.answers.build(answer_params)
        @answer.author = current_resource_owner

        if @answer.save
          render json: @answer, status: :created
        else
          render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def find_question
        @question = Question.find(params[:question_id])
      end

      def answer_params
        params.require(:answer).permit(:body, links_attributes: %i[name url])
      end
    end
  end
end
