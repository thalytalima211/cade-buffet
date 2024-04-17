require 'rails_helper'

describe 'Usuário se cadastra' do
  it 'como dono de buffet' do
    # Arrange

    # Act
    visit root_path
    click_on 'Criar uma conta'
    fill_in 'E-mail', with: 'thalyta@email.com'
    fill_in 'Senha', with: 'senha123'
    fill_in 'Confirme sua senha', with: 'senha123'
    click_on 'Cadastre-se como dono de buffet'

    # Assert
    expect(page).to have_content('Bem vindo! Você realizou seu registro com sucesso.')
    expect(current_path).to eq new_buffet_path
  end
end
