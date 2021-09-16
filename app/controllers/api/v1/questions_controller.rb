# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      load_and_authorize_resource

      def index
        render json: @questions
      end

      def show
        render json: @question
      end

      def create
        @question = current_resource_owner.questions.new(question_params)

        if @question.save
          render json: @question, status: :created
        else
          render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @question.update(question_params)
          render json: @question
        else
          render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @question.destroy!
        head :no_content
      end

      private

      def question_params
        params.require(:question).permit(:title, :body, links_attributes: %i[name url])
      end
    end
  end
end
