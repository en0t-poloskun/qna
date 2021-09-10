# frozen_string_literal: true

describe Answer, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it 'applies a default scope to sort by attributes best and created_at' do
    expect(described_class.all.to_sql).to eq described_class.all.order('best DESC, created_at').to_sql
  end

  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:author).class_name('User') }

  it { is_expected.to have_many(:links).dependent(:destroy) }

  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
