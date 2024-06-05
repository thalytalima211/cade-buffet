require 'rails_helper'

describe 'Cliente confirma evento' do
  it 'a partir da listagem de pedidos' do
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
                          estimated_date: 3.weeks.from_now.next_weekday, address: 'Av. das Delícias, 1234', details: 'Rosas brancas',
                          status: :pending_confirmation)
    event = Event.create!(expiration_date: 2.weeks.from_now, surcharge: 200.00, discount: 0.00, payment_method: pix,
                          description: 'Adicional pelo custo das rosas brancas', order: order, customer: customer,
                          buffet: buffet)

    # Act
    login_as(customer, scope: :customer)
    visit root_path
    click_on 'Meus Pedidos'
    within('#pending-confirmation-orders') do
      click_on order.code
    end

    # Assert
    expect(page).to have_button 'Confirmar Evento'
  end

  it 'com sucesso' do
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
                          estimated_date: 3.weeks.from_now, address: 'Av. das Delícias, 1234', details: 'Rosas brancas',
                          status: :pending_confirmation)
    event = Event.create!(expiration_date: 2.weeks.from_now, surcharge: 200.00, discount: 0.00, payment_method: pix,
                          description: 'Adicional pelo custo das rosas brancas', order: order, customer: customer,
                          buffet: buffet)

    # Act
    login_as(customer, scope: :customer)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Confirmar Evento'

    # Assert
    expect(page).to have_content 'Evento confirmado com sucesso'
    within('#accepted-orders') do
      expect(page).to have_content order.code
    end
  end

  it 'e vê caso data-limite tenha expirado' do
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
                          estimated_date: 2.weeks.from_now, address: 'Av. das Delícias, 1234', details: 'Rosas brancas',
                          status: :pending_confirmation)
    event = Event.create!(expiration_date: 1.day.from_now, surcharge: 200.00, discount: 0.00, payment_method: pix,
                          description: 'Adicional pelo custo das rosas brancas', order: order, customer: customer,
                          buffet: buffet)

    travel_to 3.days.from_now do
      # Act
      login_as(customer, scope: :customer)
      visit root_path
      click_on 'Meus Pedidos'
      within('#expired-orders') do
        click_on order.code
      end

      # Assert
      expect(page).to have_content 'Status: Pedido Expirado'
      expect(page).not_to have_button 'Confirmar Evento'
    end
  end
end
