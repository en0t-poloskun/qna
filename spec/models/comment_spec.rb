# frozen_string_literal: true

describe Comment, type: :model do
  it { is_expected.to belong_to :commentable }
  it { is_expected.to belong_to(:author).class_name('User') }

  it { is_expected.to validate_presence_of :body }

  describe '#question' do
    let(:question) { create(:question) }

    context 'when comentable type is Question' do
      let(:comment) { create(:comment, commentable: question) }

      it { expect(comment.question).to eq question }
    end

    context 'when comentable type is Answer' do
      let(:answer) { create(:answer, question: question) }
      let(:comment) { create(:comment, commentable: answer) }

      it { expect(comment.question).to eq answer.question }
    end
  end
end
