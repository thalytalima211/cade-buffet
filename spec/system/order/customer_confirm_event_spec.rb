require 'rails_helper'

describe 'Cliente confirma evento' do
  it 'a partir da listagem de pedidos' do
    # Arrange
    pix = PaymentMethod.create!(name: 'PIX')
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [pix])
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                  default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)
    customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                          estimated_date: 3.weeks.from_now, address: 'Av. das Delícias, 1234', details: 'Rosas brancas',
                          status: :accepted)
    event = Event.create!(expiration_date: 2.weeks.from_now, surcharge: 200.00, discount: 0.00, payment_method: pix,
                          description: 'Adicional pelo custo das rosas brancas', default_value: 25_000.00,
                          final_value: 25_200.00, order: order, customer: customer, buffet: buffet)

    # Act
    login_as(customer, scope: :customer)
    visit root_path
    click_on 'Meus Pedidos'
    within('#pending-confirmation') do
      click_on order.code
    end

    # Assert
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
    expect(page).to have_button 'Confirmar Evento'
  end

  it 'com sucesso' do
    # Arrange
    pix = PaymentMethod.create!(name: 'PIX')
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [pix])
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                  default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)
    customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                          estimated_date: 3.weeks.from_now, address: 'Av. das Delícias, 1234', details: 'Rosas brancas',
                          status: :accepted)
    event = Event.create!(expiration_date: 2.weeks.from_now, surcharge: 200.00, discount: 0.00, payment_method: pix,
                          description: 'Adicional pelo custo das rosas brancas', default_value: 25_000.00,
                          final_value: 25_200.00, order: order, customer: customer, buffet: buffet)

    # Act
    login_as(customer, scope: :customer)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Confirmar Evento'

    # Assert
    expect(page).to have_content 'Evento confirmado com sucesso'
    expect(page).to have_content 'Status: Evento Confirmado'
    expect(page).not_to have_button 'Confirmar Evento'
  end

  it 'e vê caso data-limite tenha expirado' do
    # Arrange
    pix = PaymentMethod.create!(name: 'PIX')
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [pix])
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                  default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)
    customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                          estimated_date: 2.weeks.from_now, address: 'Av. das Delícias, 1234', details: 'Rosas brancas',
                          status: :accepted)
    event = Event.create!(expiration_date: 1.day.ago, surcharge: 200.00, discount: 0.00, payment_method: pix,
                          description: 'Adicional pelo custo das rosas brancas', default_value: 25_000.00,
                          final_value: 25_200.00, order: order, customer: customer, buffet: buffet)

    # Act
    login_as(customer, scope: :customer)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code

    # Assert
    expect(page).to have_content 'Data de vencimento expirada!'
    expect(page).not_to have_button 'Confirmar Evento'
  end
end
