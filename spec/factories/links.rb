# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { 'MyLink' }
    url { 'https://www.google.com/' }
    linkable { build(:question) }
  end
end
