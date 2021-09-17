# frozen_string_literal: true

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Unauthorizable' do
      let(:method) { :get }
    end

    context 'when authorized' do
      let(:access_token) { create(:access_token) }
      let(:files) do
        [Rack::Test::UploadedFile.new(Rails.root.join('Gemfile.lock')),
         Rack::Test::UploadedFile.new(Rails.root.join('yarn.lock'))]
      end

      let!(:resources) { create_list(:answer, 2, files: files, question: question) }
      let(:resources_json) { json['answers'] }
      let(:resource) { resources.first }
      let(:resource_json) { resources_json.first }

      let!(:comments) { create_list(:comment, 3, commentable: resource) }
      let!(:links) { create_list(:link, 3, linkable: resource) }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'API Indexable' do
        let(:public_fields) { %w[id body author_id created_at updated_at] }
      end

      it_behaves_like 'API Comentable'

      it_behaves_like 'API Linkable'

      it_behaves_like 'API Filable'
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:files) do
      [Rack::Test::UploadedFile.new(Rails.root.join('Gemfile.lock')),
       Rack::Test::UploadedFile.new(Rails.root.join('yarn.lock'))]
    end
    let(:answer) { create(:answer, files: files) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Unauthorizable' do
      let(:method) { :get }
    end

    context 'when authorized' do
      let(:access_token) { create(:access_token) }
      let(:resource_json) { json['answer'] }
      let(:resource) { answer }

      let!(:comments) { create_list(:comment, 3, commentable: answer) }
      let!(:links) { create_list(:link, 3, linkable: answer) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Showable' do
        let(:public_fields) { %w[id body author_id created_at updated_at] }
      end

      it_behaves_like 'API Comentable'

      it_behaves_like 'API Linkable'

      it_behaves_like 'API Filable'
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Unauthorizable' do
      let(:method) { :post }
    end

    context 'when authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it_behaves_like 'API Creatable' do
        let(:post_create) do
          post api_path, params: { access_token: access_token.token, answer: resource_params }, headers: headers
        end
        let(:resource) { :answer }
        let(:association) { 'answers' }
        let(:resource_class) { Answer }
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, author: user) }

    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Unauthorizable' do
      let(:method) { :patch }
    end

    context 'when authorized' do
      it_behaves_like 'API Updatable' do
        let(:patch_update) do
          patch api_path, params: { access_token: access_token.token, answer: resource_params }, headers: headers
        end
        let(:valid_params) { { body: 'new body' } }
        let(:invalid_params) { attributes_for(:answer, :invalid) }
        let(:resource) { answer }
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:answer) { create(:answer, author: user) }

    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Unauthorizable' do
      let(:method) { :delete }
    end

    context 'when authorized' do
      it_behaves_like 'API Deletable' do
        let(:delete_destroy) { delete api_path, params: { access_token: access_token.token }, headers: headers }
        let(:association) { 'answers' }
        let(:resource_class) { Answer }
      end
    end
  end
end
