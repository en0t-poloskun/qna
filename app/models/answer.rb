# frozen_string_literal: true

class Answer < ApplicationRecord
  default_scope { order('best DESC, created_at') }

  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files

  validates :body, presence: true

  def edit(params)
    transaction do
      update(body: params[:body])
      files.attach(params[:files]) if params[:files].present?
    end
  end
end
