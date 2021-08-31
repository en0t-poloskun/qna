# frozen_string_literal: true

feature 'Author of the question can reward the best answer', "
  In order to reward best answer's author
  As an author of question
  I'd like to be able to give a reward for best answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:image) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/ruby.png')) }

  background { sign_in(user) }

  describe 'When user chooses best answer for award', js: true do
    given!(:reward) { create(:reward, question: question, image: image) }
    given!(:answer) { create(:answer, question: question, author: user) }

    scenario "best answer's author receives an reward" do
      visit question_path(question)

      within '.answers' do
        click_on 'Mark as best'
      end

      visit rewards_path

      expect(page).to have_content reward.question.title
      expect(page).to have_content reward.name
      expect(page).to have_selector "img[src=\"#{url_for(reward.image).delete_prefix('http://www.example.com')}\"]"
    end
  end

  describe 'When user chooses another best answer for award', js: true do
    given(:another_user) { create(:user) }
    given!(:reward) { create(:reward, question: question, image: image, owner: user) }
    given!(:best_answer) { create(:answer, author: user, best: true) }
    given!(:another_answer) { create(:answer, question: question, author: another_user) }

    background do
      visit question_path(question)

      within ".answer[data-answer_id=\"#{another_answer.id}\"]" do
        click_on 'Mark as best'
      end
    end

    scenario 'author of previous best answer loses award' do
      visit rewards_path

      expect(page).not_to have_content reward.question.title
      expect(page).not_to have_content reward.name
      expect(page).not_to have_selector "img[src=\"#{url_for(reward.image).delete_prefix('http://www.example.com')}\"]"
    end

    scenario 'author of new best answer receives award' do
      click_on 'Sign out'
      sign_in(another_user)
      visit rewards_path

      expect(page).to have_content reward.question.title
      expect(page).to have_content reward.name
      expect(page).to have_selector "img[src=\"#{url_for(reward.image).delete_prefix('http://www.example.com')}\"]"
    end
  end
end
