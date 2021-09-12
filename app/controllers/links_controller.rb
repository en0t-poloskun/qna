# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource

  def destroy
    @link.destroy
  end
end
