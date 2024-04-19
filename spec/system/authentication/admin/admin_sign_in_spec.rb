require 'rails_helper'

describe 'Administrador faz login' do
  it 'com sucesso' do
    # Arrange
    Admin.create!(email: 'admin@email.com', password: 'admin123')

    # Act
    visit root_path
    click_on 'Entrar como administrador'
    fill_in 'E-mail', with: 'admin@email.com'
    fill_in 'Senha', with: 'admin123'
    click_on 'Entrar'

    # Assert
    expect(page).to have_content 'Admin logado como: admin@email.com'
    expect(page).to have_button 'Sair'
  end

  it 'e faz logout' do
    # Arrange
    Admin.create!(email: 'admin@email.com', password: 'admin123')

    # Act
    visit root_path
    click_on 'Entrar como administrador'
    fill_in 'E-mail', with: 'admin@email.com'
    fill_in 'Senha', with: 'admin123'
    click_on 'Entrar'
    click_on 'Sair'

    # Assert
    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).not_to have_content 'Admin logado como: admin@email.com'
    expect(page).not_to have_button 'Sair'
    expect(page).to have_link 'Entrar como administrador'
  end
end
