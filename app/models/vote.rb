# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :voter, class_name: 'User'

  validates :value, presence: true, inclusion: { in: [-1, 1] }
  validates :voter, uniqueness: { scope: %i[votable_id votable_type] }
end
