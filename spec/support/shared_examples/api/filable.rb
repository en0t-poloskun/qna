# frozen_string_literal: true

shared_examples_for 'API Filable' do
  describe 'files' do
    let(:file) { resource.files.first }
    let(:file_json) { resource_json['files'].first }

    it 'returns list of files' do
      expect(resource_json['files'].size).to eq files.size
    end

    it 'returns file url' do
      expect(file_json['url']).to eq url_for(file).delete_prefix('http://www.example.com')
    end
  end
end
