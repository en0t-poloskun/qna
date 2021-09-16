# frozen_string_literal: true

shared_examples_for 'API Deletable' do
  context 'when user is an author' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it 'deletes the resource' do
      expect { delete_destroy }.to change(user.send(association), :count).by(-1)
    end

    it 'returns 204 status' do
      delete_destroy

      expect(response).to have_http_status(:no_content)
    end
  end

  context 'when user is not an author' do
    let(:access_token) { create(:access_token) }

    it 'does not delete resource' do
      expect { delete_destroy }.not_to change(resource_class, :count)
    end

    it 'returns 403 status' do
      delete_destroy

      expect(response).to have_http_status(:forbidden)
    end
  end
end
