feature 'User adds a link' do
  scenario 'using the new links form' do
    visit '/links/new'
    fill_in 'url', with: 'http://www.zombo.com'
    fill_in 'title', with: 'This is Zombocom'
    click_button 'Add link'
    expect(Link.count).to eq(1)
    expect(current_path).to eq '/links'
    expect(page).to have_content('http://www.zombo.com')
    expect(page).to have_content('This is Zombocom')
  end

  scenario 'with a tag' do
    visit '/links/new'
    fill_in 'url', with: 'http://www.makersacademy.com'
    fill_in 'title', with: 'Makers Academy'
    fill_in 'tags', with: 'education'
    click_button 'Add link'
    link = Link.first
    expect(link.tags.map(&:text)).to include('education')
  end

end
