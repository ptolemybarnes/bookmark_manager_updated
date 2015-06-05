feature 'User signs up' do

  let(:user){ User.new(email: 'alice@example.com', password: '12345678', password_confirmation: '12345678') }
  let(:invalid_user){ User.new(email: 'alice@example.com', password: '12345678', password_confirmation: '87654321') }

  scenario 'when being a new user visiting the site' do
    expect { sign_up_as(user) }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, alice@example.com')
    expect(User.first.email).to eq('alice@example.com')
  end

  scenario 'with a password that does not match' do
    expect { sign_up_as(invalid_user) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content('Sorry, your passwords do not match')
  end

  scenario 'with an email that is already registered' do
    expect { sign_up_as(user) }.to change(User, :count).by(1)
    expect { sign_up_as(user) }.to change(User, :count).by(0)
    expect(page).to have_content('This email is already taken')
  end

  def sign_up_as(user)
    visit '/users/new'
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    fill_in :password_confirmation, with: user.password_confirmation
    click_button 'Sign up'
  end

end
