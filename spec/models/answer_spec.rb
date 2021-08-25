# frozen_string_literal: true

describe Answer, type: :model do
  it 'applies a default scope to sort by attributes best and created_at' do
    expect(described_class.all.to_sql).to eq described_class.all.order('best DESC, created_at').to_sql
  end

  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:author).class_name('User') }

  it { is_expected.to validate_presence_of :body }
end
