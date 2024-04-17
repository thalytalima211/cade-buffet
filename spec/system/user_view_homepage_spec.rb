require 'rails_helper'

describe 'Usuário entra na página inicial' do
  it 'com sucesso' do
    visit root_path
    expect(page).to have_content 'Cadê Buffet?'
  end

  it 'e vê página de login caso não esteja registrado' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(current_path).to eq new_user_session_path
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_button 'Entrar'
  end
end
