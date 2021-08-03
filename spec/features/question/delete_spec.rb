# frozen_string_literal: true

feature 'Author can delete his question', "
  In order not to receive more answers to the question
  As the author of the question
  I'd like to be able to delete my question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'deletes his question' do
      user.questions.push(question)

      visit question_path(question)
      click_on 'Delete Question'

      expect(page).to have_content 'Your question successfully deleted.'
      expect(page).not_to have_content question.title
      expect(page).not_to have_content question.body
    end

    scenario "tries to delete someone else's question" do
      visit question_path(question)

      expect(page).not_to have_link 'Delete Question'
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete Question'
  end
end
