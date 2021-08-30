# frozen_string_literal: true

describe Link, type: :model do
  it { is_expected.to belong_to :linkable }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }

  it { is_expected.to allow_value('https://www.google.com/').for(:url) }
  it { is_expected.not_to allow_value('badurl').for(:url) }
end
