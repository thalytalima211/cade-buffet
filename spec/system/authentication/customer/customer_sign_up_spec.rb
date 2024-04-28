require 'rails_helper'

describe 'Cliente se cadastra' do
  it 'com sucesso' do
    # Arrange

    # Act
    visit root_path
    click_on 'Entrar como cliente'
    click_on 'Criar uma conta'
    fill_in 'Nome', with: 'Thalyta'
    fill_in 'CPF', with: CPF.generate
    fill_in 'E-mail', with: 'thalyta@email.com'
    fill_in 'Senha', with: 'senha123'
    fill_in 'Confirme sua senha', with: 'senha123'
    click_on 'Cadastre-se'

    # Assert
    expect(page).to have_content 'Thalyta | thalyta@email.com'
    expect(page).to have_button 'Sair'
  end
end
