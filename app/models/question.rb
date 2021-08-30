# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :author, class_name: 'User'

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, presence: true
  validates :body, presence: true

  def best_answer
    answers.find_by(best: true)
  end

  def change_best(answer)
    transaction do
      best_answer&.update!(best: false)
      answer.update!(best: true)
    end
  end
end
