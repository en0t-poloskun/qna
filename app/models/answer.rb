# frozen_string_literal: true

class Answer < ApplicationRecord
  default_scope { order('best DESC, created_at') }

  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true
end
