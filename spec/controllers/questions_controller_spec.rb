# frozen_string_literal: true

describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    before do
      login(user)
      get :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'creates a new Link for @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'creates a new Reward for @question' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    let(:post_create) { post :create, params: { question: question_params } }

    context 'with valid attributes' do
      let(:question_params) { attributes_for(:question) }

      it 'saves a new question in the database' do
        expect { post_create }.to change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post_create

        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      let(:question_params) { attributes_for(:question, :invalid) }

      it 'does not save the question' do
        expect { post_create }.not_to change(Question, :count)
      end

      it 're-renders new view' do
        post_create

        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'creates a new Link for @answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'when user is an author' do
      let!(:question) { create(:question, author: user) }
      let(:delete_request) { delete :destroy, params: { id: question } }

      it 'deletes the question' do
        expect { delete_request }.to change(user.questions, :count).by(-1)
      end

      it 'redirects to index' do
        delete_request

        expect(response).to redirect_to questions_path
      end
    end

    context 'when user is not an author' do
      let!(:question) { create(:question) }
      let(:delete_request) { delete :destroy, params: { id: question } }

      it 'does not delete the question' do
        expect { delete_request }.not_to change(Question, :count)
      end

      it 'redirects to show' do
        delete_request

        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    let(:patch_update) { patch :update, params: { id: question, question: question_params }, format: :js }

    context 'when user is an author' do
      let!(:question) { create(:question, author: user) }

      context 'with valid attributes' do
        let(:question_params) { { title: 'new title', body: 'new body' } }

        it 'changes question attributes' do
          patch_update
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'renders update view' do
          patch_update

          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        let(:question_params) { attributes_for(:question, :invalid) }

        it 'does not change answer attributes' do
          expect { patch_update }.not_to change(question, :title)
          expect { patch_update }.not_to change(question, :body)
        end

        it 'renders update view' do
          patch_update

          expect(response).to render_template :update
        end
      end
    end

    context 'when user is not an author' do
      let!(:question) { create(:question) }
      let(:question_params) { { title: 'new title', body: 'new body' } }

      it 'does not change question attributes' do
        expect { patch_update }.not_to change(question, :title)
        expect { patch_update }.not_to change(question, :body)
      end

      it 'renders update view' do
        patch_update
        expect(response).to render_template :update
      end
    end
  end
end
