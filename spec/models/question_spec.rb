# frozen_string_literal: true

describe Question, type: :model do
  it { is_expected.to belong_to(:author).class_name('User') }

  it { is_expected.to have_many(:answers).dependent(:destroy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#best_answer' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    it 'returns the best answer if it exists' do
      best_answer = create(:answer, question: question, best: true)
      expect(question.best_answer).to eq best_answer
    end

    it 'returns nil if there is no best answer' do
      expect(question.best_answer).to eq nil
    end
  end

  describe '#change_best' do
    let(:question) { create(:question) }
    let(:new_best_answer) { create(:answer, question: question) }

    context 'when question have the best answer' do
      let!(:old_best_answer) { create(:answer, question: question, best: true) }

      it "changes old best answer's attribute to false" do
        question.change_best(new_best_answer)
        old_best_answer.reload
        expect(old_best_answer.best).to eq false
      end

      it "changes new best answer's attribute to true" do
        question.change_best(new_best_answer)
        expect(new_best_answer.best).to eq true
      end
    end

    context 'when question have not the best answer' do
      it "changes new best answer's attribute to true" do
        question.change_best(new_best_answer)
        expect(new_best_answer.best).to eq true
      end
    end
  end

  describe '#edit' do
    let(:question) { create(:question) }

    it 'changes title and body' do
      params = { title: 'new title', body: 'new body' }
      question.edit(params)
      question.reload

      expect(question.title).to eq 'new title'
      expect(question.body).to eq 'new body'
    end

    it 'adds files' do
      question.files.attach(Rack::Test::UploadedFile.new(Rails.root.join('Gemfile.lock')))
      params = { title: 'new title', body: 'new body',
                 files: [Rack::Test::UploadedFile.new(Rails.root.join('Gemfile')),
                         Rack::Test::UploadedFile.new(Rails.root.join('config.ru'))] }

      question.edit(params)
      question.reload

      expect(question.files.count).to eq 3
    end
  end
end
