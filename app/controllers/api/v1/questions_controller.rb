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
    end
  end
end
