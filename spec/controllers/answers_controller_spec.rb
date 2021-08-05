# frozen_string_literal: true

require 'rails_helper'

describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: { question_id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

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

    let(:delete_request) { delete :destroy, params: { id: answer } }

    context 'when user is an author' do
      let!(:answer) { create(:answer, author: user) }

      it 'deletes the answer' do
        expect { delete_request }.to change(user.answers, :count).by(-1)
      end

      it "redirects to answer's question show" do
        delete_request
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'when user is not an author' do
      let!(:answer) { create(:answer) }

      it 'does not delete the question' do
        expect { delete_request }.to_not change(Answer, :count)
      end
    end

    it "redirects to answer's question show" do
      delete_request
      expect(response).to redirect_to question_path(answer.question)
    end
  end
end
