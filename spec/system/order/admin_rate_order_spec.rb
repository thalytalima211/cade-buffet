require 'rails_helper'

describe 'Administrador avalia pedido' do
  it 'a partir da tela de detalhes de um pedido' do
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
    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Pedidos'
    click_on order.code
    click_on 'Cancelar pedido'

    # Assert
    expect(current_path).to eq event_type_order_path(event_type, order)
    expect(page).to have_content 'Status: Pedido Cancelado'
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
                          estimated_date: 1.week.from_now, address: 'Av. das Delícias, 1234')

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
                          estimated_date: 3.weeks.from_now, address: 'Av. das Delícias, 1234', details: 'Rosas brancas')

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
    expect(page).to have_content 'Evento Festa de Casamento'
    expect(page).to have_content 'Status: Aguardando Confirmação de Cliente'
    expect(page).to have_content "Pedido: #{order.code}"
    expect(page).to have_content "Data de Vencimento: #{I18n.localize(2.weeks.from_now.to_date)}"
    expect(page).to have_content 'Preço Padrão: R$ 25.000,00'
    expect(page).to have_content 'Desconto: R$ 0,00'
    expect(page).to have_content 'Taxa Extra: R$ 200,00'
    expect(page).to have_content 'Preço Final: R$ 25.200,00'
    expect(page).to have_content 'Descrição do Valor: Adicional pelo custo das rosas brancas'
    expect(page).to have_content 'Método de Pagamento: PIX'
  end
end
