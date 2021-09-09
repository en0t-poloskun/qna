# frozen_string_literal: true

describe Comment, type: :model do
  it { is_expected.to belong_to :commentable }
  it { is_expected.to belong_to(:author).class_name('User') }

  it { is_expected.to validate_presence_of :body }
end
