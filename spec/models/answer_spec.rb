# frozen_string_literal: true

describe Answer, type: :model do
  it 'applies a default scope to sort by attributes best and created_at' do
    expect(described_class.all.to_sql).to eq described_class.all.order('best DESC, created_at').to_sql
  end

  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:author).class_name('User') }

  it { is_expected.to validate_presence_of :body }

  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#edit' do
    let(:answer) { create(:answer) }

    it 'changes body' do
      params = { body: 'new body' }
      answer.edit(params)
      answer.reload

      expect(answer.body).to eq 'new body'
    end

    it 'adds files' do
      answer.files.attach(Rack::Test::UploadedFile.new(Rails.root.join('Gemfile.lock')))
      params = { body: 'new body',
                 files: [Rack::Test::UploadedFile.new(Rails.root.join('Gemfile')),
                         Rack::Test::UploadedFile.new(Rails.root.join('config.ru'))] }

      answer.edit(params)
      answer.reload

      expect(answer.files.count).to eq 3
    end
  end
end
