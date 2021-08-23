# frozen_string_literal: true

feature 'Author of the question can choose the best answer', "
  In order to mark a solution to his problem
  As an author of question
  I'd like to be able to mark the best answer
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
    end

    scenario 'marks the answer for his question as the best' do
      user.questions.push(question)

      visit question_path(question)

      within ".answer[data-answer_id=\"#{answers.second.id}\"]" do
        click_on 'Mark as best'
      end

      within '.answers', match: :first do
        expect(page).to have_content 'Best answer!'
        expect(page).to have_content answers.second.body
      end
    end

    scenario 'chooses another best answer for his question' do
      user.questions.push(question)
      question.answers.push(create(:answer, best: true))

      visit question_path(question)

      within ".answer[data-answer_id=\"#{answers.second.id}\"]" do
        click_on 'Mark as best'
      end

      expect(page).to have_content 'Best answer!', count: 1

      within '.answers', match: :first do
        expect(page).to have_content 'Best answer!'
        expect(page).to have_content answers.second.body
      end
    end

    scenario "tries to mark the best answer for other user's question" do
      visit question_path(question)

      expect(page).not_to have_link 'Mark as best'
    end
  end

  scenario 'Unauthenticated user tries to mark the best answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Mark as best'
  end
end
