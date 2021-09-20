# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    user { build(:user) }
    question { build(:question) }
  end
end
