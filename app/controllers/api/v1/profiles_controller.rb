# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      authorize_resource class: User

      def me
        render json: current_resource_owner
      end

      def index
        @profiles = User.where.not(id: current_resource_owner)
        render json: @profiles
      end
    end
  end
end
