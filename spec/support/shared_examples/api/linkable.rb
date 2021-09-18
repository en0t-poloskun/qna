# frozen_string_literal: true

shared_examples_for 'API Linkable' do
  describe 'links' do
    let(:link) { links.first }
    let(:link_json) { resource_json['links'].first }

    it 'returns list of links' do
      expect(resource_json['links'].size).to eq links.size
    end

    it 'returns all public fields' do
      %w[id name url created_at updated_at].each do |attr|
        expect(link_json[attr]).to eq link.send(attr).as_json
      end
    end
  end
end
