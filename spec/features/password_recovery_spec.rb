feature 'Password reset' do

  scenario 'requesting a password reset' do
    user = User.create(email: 'test@test.com', password: 'secret1234',
                       password_confirmation: 'secret1234')

    visit '/password_reset'
    fill_in 'Email', with: user.email
    click_button 'Reset password'
    user = User.first(email: user.email)

    expect(page).to have_content 'Check your emails'
    expect(user.password_token).not_to be_nil
  end
end

