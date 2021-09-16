# frozen_string_literal: true

shared_examples_for 'API Comentable' do
  describe 'comments' do
    let(:comment) { comments.first }
    let(:comment_json) { resource_json['comments'].first }

    it 'returns list of comments' do
      expect(resource_json['comments'].size).to eq comments.size
    end

    it 'returns all public fields' do
      %w[id body author_id created_at updated_at].each do |attr|
        expect(comment_json[attr]).to eq comment.send(attr).as_json
      end
    end
  end
end
