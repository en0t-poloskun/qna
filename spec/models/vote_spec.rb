# frozen_string_literal: true

describe Vote, type: :model do
  it { is_expected.to belong_to :votable }
  it { is_expected.to belong_to(:voter).class_name('User') }

  it { is_expected.to validate_presence_of :value }
  it { is_expected.to validate_inclusion_of(:value).in_array([-1, 1]) }
end
