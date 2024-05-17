require 'rails_helper'

describe 'Auteniticação - Buffet' do
  it 'Admin edita buffet e não é o dono' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    admin1 = Admin.create!(email: 'admin1@email.com', password: 'senha123')
    admin2 = Admin.create!(email: 'admin2@email.com', password: 'senha123')
    buffet1 = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin1, payment_methods: [cash])
    buffet2 = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin2, payment_methods: [cash])

    # Act
    login_as(admin1, scope: :admin)
    patch buffet_path(buffet2), params: {buffet: {admin_id: 3}}

    # Assert
    expect(response).to redirect_to buffet_path(admin1.buffet)
  end

  it 'Usuário edita buffet e não está autenticado' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [cash])

    # Act
    patch buffet_path(buffet)

    # Assert
    expect(response).to redirect_to new_admin_session_path
  end

  it 'Usuário cria buffet e não está autenticado' do
    # Arrange

    # Act
    post buffets_path

    # Assert
    expect(response).to redirect_to new_admin_session_path
  end

  it 'Administrador com buffet cadastrado cria novo buffet' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [cash])

    # Act
    login_as(admin, scope: :admin)
    post buffets_path

    # Assert
    expect(response).to redirect_to root_path
  end
end
