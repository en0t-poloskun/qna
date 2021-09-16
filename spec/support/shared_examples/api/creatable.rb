# frozen_string_literal: true

shared_examples_for 'API Creatable' do
  context 'with valid attributes' do
    let(:resource_params) { attributes_for(resource) }

    it 'returns 201 status' do
      post_create

      expect(response).to have_http_status(:created)
    end

    it 'saves a new resource in the database' do
      expect { post_create }.to change(user.send(association), :count).by(1)
    end
  end

  context 'with invalid attributes' do
    let(:resource_params) { attributes_for(resource, :invalid) }

    it 'returns 422 status' do
      post_create

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'does not save the resource' do
      expect { post_create }.not_to change(resource_class, :count)
    end
  end
end
