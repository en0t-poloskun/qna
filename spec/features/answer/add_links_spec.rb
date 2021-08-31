# frozen_string_literal: true

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:google_url) { 'https://www.google.com/' }
  given(:yandex_url) { 'https://yandex.ru/' }
  given(:gist_url) { 'https://gist.github.com/en0t-poloskun/f0dbcb1ccd8ba61448c5c17a08c5f90b' }

  background { sign_in(user) }

  describe 'When gives an answer', js: true do
    background do
      visit question_path(question)

      fill_in 'Body', with: 'My answer'
    end

    scenario 'user adds links' do
      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: google_url
      end

      click_on 'add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Yandex'
        fill_in 'Url', with: yandex_url
      end

      click_on 'Add'

      within '.answers' do
        expect(page).to have_link 'Google', href: google_url
        expect(page).to have_link 'Yandex', href: yandex_url
      end
    end

    scenario 'user adds a link with errors' do
      fill_in 'Url', with: 'badurl'

      click_on 'Add'

      expect(page).to have_content 'Links url is invalid'
    end

    scenario 'user adds a link with gist' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Add'

      within '.answers' do
        expect(page).to have_content 'Hello world!'
      end
    end
  end

  describe 'When edits answer' do
    given!(:answer) { create(:answer, question: question, author: user) }
    given!(:old_link) { create(:link, linkable: answer) }

    scenario 'user adds new link', js: true do
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        click_on 'add link'

        fill_in 'Link name', with: 'Yandex'
        fill_in 'Url', with: yandex_url

        click_on 'Save'

        expect(page).to have_link old_link.name, href: old_link.url
        expect(page).to have_link 'Yandex', href: yandex_url
      end
    end
  end
end
