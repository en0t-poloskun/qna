# frozen_string_literal: true

describe Link, type: :model do
  it { is_expected.to belong_to :linkable }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }

  it { is_expected.to allow_value('https://www.google.com/').for(:url) }
  it { is_expected.not_to allow_value('badurl').for(:url) }

  describe '#gist?' do
    let(:gist_url) { 'https://gist.github.com/en0t-poloskun/f0dbcb1ccd8ba61448c5c17a08c5f90b' }
    let(:google_url) { 'https://www.google.com/' }

    context 'when link is for gist' do
      let(:link) { create(:link, url: gist_url) }

      it { expect(link).to be_gist }
    end

    context 'when link is not for gist' do
      let(:link) { create(:link, url: google_url) }

      it { expect(link).not_to be_gist }
    end
  end

  describe '#gist_content' do
    let(:gist_url) { 'https://gist.github.com/en0t-poloskun/f0dbcb1ccd8ba61448c5c17a08c5f90b' }
    let(:invalid_gist_url) { 'https://gist.github.com/en0t-poloskun/123' }

    context 'when link is valid gist' do
      let(:link) { create(:link, url: gist_url) }

      it 'returns content of gist' do
        expect(link.gist_content).to eq 'Hello world!'
      end
    end

    context 'when link is invalid gist' do
      let(:link) { create(:link, url: invalid_gist_url) }

      it { expect(link.gist_content).to eq 'Gist not found' }
    end
  end
end
