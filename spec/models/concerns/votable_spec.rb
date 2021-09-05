# frozen_string_literal: true

shared_examples_for 'votable' do
  it { is_expected.to have_many(:votes).dependent(:destroy) }

  describe '#rating' do
    let(:votable) { create(described_class.to_s.underscore.to_sym) }

    it 'calculates rating' do
      create_list(:vote, 3, votable: votable)

      expect(votable.rating).to eq 3
    end
  end
end
