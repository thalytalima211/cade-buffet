require 'rails_helper'

describe 'Autenticação - Order' do
  it 'Usuário envia pedido e não está autenticado' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet_photo = Photo.create!()
    buffet_photo.image.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')),
                              filename: 'buffet_image.jpg')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [cash], photo: buffet_photo)
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                  default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)

    # Act
    post event_type_orders_path(event_type)

    # Assert
    expect(response).to redirect_to new_customer_session_path
  end

  it 'Usuário cancela pedido e não está autenticado' do
    # Arrange
    pix = PaymentMethod.create!(name: 'PIX')
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet_photo = Photo.create!()
    buffet_photo.image.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')),
                              filename: 'buffet_image.jpg')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [pix], photo: buffet_photo)
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                  default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)
    customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                          estimated_date: 2.weeks.from_now, address: 'Av. das Delícias, 1234', details: 'Rosas brancas')

    # Act
    post cancelled_event_type_order_path(event_type, order)

    # Assert
    expect(response).to redirect_to root_path
  end

  it 'Administrador cancela pedido e não é o dono do buffet' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    first_admin = Admin.create!(email: 'admin1@email.com', password: 'senha123')
    second_admin = Admin.create!(email: 'admin2@email.com', password: 'senha123')
    buffet_photo = Photo.create!()
    buffet_photo.image.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')),
                              filename: 'buffet_image.jpg')
    first_buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                                  registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                                  email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                                  neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                                  description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                                  admin: first_admin, payment_methods: [cash], photo: buffet_photo)
    second_buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                                  registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                                  email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                                  neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                                  description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                                  admin: second_admin, payment_methods: [cash], photo: buffet_photo)
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: true, offer_parking_service: false,
                                  default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: first_buffet)
    customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    order = Order.create!(event_type: event_type, buffet: first_buffet, customer: customer, number_of_guests: 80,
                          estimated_date: 1.month.from_now, address: 'Avenida Principal, 100')

    # Act
    login_as(second_admin, scope: :admin)
    post cancelled_event_type_order_path(event_type, order)

    # Assert
    expect(response).to redirect_to root_path
  end

  it 'Usuário aceita pedido e não está autenticado' do
    # Arrange
    pix = PaymentMethod.create!(name: 'PIX')
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet_photo = Photo.create!()
    buffet_photo.image.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')),
                              filename: 'buffet_image.jpg')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [pix], photo: buffet_photo)
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                  default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)
    customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                          estimated_date: 2.weeks.from_now, address: 'Av. das Delícias, 1234', details: 'Rosas brancas')

    # Act
    post accepted_event_type_order_path(event_type, order)

    # Assert
    expect(response).to redirect_to root_path
  end

  it 'Administrador aceita pedido e não é o dono do buffet' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    first_admin = Admin.create!(email: 'admin1@email.com', password: 'senha123')
    second_admin = Admin.create!(email: 'admin2@email.com', password: 'senha123')
    buffet_photo = Photo.create!()
    buffet_photo.image.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')),
                              filename: 'buffet_image.jpg')
    first_buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                                  registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                                  email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                                  neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                                  description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                                  admin: first_admin, payment_methods: [cash], photo: buffet_photo)
    second_buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                                  registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                                  email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                                  neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                                  description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                                  admin: second_admin, payment_methods: [cash], photo: buffet_photo)
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: true, offer_parking_service: false,
                                  default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: first_buffet)
    customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    order = Order.create!(event_type: event_type, buffet: first_buffet, customer: customer, number_of_guests: 80,
                          estimated_date: 1.month.from_now, address: 'Avenida Principal, 100')

    # Act
    login_as(second_admin, scope: :admin)
    post accepted_event_type_order_path(event_type, order)

    # Assert
    expect(response).to redirect_to root_path
  end
end
