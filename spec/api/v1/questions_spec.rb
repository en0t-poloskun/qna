# frozen_string_literal: true

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    context 'when unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      let(:access_token) { create(:access_token) }
      let(:files) do
        [Rack::Test::UploadedFile.new(Rails.root.join('Gemfile.lock')),
         Rack::Test::UploadedFile.new(Rails.root.join('yarn.lock'))]
      end
      let!(:questions) { create_list(:question, 2, files: files) }
      let(:question) { questions.first }
      let(:question_json) { json['questions'].first }
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let!(:links) { create_list(:link, 3, linkable: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body author_id created_at updated_at].each do |attr|
          expect(question_json[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_json) { question_json['comments'].first }

        it 'returns list of comments' do
          expect(question_json['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(comment_json[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_json) { question_json['links'].first }

        it 'returns list of links' do
          expect(question_json['links'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_json[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file) { question.files.first }
        let(:file_json) { question_json['files'].first }

        it 'returns list of files' do
          expect(question_json['files'].size).to eq 2
        end

        it 'returns file url' do
          expect(file_json['url']).to eq url_for(file).delete_prefix('http://www.example.com')
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:files) do
      [Rack::Test::UploadedFile.new(Rails.root.join('Gemfile.lock')),
       Rack::Test::UploadedFile.new(Rails.root.join('yarn.lock'))]
    end
    let(:question) { create(:question, files: files) }

    context 'when unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_json) { json['question'] }
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let!(:links) { create_list(:link, 3, linkable: question) }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body author_id created_at updated_at].each do |attr|
          expect(question_json[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_json) { question_json['comments'].first }

        it 'returns list of comments' do
          expect(question_json['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(comment_json[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_json) { question_json['links'].first }

        it 'returns list of links' do
          expect(question_json['links'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_json[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file) { question.files.first }
        let(:file_json) { question_json['files'].first }

        it 'returns list of files' do
          expect(question_json['files'].size).to eq 2
        end

        it 'returns file url' do
          expect(file_json['url']).to eq url_for(file).delete_prefix('http://www.example.com')
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    context 'when unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post '/api/v1/questions', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post '/api/v1/questions', params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      let(:post_create) do
        post '/api/v1/questions', params: { access_token: access_token.token, question: question_params },
                                  headers: headers
      end

      context 'with valid attributes' do
        let(:question_params) { attributes_for(:question) }

        it 'returns 201 status' do
          post_create

          expect(response).to have_http_status(:created)
        end

        it 'saves a new question in the database' do
          expect { post_create }.to change(user.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        let(:question_params) { attributes_for(:question, :invalid) }

        it 'returns 422 status' do
          post_create

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not save the question' do
          expect { post_create }.not_to change(Question, :count)
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    context 'when unauthorized' do
      it 'returns 401 status if there is no access_token' do
        patch "/api/v1/questions/#{question.id}", headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        patch "/api/v1/questions/#{question.id}", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      let(:patch_update) do
        patch "/api/v1/questions/#{question.id}",
              params: { access_token: access_token.token, question: question_params },
              headers: headers
      end

      context 'with valid attributes' do
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }
        let(:question_params) { { title: 'new title', body: 'new body' } }

        it 'changes question attributes' do
          patch_update

          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'returns 200 status' do
          patch_update

          expect(response).to be_successful
        end
      end

      context 'with invalid attributes' do
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }
        let(:question_params) { attributes_for(:question, :invalid) }

        it 'does not change question attributes' do
          expect { patch_update }.not_to change(question, :title)
          expect { patch_update }.not_to change(question, :body)
        end

        it 'returns 422 status' do
          patch_update

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'when user is not an author' do
        let(:access_token) { create(:access_token) }
        let(:question_params) { { title: 'new title', body: 'new body' } }

        it 'does not change question attributes' do
          expect { patch_update }.not_to change(question, :title)
          expect { patch_update }.not_to change(question, :body)
        end

        it 'returns 403 status' do
          patch_update

          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }

    context 'when unauthorized' do
      it 'returns 401 status if there is no access_token' do
        delete "/api/v1/questions/#{question.id}", headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        delete "/api/v1/questions/#{question.id}", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      let(:delete_destroy) do
        delete "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers
      end

      context 'when user is an author' do
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }

        it 'deletes the question' do
          expect { delete_destroy }.to change(user.questions, :count).by(-1)
        end

        it 'returns 204 status' do
          delete_destroy

          expect(response).to have_http_status(:no_content)
        end
      end

      context 'when user is not an author' do
        let(:access_token) { create(:access_token) }

        it 'does not delete question' do
          expect { delete_destroy }.not_to change(Question, :count)
        end

        it 'returns 403 status' do
          delete_destroy

          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end
