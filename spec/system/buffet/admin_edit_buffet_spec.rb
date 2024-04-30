require 'rails_helper'

describe 'Administrador edita buffet' do
  it 'e deve estar autenticado' do
    # Arrange
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
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
    cnpj = CNPJ.generate
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin)

    # Act
    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Editar'
    fill_in 'Cidade', with: 'Sorocaba'
    fill_in 'Bairro', with: 'Campolim'
    fill_in 'CNPJ', with: cnpj
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Buffet editado com sucesso'
    expect(page).to have_content 'Av. das Delícias, 1234, Campolim, Sorocaba-SP, CEP: 01234-567'
    expect(page).to have_content "CNPJ: #{cnpj}"
  end

  it 'caso seja o responsável' do
    # Arrange
    admin1 = Admin.create!(email: 'admin1@email.com', password: 'senha123')
    admin2 = Admin.create!(email: 'admin2@email.com', password: 'senha123')
    buffet1 = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin1)
    buffet2 = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin2)

    # Act
    login_as(admin2, scope: :admin)
    visit edit_buffet_path(buffet1)

    # Assert
    expect(current_path).to eq buffet_path(admin2.buffet)
    expect(page).to have_content 'Você não pode administrar este buffet'
  end

  it 'com dados incompletos' do
    # Arrange
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin)

    # Act
    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Editar'
    fill_in 'Cidade', with: ''
    fill_in 'Bairro', with: ''
    fill_in 'CNPJ', with: ''
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Não foi possível editar buffet'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'Bairro não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
  end
end
