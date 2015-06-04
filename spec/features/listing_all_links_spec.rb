feature 'User browses the list of links' do

  before(:each) do
   Link.create(url: 'http://www.makersacademy.com',
               title: 'Makers Academy',
               tags: [Tag.first_or_create(text: 'education')])
   Link.create(url: 'http://www.google.com',
               title: 'Google',
               tags: [Tag.first_or_create(text: 'search')])
   Link.create(url: 'http://www.zombo.com',
               title: 'This is Zombocom',
               tags: [Tag.first_or_create(text: 'bubbles')])
   Link.create(url: 'http://www.bubble-bobble.com',
               title: 'Bubble Bobble',
               tags: [Tag.first_or_create(text: 'bubbles')])
 end

  scenario 'when visiting the links page' do
    Link.create(url: 'http://www.makersacademy.com', title: 'Makers Academy')
    visit '/links'
    expect(page.status_code).to eq 200
    expect(page).to have_content 'http://www.makersacademy.com'
  end

  scenario 'filtered by a tag' do
    visit '/tags/bubbles'
    expect(page).not_to have_content('Makers Academy')
    expect(page).not_to have_content('Code.org')
    expect(page).to have_content('This is Zombocom')
    expect(page).to have_content('Bubble Bobble')
  end

end
