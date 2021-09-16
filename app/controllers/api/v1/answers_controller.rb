# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      load_and_authorize_resource

      def index
        render json: @answers
      end

      def show
        render json: @answer
      end
    end
  end
end
