require 'rails_helper'

describe 'Cliente faz login' do
  it 'com sucesso' do
    # Arrange
    Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')

    # Act
    visit root_path
    click_on 'Entrar como cliente'
    fill_in 'E-mail', with: 'maria@email.com'
    fill_in 'Senha', with: 'senha123'
    click_on 'Entrar'

    # Assert
    expect(page).to have_content 'Maria | maria@email.com'
    expect(page).to have_button 'Sair'
  end

  it 'e faz logout' do
    # Arrange
    Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')

    # Act
    visit root_path
    click_on 'Entrar como cliente'
    fill_in 'E-mail', with: 'maria@email.com'
    fill_in 'Senha', with: 'senha123'
    click_on 'Entrar'
    click_on 'Sair'

    # Assert
    expect(page).not_to have_content 'Maria | maria@email.com'
    expect(page).not_to have_button 'Sair'
    expect(page).to have_content 'Logout efetuado com sucesso'
    expect(page).to have_content 'Entrar como cliente'
  end
end
