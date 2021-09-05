# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :voter, class_name: 'User'

  validates :value, presence: true, inclusion: { in: [-1, 1] }
end
