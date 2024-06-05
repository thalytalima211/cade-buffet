require 'rails_helper'

describe 'Administrador vê pedidos' do
  it 'a partir da tela inicial' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
    buffet_photo = Photo.create!()
    buffet_photo.image.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')),
                              filename: 'buffet_image.jpg')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [cash], photo: buffet_photo)

    # Act
    login_as(admin, scope: :admin)
    visit root_path

    # Assert
    expect(page).to have_link 'Pedidos'
  end

  it 'e não vê botão para pedidos se não estiver autenticado' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(page).not_to have_link 'Pedidos'
  end

  it 'e deve estar autenticado' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
    buffet_photo = Photo.create!()
    buffet_photo.image.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')),
                              filename: 'buffet_image.jpg')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [cash], photo: buffet_photo)

    # Act
    visit orders_buffet_path(buffet)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem acesso aos pedidos desse buffet'
  end

  it 'e deve ter um buffet cadastrado' do
    # Arrange
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')

    # Act
    login_as(admin, scope: :admin)
    visit root_path

    # Assert
    expect(page).not_to have_link 'Pedidos'
  end

  it 'e vê seus próprios pedidos' do
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
    first_event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                        min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                        offer_decoration: true, offer_drinks: true, offer_parking_service: false,
                                        default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                        extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                        weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                        buffet: first_buffet)
    second_event_type = EventType.create!(name: 'Festa de Aniversário', description: 'Assopre as velinhas conosco',
                                          min_guests: 15, max_guests: 90, default_duration: 120, menu: 'Salgadinhos e bolo de aniversário',
                                          offer_decoration: true, offer_drinks: false, offer_parking_service: false,
                                          default_address: :indicated_address, min_value: 8_000.00, additional_per_guest: 100.00,
                                          extra_hour_value: 900.00, weekend_min_value: 12_000.00,
                                          weekend_additional_per_guest: 200.00, weekend_extra_hour_value: 1_200.00,
                                          buffet: second_buffet)
    customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    first_order = Order.create!(event_type: first_event_type, buffet: first_buffet, customer: customer, number_of_guests: 80,
                                estimated_date: 1.month.from_now, address: 'Avenida Principal, 100')
    second_order = Order.create!(event_type: second_event_type, buffet: second_buffet, customer: customer, number_of_guests: 55,
                                estimated_date: 1.week.from_now, address: 'Avenida Principal, 100')
    third_order = Order.create!(event_type: first_event_type, buffet: first_buffet, customer: customer, number_of_guests: 67,
                                estimated_date: 2.weeks.from_now, address: 'Avenida Principal, 100')

    # Act
    login_as(first_admin, scope: :admin)
    visit root_path
    click_on 'Pedidos'

    # Assert
    within('#pending-orders') do
      expect(page).to have_content first_order.code
      expect(page).not_to have_content second_order.code
      expect(page).to have_content third_order.code
    end
  end

  it 'e visita um pedido' do
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
                                  default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)
    customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                          estimated_date: 1.month.from_now, address: 'Av. das Delícias, 1234')

    # Act
    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Pedidos'
    click_on order.code

    # Assert
    expect(current_path).to eq event_type_order_path(event_type, order)
    expect(page).to have_content "Pedido #{order.code}"
    expect(page).to have_content "Cliente: Maria | maria@email.com"
    expect(page).to have_content 'Buffet: Sabores Divinos Buffet'
    expect(page).to have_content 'Tipo de Evento: Festa de Casamento'
    expect(page).to have_content 'Status: Aguardando avaliação do buffet'
    expect(page).to have_content "Data Estimada: #{I18n.localize(1.month.from_now.to_date)}"
    expect(page).to have_content 'Quantidade de Convidados: 80'
    expect(page).to have_content 'Detalhes: '
    expect(page).to have_content 'Endereço: Av. das Delícias, 1234'
  end

  it 'e vê caso exista outro pedido em seu buffet com a mesma data estimada' do
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
    customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    first_order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                                estimated_date: 1.month.from_now, address: 'Av. das Delícias, 1234', status: :accepted)
    event = Event.create!(payment_method: cash, order: first_order, customer: customer, buffet: buffet,
                          expiration_date: 2.weeks.from_now, surcharge: 0.00, discount: 0.00, description: 'Evento Padrão')
    second_order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 45,
                                estimated_date: 1.month.from_now, address: 'Av. dos Noivos, 14')

    # Act
    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Pedidos'
    click_on second_order.code

    # Assert
    expect(page).to have_content 'Atenção: Há outro pedido em seu buffet estimado para esta mesma data'
  end

  it 'e não vê listagem de pedidos de outro buffet' do
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

    # Act
    login_as(first_admin, scope: :admin)
    visit orders_buffet_path(second_buffet)

    # Assert
    expect(current_path).to eq buffet_path(first_buffet)
    expect(page).to have_content 'Você não tem acesso aos pedidos desse buffet'
  end

  it 'e não visita detalhes de pedidos de outros buffets' do
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
    visit event_type_order_path(event_type, order)

    # Assert
    expect(page).to have_content 'Você não tem acesso a esse pedido'
  end
end
