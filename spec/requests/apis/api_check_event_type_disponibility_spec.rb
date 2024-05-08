require 'rails_helper'

describe 'API checa disponibilidade de um tipo de evento' do
  context 'POST /api/v1/orders' do
    it 'E vê valor prévio do pedido' do
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
                                    offer_decoration: true, offer_drinks: true, offer_parking_service: false,
                                    default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                    extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                    weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                    buffet: buffet)
      order_params = {order: {event_type_id: event_type.id, estimated_date: '2024-05-09', number_of_guests: 40}}

      # Act
      post '/api/v1/orders', params: order_params

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['default_value'].to_f).to eq 15_000.00
    end

    it 'E vê se evento não está disponível' do
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
                                    offer_decoration: true, offer_drinks: true, offer_parking_service: false,
                                    default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                    extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                    weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                    buffet: buffet)
      customer =  Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
      Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                    estimated_date: 2.weeks.from_now, address: 'Av. das Delícias, 1234', details: 'Rosas brancas',
                    status: :accepted)
      order_params = {order: {event_type_id: event_type.id, estimated_date: 2.weeks.from_now, number_of_guests: 120}}

      # Act
      post '/api/v1/orders', params: order_params

      # Assert
      expect(response.status).to eq 412
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Data Estimada já está agendada em outro pedido'
      expect(response.body).to include 'Quantidade de Convidados deve ser menor ou igual a 100'
      expect(response.body).not_to include 'Buffet é obrigatório(a)'
    end

    it 'Falha se parâmetros não estão completos' do
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
                                    offer_decoration: true, offer_drinks: true, offer_parking_service: false,
                                    default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                    extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                    weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                    buffet: buffet)
      order_params = {order: {event_type_id: event_type.id , estimated_date: '', number_of_guests: ''}}

      # Act
      post '/api/v1/orders', params: order_params

      # Assert
      expect(response.status).to eq 412
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Data Estimada não pode ficar em branco'
      expect(response.body).to include 'Quantidade de Convidados não pode ficar em branco'
    end

    it 'Ocorre um erro interno' do
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
                                    offer_decoration: true, offer_drinks: true, offer_parking_service: false,
                                    default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                    extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                    weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                    buffet: buffet)
      allow(Order).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)
      order_params = {order: {event_type_id: event_type.id, estimated_date: 2.weeks.from_now, number_of_guests: 40}}

      # Act
      post '/api/v1/orders', params: order_params

      # Assert
      expect(response.status).to eq 500
    end
  end
end
