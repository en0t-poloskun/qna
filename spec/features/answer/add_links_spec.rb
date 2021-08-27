feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question)}
  given(:url) {'https://www.google.com/'}

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'My answer'

    fill_in 'Link name', with: 'Google'
    fill_in 'Url', with: url

    click_on 'Add'

    within '.answers' do
      expect(page).to have_link 'My gist', href: url
    end
  end

end
