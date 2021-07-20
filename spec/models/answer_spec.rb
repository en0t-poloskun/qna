# frozen_string_literal: true

describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :body }
end
