# frozen_string_literal: true

feature 'User can subscribe to question', "
  In order to find out about new answers
  As an authenticated user
  I'd like to be able to subscribe to question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)
    end

    scenario 'subscribes to question' do
      visit question_path(question)

      click_on 'Subscribe'

      expect(page).not_to have_link 'Subscribe'
      # expect(page).to heve_link 'Unsubscribe'
    end

    scenario 'tries to subscribe twice' do
      user.subscribed_questions.push(question)

      visit question_path(question)

      expect(page).not_to have_link 'Subscribe'
    end
  end

  scenario 'unauthenticated user tries to subscribe' do
    visit question_path(question)

    expect(page).not_to have_link 'Subscribe'
  end
end
