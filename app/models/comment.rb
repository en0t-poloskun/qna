# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  def question
    case commentable_type
    when 'Question'
      commentable
    when 'Answer'
      commentable.question
    end
  end
end
