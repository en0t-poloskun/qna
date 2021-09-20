# frozen_string_literal: true

describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { is_expected.to belong_to(:author).class_name('User') }

  it { is_expected.to have_one(:reward).dependent(:destroy) }

  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:links).dependent(:destroy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for :links }
  it { is_expected.to accept_nested_attributes_for :reward }

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

  describe '.created_yesterday' do
    it 'includes questions created yesterday' do
      question = create(:question, created_at: Date.yesterday)
      expect(described_class.created_yesterday).to include(question)
    end

    it 'excludes questions not created yesterday' do
      question = create(:question)
      expect(described_class.created_yesterday).not_to include(question)
    end
  end
end
