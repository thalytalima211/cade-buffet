require 'rails_helper'

describe 'Cliente vê seus próprios pedidos' do
  it 'a partir da tela inicial' do
    # Arrange
    customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')

    # Act
    login_as(customer, scope: :customer)
    visit root_path

    # Assert
    expect(page).to have_link 'Meus Pedidos'
  end

  it 'e deve estar autenticado' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(page).not_to have_link 'Meus Pedidos'
  end

  it 'e não vê outros pedidos' do
    # Arrange
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin)
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                  default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)
    first_customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    second_customer = Customer.create!(name: 'João', cpf: CPF.generate, email: 'joao@email.com', password: 'senha123')
    first_order = Order.create!(event_type: event_type, buffet: buffet, customer: first_customer, number_of_guests: 80,
                                estimated_date: 1.month.from_now, address: 'Avenida Principal, 100')
    second_order = Order.create!(event_type: event_type, buffet: buffet, customer: first_customer, number_of_guests: 55,
                                estimated_date: 1.week.from_now, address: 'Avenida Principal, 100')
    third_order = Order.create!(event_type: event_type, buffet: buffet, customer: second_customer, number_of_guests: 67,
                                estimated_date: 2.weeks.from_now, address: 'Avenida Principal, 100')

    # Act
    login_as(first_customer, scope: :customer)
    visit root_path
    click_on 'Meus Pedidos'

    # Assert
    expect(page).to have_content first_order.code
    expect(page).to have_content second_order.code
    expect(page).not_to have_content third_order.code
  end

  it 'e não vê listagem de pedidos de outros usuarios' do
    # Arrange
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin)
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                  default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)
    first_customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    second_customer = Customer.create!(name: 'João', cpf: CPF.generate, email: 'joao@email.com', password: 'senha123')

    # Act
    login_as(first_customer, scope: :customer)
    visit customer_path(second_customer)

    # Assert
    expect(current_path).to eq customer_path(first_customer)
    expect(page).to have_content 'Você não tem acesso aos pedidos deste usuário'
  end

  it 'e visita um pedido' do
    # Arrange
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin)
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                  default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)
    customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                          estimated_date: 1.month.from_now, address: 'Av. das Delícias, 1234')

    # Act
    login_as(customer, scope: :customer)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code

    # Assert
    expect(current_path).to eq event_type_order_path(event_type, order)
    expect(page).to have_content "Pedido #{order.code}"
    expect(page).to have_content 'Buffet: Sabores Divinos Buffet'
    expect(page).to have_content 'Tipo de Evento: Festa de Casamento'
    expect(page).to have_content 'Status: Aguardando avaliação do buffet'
    expect(page).to have_content "Data Estimada: #{I18n.localize(1.month.from_now.to_date)}"
    expect(page).to have_content 'Quantidade de Convidados: 80'
    expect(page).to have_content 'Detalhes: '
    expect(page).to have_content 'Endereço: Av. das Delícias, 1234'
  end

  it 'e não visita pedidos de outros usuários' do
    # Arrange
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin)
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                  default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)
    first_customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    second_customer = Customer.create!(name: 'João', cpf: CPF.generate, email: 'joao@email.com', password: 'senha123')
    order = Order.create!(event_type: event_type, buffet: buffet, customer: first_customer, number_of_guests: 80,
                          estimated_date: 1.month.from_now, address: 'Av. das Delícias, 1234')

    # Act
    login_as(second_customer, scope: :customer)
    visit event_type_order_path(event_type, order)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem acesso a esse pedido'
  end
end
