require 'rails_helper'

describe 'Administrador edita buffet' do
  it 'e deve estar autenticado' do
    # Arrange
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: '12.345.678/0001-90', number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin)

    # Act
    visit edit_buffet_path(buffet.id)

    # Assert
    expect(current_path).to eq new_admin_session_path
  end

  it 'com sucesso' do
    # Arrange
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: '12.345.678/0001-90', number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin)

    # Act
    login_as(admin)
    visit root_path
    click_on 'Editar'
    fill_in 'Cidade', with: 'Sorocaba'
    fill_in 'Bairro', with: 'Campolim'
    fill_in 'CNPJ', with: '54.456.789/0001-77'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Buffet editado com sucesso'
    expect(page).to have_content 'Av. das Delícias, 1234, Campolim, Sorocaba-SP, CEP: 01234-567'
    expect(page).to have_content 'CNPJ: 54.456.789/0001-77'
  end

  it 'caso seja o responsável' do
    # Arrange
    admin1 = Admin.create!(email: 'admin1@email.com', password: 'senha123')
    admin2 = Admin.create!(email: 'admin2@email.com', password: 'senha123')
    buffet1 = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: '12.345.678/0001-90', number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin1)
    buffet2 = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: '12.345.678/0001-90', number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin2)

    # Act
    login_as(admin2)
    visit edit_buffet_path(buffet1)

    # Assert
    expect(current_path).to eq buffet_path(admin2.buffet)
    expect(page).to have_content 'Você não pode editar este buffet'
  end
end
