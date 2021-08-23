# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :author, class_name: 'User'

  has_many :answers, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  def best_answer
    answers.find_by(best: true)
  end

  def change_best(answer)
    best_answer&.update(best: false)
    answer.update(best: true)
  end
end
