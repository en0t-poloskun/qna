# frozen_string_literal: true

feature 'Author can delete his answer', "
  In order to remove the answer
  As the author of the answer
  I'd like to be able to delete my answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  describe 'authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'deletes his answer', js: true do
      user.answers.push(answer)

      visit question_path(question)
      page.accept_confirm { click_link 'Delete' }

      expect(page).not_to have_content answer.body
    end

    scenario "tries to delete someone else's answer" do
      visit question_path(question)

      expect(page).not_to have_link 'Delete'
    end
  end

  scenario 'unauthenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete'
  end
end
