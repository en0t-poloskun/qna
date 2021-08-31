# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { 'MyString' }
    url { 'MyString' }
    linkable { build(:question) }
  end
end
