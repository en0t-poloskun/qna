# frozen_string_literal: true

describe Answer, type: :model do
  it 'applies a default scope to sort by attributes best and created_at' do
    expect(Answer.all.to_sql).to eq Answer.all.order('best DESC, created_at').to_sql
  end

  it { should belong_to(:question) }
  it { should belong_to(:author).class_name('User') }

  it { should validate_presence_of :body }
end
