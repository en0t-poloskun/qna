# frozen_string_literal: true

FactoryBot.define do
  factory :reward do
    name { 'Reward name' }
    question { build(:question) }
    owner { nil }
  end
end
