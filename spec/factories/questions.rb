# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'Question title' }
    body { 'Question body' }
    author { build(:user) }

    trait :invalid do
      title { nil }
    end
  end
end
