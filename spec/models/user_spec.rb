# frozen_string_literal: true

describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
end
