# frozen_string_literal: true

feature 'User can vote for answer', "
  In order to give a rating for answer
  As an authenticated user
  I'd like to be able to vote for answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'votes for answer' do
      within '.answers' do
        click_on 'Vote for'

        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'votes against answer' do
      within '.answers' do
        click_on 'Vote against'

        expect(page).to have_content 'Rating: -1'
      end
    end
  end

  scenario 'unauthenticated user tries to vote for answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link 'Vote for'
      expect(page).not_to have_link 'Vote against'
    end
  end
end
