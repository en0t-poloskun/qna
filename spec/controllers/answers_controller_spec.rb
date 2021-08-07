# frozen_string_literal: true

require 'rails_helper'

describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    before { login(user) }

    let(:post_create) { post :create, params: { question_id: question, answer: answer_params }, format: :js }

    context 'with valid attributes' do
      let(:answer_params) { attributes_for(:answer) }

      it 'saves a new answer for question in the database' do
        expect { post_create }.to change(question.answers, :count).by(1)
      end

      it 'assigned to author' do
        post_create
        expect(assigns(:answer).author).to eq user
      end

      it 'renders question show template' do
        post_create
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:answer_params) { attributes_for(:answer, :invalid) }

      it 'does not save the answer' do
        expect { post_create }.to_not change(Answer, :count)
      end

      it 'renders question show template' do
        post_create
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let(:delete_request) { delete :destroy, params: { id: answer }, format: :js }

    context 'when user is an author' do
      let!(:answer) { create(:answer, author: user) }

      it 'deletes the answer' do
        expect { delete_request }.to change(user.answers, :count).by(-1)
      end

      it 'renders destroy view' do
        delete_request
        expect(response).to render_template :destroy
      end
    end

    context 'when user is not an author' do
      let!(:answer) { create(:answer) }

      it 'does not delete the answer' do
        expect { delete_request }.to_not change(Answer, :count)
      end

      it 'renders destroy view' do
        delete_request
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    let(:patch_update) { patch :update, params: { id: answer, answer: answer_params }, format: :js }

    context 'when user is an author' do
      let!(:answer) { create(:answer, author: user) }

      context 'with valid attributes' do
        let(:answer_params) { { body: 'new body' } }

        it 'changes answer attributes' do
          patch_update
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch_update
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        let(:answer_params) { attributes_for(:answer, :invalid) }

        it 'does not change answer attributes' do
          expect { patch_update }.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch_update
          expect(response).to render_template :update
        end
      end
    end

    context 'when user is not an author' do
      let!(:answer) { create(:answer) }
      let(:answer_params) { { body: 'new body' } }

      it 'does not change answer attributes' do
        expect { patch_update }.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch_update
        expect(response).to render_template :update
      end
    end
  end
end
