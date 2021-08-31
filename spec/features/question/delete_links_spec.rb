# frozen_string_literal: true

feature 'Author of question can delete attached links', "
  In order to remove unnecessary links
  As the author of the question
  I'd like to be able to delete attached links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:link) { create(:link, linkable: question) }

  describe 'authenticated user' do
    background { sign_in(user) }

    scenario 'deletes link attached to his question', js: true do
      user.questions.push(question)

      visit question_path(question)
      page.accept_confirm { click_link 'Delete link' }

      expect(page).not_to have_link link.name, href: link.url
    end

    scenario "tries to delete link attached to someone else's question" do
      visit question_path(question)

      expect(page).not_to have_link 'Delete link'
    end
  end

  scenario 'unauthenticated user tries to delete links' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete link'
  end
end
