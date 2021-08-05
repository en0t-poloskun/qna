# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { 'Answer body' }
    question { build(:question) }
    author { build(:user) }

    trait :invalid do
      body { nil }
    end
  end
end
