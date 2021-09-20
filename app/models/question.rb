# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :author, class_name: 'User'

  has_one :reward, dependent: :destroy

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions
  has_many :subscribers, through: :subscriptions, source: :user, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, presence: true
  validates :body, presence: true

  after_create :subscribe_author

  scope :created_yesterday, -> { where(created_at: Date.yesterday.midnight..Date.yesterday.end_of_day) }

  def best_answer
    answers.find_by(best: true)
  end

  def change_best(answer)
    transaction do
      best_answer&.update!(best: false)
      answer.update!(best: true)
    end
  end

  private

  def subscribe_author
    subscribers.push(author)
  end
end
