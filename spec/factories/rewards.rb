# frozen_string_literal: true

FactoryBot.define do
  factory :reward do
    name { 'Reward name' }
    question { build(:question) }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/ruby.png')) }
    owner { nil }
  end
end
