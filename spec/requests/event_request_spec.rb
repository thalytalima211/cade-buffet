require 'rails_helper'

describe 'Event - Autenticação' do
  context 'event#confirmed' do
    it 'Usuário confirma evento e deve estar autenticado' do
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

      post confirmed_event_type_order_event_path(event_type, order, event)

      expect(response).to redirect_to new_customer_session_path
    end

    it 'Cliente confirma evento e deve ser o dono do evento' do
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
      first_customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
      second_customer = Customer.create!(name: 'João', cpf: CPF.generate, email: 'joao@email.com', password: 'senha123')
      order = Order.create!(event_type: event_type, buffet: buffet, customer: first_customer, number_of_guests: 80,
                            estimated_date: 3.weeks.from_now.next_weekday, address: 'Av. das Delícias, 1234', details: 'Rosas brancas',
                            status: :pending_confirmation)
      event = Event.create!(expiration_date: 2.weeks.from_now, surcharge: 200.00, discount: 0.00, payment_method: pix,
                            description: 'Adicional pelo custo das rosas brancas', order: order, customer: first_customer,
                            buffet: buffet)

      login_as(second_customer, scope: :customer)
      post confirmed_event_type_order_event_path(event_type, order, event)

      expect(response).to redirect_to root_path
    end
  end

  context 'event#create' do
    it 'Usuário cria um evento e deve estar autenticado' do
      loadBuffetAndEventType
      event_type = EventType.first
      customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
      order = Order.create!(event_type: event_type, buffet: event_type.buffet, customer: customer, number_of_guests: 80,
                            estimated_date: 3.weeks.from_now.next_weekday, address: 'Av. das Delícias, 1234', details: 'Rosas brancas',
                            status: :pending_confirmation)

      post event_type_order_events_path(event_type, order)

      expect(response).to redirect_to new_admin_session_path
    end

    it 'Administrador cria um evento e deve ser o dono do pedido referente ao evento' do
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

      login_as(second_admin, scope: :admin)
      post event_type_order_events_path(event_type, order)

      expect(response).to redirect_to buffet_path(second_buffet)
    end
  end
end
