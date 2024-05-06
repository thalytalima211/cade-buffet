require 'rails_helper'

describe 'Cliente acessa buffet' do
  it 'e tenta criar um novo buffet' do
    # Arrange
    customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')

    # Act
    login_as(customer, scope: :customer)
    post buffets_path

    # Assert
    expect(response).to redirect_to root_path
  end

  it 'e tenta editar um buffet' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    admin = Admin.create!(email: 'admin1@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [cash])

    # Act
    login_as(customer, scope: :customer)
    patch buffet_path(buffet)

    # Assert
    expect(response).to redirect_to root_path
  end
end
