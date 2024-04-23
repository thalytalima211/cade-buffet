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

  it 'e vê buffets cadastrados' do
    # Arrange
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: '12.345.678/0001-90', number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin)
    # Act
    visit root_path

    # Assert
    expect(page).to have_content 'Sabores Divinos Buffet'
    expect(page).to have_content 'São Paulo'
    expect(page).to have_content 'SP'
  end

  it 'e vê detalhes de um buffet' do
    # Arrange
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: '12.345.678/0001-90', number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin)

    # Act
    visit root_path
    click_on 'Sabores Divinos Buffet'

    # Assert
    expect(page).to have_content 'Sabores Divinos Buffet'
    expect(page).not_to have_content 'Razão Social: Sabores Divinos Eventos Ltda.'
    expect(page).to have_content 'CNPJ: 12.345.678/0001-90'
    expect(page).to have_content 'Av. das Delícias, 1234, Centro, São Paulo-SP, CEP: 01234-567'
    expect(page).to have_content 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis'
    expect(page).to have_content '(55)5555-5555 - contato@saboresdivinos.com'
  end
end
