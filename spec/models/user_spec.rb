# frozen_string_literal: true

describe User, type: :model do
  describe 'Associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'User #author_of?' do
    let(:user) { create(:user) }

    it 'returns true if user is the author of resource' do
      question = create(:question, author: user)
      expect(user.author_of?(question)).to eq true
    end

    it 'returns false if user is not the author of resource' do
      question = create(:question)
      expect(user.author_of?(question)).to eq false
    end
  end
end
