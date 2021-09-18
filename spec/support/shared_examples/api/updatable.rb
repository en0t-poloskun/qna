# frozen_string_literal: true

shared_examples_for 'API Updatable' do
  context 'with valid attributes' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:resource_params) { valid_params }

    it 'changes resource attributes' do
      patch_update

      resource.reload

      resource_params.each do |key, value|
        expect(resource.send(key)).to eq value
      end
    end

    it 'returns 200 status' do
      patch_update

      expect(response).to be_successful
    end
  end

  context 'with invalid attributes' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:resource_params) { invalid_params }

    it 'does not change resource attributes' do
      patch_update
      resource.reload

      resource_params.each do |key, value|
        expect(resource.send(key)).not_to eq value
      end
    end

    it 'returns 422 status' do
      patch_update

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'when user is not an author' do
    let(:access_token) { create(:access_token) }
    let(:resource_params) { valid_params }

    it 'does not change resource attributes' do
      resource_params.each do |key, value|
        expect(resource.send(key)).not_to eq value
      end
    end

    it 'returns 403 status' do
      patch_update

      expect(response).to have_http_status(:forbidden)
    end
  end
end
