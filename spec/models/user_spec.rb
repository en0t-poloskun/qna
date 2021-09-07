# frozen_string_literal: true

describe User, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:questions).dependent(:destroy) }
    it { is_expected.to have_many(:answers).dependent(:destroy) }
    it { is_expected.to have_many(:rewards).dependent(:nullify) }
    it { is_expected.to have_many(:votes).dependent(:destroy) }
  end

  describe '#author_of?' do
    subject(:user) { create(:user) }

    context 'when user is the author' do
      let(:question) { create(:question, author: user) }

      it { is_expected.to be_author_of(question) }
    end

    context 'when user is not the author' do
      let(:question) { create(:question) }

      it { is_expected.not_to be_author_of(question) }
    end
  end

  describe '#voted?' do
    subject(:user) { create(:user) }

    let(:question) { create(:question) }

    context 'when user voted' do
      before { create(:vote, votable: question, voter: user) }

      it { is_expected.to be_voted(question) }
    end

    context 'when user has not voted' do
      it { is_expected.not_to be_voted(question) }
    end
  end
end
