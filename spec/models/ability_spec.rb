# frozen_string_literal: true

describe Ability, type: :model do
  subject(:ability) { described_class.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, :all }
    it { is_expected.not_to be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { is_expected.to be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('Gemfile.lock')) }

    let(:own_question) { create :question, author: user, files: [file] }
    let(:other_question) { create :question, files: [file] }

    it { is_expected.not_to be_able_to :manage, :all }
    it { is_expected.to be_able_to :read, :all }
    it { is_expected.to be_able_to :me, User }

    context 'with questions' do
      it { is_expected.to be_able_to :create, Question }

      it { is_expected.to be_able_to :update, own_question }
      it { is_expected.not_to be_able_to :update, other_question }

      it { is_expected.to be_able_to :destroy, own_question }
      it { is_expected.not_to be_able_to :destroy, other_question }
    end

    context 'with answers' do
      let(:own_answer) { create :answer, author: user }
      let(:other_answer) { create :answer }

      it { is_expected.to be_able_to :create, Answer }

      it { is_expected.to be_able_to :update, own_answer }
      it { is_expected.not_to be_able_to :update, other_answer }

      it { is_expected.to be_able_to :destroy, own_answer }
      it { is_expected.not_to be_able_to :destroy, other_answer }
    end

    context 'with comments' do
      it { is_expected.to be_able_to :create, Comment }
    end

    context 'with links' do
      let(:own_link) { create :link, linkable: own_question }
      let(:other_link) { create :link }

      it { is_expected.to be_able_to :destroy, own_link }
      it { is_expected.not_to be_able_to :destroy, other_link }
    end

    context 'with files' do
      it { is_expected.to be_able_to :destroy, own_question.files.first }
      it { is_expected.not_to be_able_to :destroy, other_question.files.first }
    end

    context 'when marks best answer' do
      let(:answer_for_own_question) { create :answer, question: own_question }
      let(:answer_for_other_question) { create :answer, question: other_question }

      it { is_expected.to be_able_to :mark_best, answer_for_own_question }
      it { is_expected.not_to be_able_to :mark_best, answer_for_other_question }
    end

    context 'with votes' do
      before { create :vote, voter: user, votable: voted_question }

      let(:voted_question) { create :question }

      it { is_expected.to be_able_to :vote_for, other_question }
      it { is_expected.not_to be_able_to :vote_for, own_question }
      it { is_expected.not_to be_able_to :vote_for, voted_question }

      it { is_expected.to be_able_to :vote_against, other_question }
      it { is_expected.not_to be_able_to :vote_against, own_question }
      it { is_expected.not_to be_able_to :vote_against, voted_question }

      it { is_expected.to be_able_to :destroy_vote, voted_question }
      it { is_expected.not_to be_able_to :destroy_vote, other_question }
    end

    context 'with subscriptions' do
      let(:question) { create(:question) }
      let(:subscribed_question) { own_question }
      let(:own_subscription) { create(:subscription, user: user) }
      let(:other_subscription) { create(:subscription) }

      it { is_expected.to be_able_to :subscribe, question }
      it { is_expected.not_to be_able_to :subscribe, subscribed_question }

      it { is_expected.to be_able_to :destroy, own_subscription }
      it { is_expected.not_to be_able_to :destroy, other_subscription }
    end
  end
end
