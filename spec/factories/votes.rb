# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    value { 1 }
    voter { build(:user) }
    votable { build(:question) }
  end
end
