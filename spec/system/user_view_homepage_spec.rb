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
    expect(page).to have_link 'Entrar como cliente'
    expect(page).to have_link 'Entrar como administrador'
  end
end
