# frozen_string_literal: true

describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    before { login(user) }

    let(:post_create) do
      post :create, params: { commentable: 'questions', question_id: question, comment: comment_params }, format: :js
    end

    context 'with valid attributes' do
      let(:comment_params) { attributes_for(:comment) }

      it 'saves a new comment for question in the database' do
        expect { post_create }.to change(question.comments, :count).by(1)
      end

      it 'assigned to author' do
        post_create

        expect(assigns(:comment).author).to eq user
      end

      it 'renders comment create template' do
        post_create

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:comment_params) { attributes_for(:comment, :invalid) }

      it 'does not save comment' do
        expect { post_create }.not_to change(Comment, :count)
      end

      it 'renders comment create template' do
        post_create

        expect(response).to render_template :create
      end
    end
  end
end
