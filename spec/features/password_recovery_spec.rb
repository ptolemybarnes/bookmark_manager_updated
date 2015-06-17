feature 'Password reset' do

  before(:each) do
    User.create(email: 'test@test.com', password: 'secret1234',
                       password_confirmation: 'secret1234')
  end

  scenario 'requesting a password reset' do
    user = User.first

    visit '/password_reset'
    fill_in 'email', with: user.email
    click_button 'Reset password'
    user = User.first(email: user.email)

    expect(user.password_token).not_to be_nil
  end

  scenario 'resetting password' do
    user = User.first
    user.password_token = 'token'
    user.save

    visit "/users/password_reset/#{user.password_token}" 

    expect(page.status_code).to eq 200
    expect(page).to have_content('Enter a new password')
  end
end

