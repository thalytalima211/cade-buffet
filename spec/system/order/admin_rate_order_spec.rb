require 'rails_helper'

describe 'Administrador avalia pedido' do
  it 'a partir da tela de detalhes de um pedido' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [cash])
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
    expect(page).to have_button 'Aceitar pedido'
    expect(page).to have_button 'Cancelar pedido'
  end

  it 'e cancela pedido' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [cash])
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
    click_on 'Cancelar pedido'

    # Assert
    expect(current_path).to eq orders_buffet_path(buffet)
    within('#canceled-orders') do
      expect(page).to have_content order.code
    end
    within('#pending-orders') do
      expect(page).not_to have_content order.code
    end
  end

  it 'e vê campos a preencher para aceitar pedido' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    pix = PaymentMethod.create!(name: 'PIX')
    credit_card = PaymentMethod.create!(name: 'Cartão de Crédito')
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [cash, pix])
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                  default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)
    customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                          estimated_date: 1.week.from_now.next_weekday, address: 'Av. das Delícias, 1234')

    # Act
    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Pedidos'
    click_on order.code
    click_on 'Aceitar pedido'

    # Assert
    expect(page).to have_content 'Preço Padrão: R$ 25.000,00'
    expect(page).to have_field 'Data de Vencimento'
    expect(page).to have_field 'Taxa Extra'
    expect(page).to have_field 'Desconto'
    expect(page).to have_field 'Descrição do Valor'
    expect(page).to have_field 'Dinheiro'
    expect(page).to have_field 'PIX'
    expect(page).not_to have_field 'Cartão de Crédito'
  end

  it 'e precisa estar autenticado para preencher dados para aceitar pedido' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    pix = PaymentMethod.create!(name: 'PIX')
    credit_card = PaymentMethod.create!(name: 'Cartão de Crédito')
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [cash, pix])
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                  default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)
    customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                          estimated_date: 1.week.from_now.next_weekday, address: 'Av. das Delícias, 1234')

    # Act
    visit new_event_type_order_event_path(event_type, order)

    # Assert
    expect(current_path).to eq root_path
  end

  it 'e não pode preencher dados para aceitar pedido se não for o dono do buffet' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    first_admin = Admin.create!(email: 'admin1@email.com', password: 'senha123')
    second_admin = Admin.create!(email: 'admin2@email.com', password: 'senha123')
    first_buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                                  registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                                  email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                                  neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                                  description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                                  admin: first_admin, payment_methods: [cash])
    second_buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                                  registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                                  email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                                  neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                                  description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                                  admin: second_admin, payment_methods: [cash])
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
    visit new_event_type_order_event_path(event_type, order)

    # Assert
    expect(current_path).to eq buffet_path(second_buffet)
  end

  it 'e aceita pedido' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    pix = PaymentMethod.create!(name: 'PIX')
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [cash, pix])
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                  default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)
    customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                          estimated_date: 3.weeks.from_now.next_weekday, address: 'Av. das Delícias, 1234', details: 'Rosas brancas')

    # Act
    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Pedidos'
    click_on order.code
    click_on 'Aceitar pedido'
    fill_in 'Data de Vencimento', with: 2.weeks.from_now
    fill_in 'Taxa Extra', with: 200
    fill_in 'Desconto', with: 0
    fill_in 'Descrição do Valor', with: 'Adicional pelo custo das rosas brancas'
    choose 'PIX'
    click_on 'Aceitar Pedido'

    # Assert
    expect(page).to have_content 'Pedido aceito!'
    expect(page).to have_content "Pedido #{order.code}"
    expect(page).to have_content 'Tipo de Evento: Festa de Casamento'
    expect(page).to have_content 'Status: Aguardando confirmação de cliente'
    expect(page).to have_content "Data de Vencimento: #{I18n.localize(2.weeks.from_now.to_date)}"
    expect(page).to have_content 'Preço Padrão: R$ 25.000,00'
    expect(page).to have_content 'Desconto: R$ 0,00'
    expect(page).to have_content 'Taxa Extra: R$ 200,00'
    expect(page).to have_content 'Preço Final: R$ 25.200,00'
    expect(page).to have_content 'Descrição do Valor: Adicional pelo custo das rosas brancas'
    expect(page).to have_content 'Método de Pagamento: PIX'
  end

  it 'e preenche campos para aceitar pedido com dados incompletos' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    pix = PaymentMethod.create!(name: 'PIX')
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [cash, pix])
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                  default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)
    customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                          estimated_date: 3.weeks.from_now.next_weekday, address: 'Av. das Delícias, 1234', details: 'Rosas brancas')

    # Act
    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Pedidos'
    click_on order.code
    click_on 'Aceitar pedido'
    fill_in 'Data de Vencimento', with:  ''
    fill_in 'Taxa Extra', with: ''
    fill_in 'Desconto', with: ''
    click_on 'Aceitar Pedido'
    save_page

    # Assert
    expect(page).to have_content 'Não foi possível aceitar pedido'
    expect(page).to have_content 'Data de Vencimento não pode ficar em branco'
    expect(page).to have_content 'Taxa Extra não pode ficar em branco'
    expect(page).to have_content 'Desconto não pode ficar em branco'
  end
end
