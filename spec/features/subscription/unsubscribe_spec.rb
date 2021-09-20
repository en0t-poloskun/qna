# frozen_string_literal: true

feature 'User can unsubscribe from question', "
  In order to stop receiving notifications about new answers
  As an authenticated user
  I'd like to be able to unsubscribe from question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)
    end

    scenario 'unsubscribes from question' do
      create(:subscription, user: user, question: question)

      visit question_path(question)

      page.accept_confirm { click_link 'Unsubscribe' }

      expect(page).not_to have_link 'Unsubscribe'
      expect(page).to have_link 'Subscribe'
    end

    scenario 'tries to unsubscribe when not subscribed' do
      visit question_path(question)

      expect(page).not_to have_link 'Unsubscribe'
    end
  end

  scenario 'unauthenticated user tries to unsubscribe' do
    visit question_path(question)

    expect(page).not_to have_link 'Unsubscribe'
  end
end
