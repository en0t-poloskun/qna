# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { 'Answer body' }
    question { build(:question) }

    trait :invalid do
      body { nil }
    end
  end
end
