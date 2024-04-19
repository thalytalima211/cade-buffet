require 'rails_helper'

describe 'Administrador se cadastra' do
  it 'com sucesso' do
    # Arrange

    # Act
    visit root_path
    click_on 'Entrar como administrador'
    click_on 'Criar uma conta'
    fill_in 'E-mail', with: 'thalyta@email.com'
    fill_in 'Senha', with: 'senha123'
    fill_in 'Confirme sua senha', with: 'senha123'
    click_on 'Cadastre-se'

    # Assert
    expect(page).to have_content 'thalyta@email.com'
    expect(page).to have_button 'Sair'
  end
end
