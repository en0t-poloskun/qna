# frozen_string_literal: true

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:google_url) { 'https://www.google.com/' }
  given(:yandex_url) { 'https://yandex.ru/' }
  given(:gist_url) { 'https://gist.github.com/en0t-poloskun/f0dbcb1ccd8ba61448c5c17a08c5f90b' }

  background { sign_in(user) }

  scenario 'User adds links when asks question', js: true do
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: google_url
    end

    click_on 'add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Yandex'
      fill_in 'Url', with: yandex_url
    end

    click_on 'Ask'

    expect(page).to have_link 'Google', href: google_url
    expect(page).to have_link 'Yandex', href: yandex_url
  end

  scenario 'User adds a link with errors' do
    visit new_question_path

    fill_in 'Url', with: 'badurl'

    click_on 'Ask'

    expect(page).to have_content 'Links url is invalid'
  end

  scenario 'User adds a link with gist' do
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_content 'Hello world!'
  end
end
