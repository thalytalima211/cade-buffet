require 'rails_helper'

describe 'Cliente faz pedido' do
  it 'a partir da tela de detalhes de um tipo de evento' do
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
                                  default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)

    # Act
    visit root_path
    click_on 'Sabores Divinos Buffet'
    click_on 'Festa de Casamento'

    # Assert
    expect(page).to have_link 'Fazer pedido'
  end

  it 'e deve estar autenticado' do
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
                                  default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)

    # Act
    visit root_path
    click_on 'Sabores Divinos Buffet'
    click_on 'Festa de Casamento'
    click_on 'Fazer pedido'

    # Assert
    expect(current_path).to eq new_customer_session_path
  end

  it 'e campo de endereço não aparece se o tipo de evento for realizado no endereço do buffet' do
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

    # Act
    login_as(customer, scope: :customer)
    visit root_path
    click_on 'Sabores Divinos Buffet'
    click_on 'Festa de Casamento'
    click_on 'Fazer pedido'

    # Assert
    expect(page).not_to have_field 'Endereço'
  end

  it 'e campo de endereço aparece se o tipo de evento for realizado no endereço indicado pelo cliente' do
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
                                  default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)
    customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')

    # Act
    login_as(customer, scope: :customer)
    visit root_path
    click_on 'Sabores Divinos Buffet'
    click_on 'Festa de Casamento'
    click_on 'Fazer pedido'

    # Assert
    expect(page).to have_field 'Endereço'
  end

  it 'com sucesso' do
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
                                  default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)
    customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')

    # Act
    login_as(customer, scope: :customer)
    visit root_path
    click_on 'Sabores Divinos Buffet'
    click_on 'Festa de Casamento'
    click_on 'Fazer pedido'
    fill_in 'Data Estimada', with: 1.month.from_now
    fill_in 'Quantidade de Convidados', with: 70
    fill_in 'Detalhes', with: 'Providenciar rosas brancas'
    fill_in 'Endereço', with: 'Rua dos Noivos, 700'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Pedido enviado com sucesso'
    expect(page).to have_content 'Pedido ABC12345'
    expect(page).to have_content 'Buffet: Sabores Divinos Buffet'
    expect(page).to have_content 'Tipo de Evento: Festa de Casamento'
    expect(page).to have_content 'Status: Aguardando avaliação do buffet'
    expect(page).to have_content "Data Estimada: #{I18n.localize(1.month.from_now.to_date)}"
    expect(page).to have_content 'Quantidade de Convidados: 70'
    expect(page).to have_content 'Detalhes: Providenciar rosas brancas'
    expect(page).to have_content 'Endereço: Rua dos Noivos, 700'
  end

  it 'com dados incompletos' do
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
                                  default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)
    customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')

    # Act
    login_as(customer, scope: :customer)
    visit root_path
    click_on 'Sabores Divinos Buffet'
    click_on 'Festa de Casamento'
    click_on 'Fazer pedido'
    fill_in 'Data Estimada', with: ''
    fill_in 'Quantidade de Convidados', with: ''
    fill_in 'Endereço', with: ''
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Não foi possível efetuar o pedido'
    expect(page).to have_content 'Quantidade de Convidados não pode ficar em branco'
    expect(page).to have_content 'Endereço não pode ficar em branco'
    expect(page).to have_content 'Data Estimada não pode ficar em branco'
  end
end
