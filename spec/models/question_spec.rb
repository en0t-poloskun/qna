# frozen_string_literal: true

describe Question, type: :model do
  it { should have_many(:answers) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
