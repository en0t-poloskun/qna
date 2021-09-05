# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_for vote_against]
  end

  def vote_for
    vote(1)
  end

  def vote_against
    vote(-1)
  end

  private

  def vote(value)
    return if current_user.author_of?(@votable)

    @votable.votes.create!(value: value, voter: current_user)

    respond_to do |format|
      format.json { render json: rating }
    end
  end

  def rating
    {
      votable_class: @votable.class.to_s.downcase,
      votable_id: @votable.id,
      value: @votable.rating
    }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
