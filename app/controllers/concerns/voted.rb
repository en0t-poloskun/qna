# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_for vote_against destroy_vote]
  end

  def vote_for
    vote(1)
  end

  def vote_against
    vote(-1)
  end

  def destroy_vote
    @votable.votes.find_by(voter: current_user)&.destroy!

    render json: rating
  end

  private

  def vote(value)
    return if current_user.author_of?(@votable) || current_user.voted?(@votable)

    @votable.votes.create!(value: value, voter: current_user)

    render json: rating
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
