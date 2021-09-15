# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      skip_authorization_check

      def index
        @questions = Question.all
        render json: @questions
      end
    end
  end
end
