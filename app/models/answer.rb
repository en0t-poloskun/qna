# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable
  include Commentable

  default_scope { order('best DESC, created_at') }

  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  after_create :send_notification

  private

  def send_notification
    AnswerNotificationsJob.perform_later(self)
  end
end
