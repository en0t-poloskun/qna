# frozen_string_literal: true

describe Subscription, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:question) }
end
