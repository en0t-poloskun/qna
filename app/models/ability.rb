# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]

    can :update, [Question, Answer], author_id: user.id

    can :destroy, [Question, Answer], author_id: user.id
    can :destroy, [Link], linkable: { author_id: user.id }
    can :destroy, [ActiveStorage::Attachment], record: { author_id: user.id }

    can :mark_best, [Answer], question: { author_id: user.id }

    can :vote_for, [Question, Answer] do |votable|
      !user.author_of?(votable) && !user.voted?(votable)
    end

    can :vote_against, [Question, Answer] do |votable|
      !user.author_of?(votable) && !user.voted?(votable)
    end

    can :destroy_vote, [Question, Answer] do |votable|
      user.voted?(votable)
    end
  end
end
