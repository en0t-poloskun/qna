# frozen_string_literal: true

class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :owner, class_name: 'User', optional: true

  has_one_attached :image

  validates :name, presence: true

  validates :image, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']

  def change_owner(user)
    update!(owner: user)
  end
end
