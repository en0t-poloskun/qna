# frozen_string_literal: true

feature 'User can comment answer', "
  In order to communicate with answer's author
  As an authenticated user
  I'd like to be able to comment answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'adds a comment' do
      within '.answers' do
        fill_in 'Comment', with: 'text text text'
        click_on 'Send'

        expect(page).to have_content 'text text text'
      end
    end

    scenario 'adds a comment with errors' do
      within '.answers' do
        click_on 'Send'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'unauthenticated user tries to add a comment' do
    visit question_path(question)

    expect(page).not_to have_selector '.comments_form'
  end
end
