# frozen_string_literal: true

describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:image) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/ruby.png')) }

  describe 'GET #index' do
    let(:rewards) { create_list(:reward, 3, owner: user, image: image) }

    before do
      login(user)

      get :index
    end

    it "assigns an array of user's rewards to @rewards" do
      expect(assigns(:rewards)).to match_array(rewards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
