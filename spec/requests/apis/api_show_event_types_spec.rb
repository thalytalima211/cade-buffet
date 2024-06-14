require 'rails_helper'

describe 'API exibe tipos de eventos' do
  context 'GET /api/v1/buffets/1/event_types' do
    it 'Sucesso' do
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
      first_event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                          min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                          offer_decoration: true, offer_drinks: true, offer_parking_service: false,
                                          default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                          extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                          weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                          buffet: buffet)
      second_event_type = EventType.create!(name: 'Festa de Aniversário', description: 'Assopre as velinhas conosco',
                                            min_guests: 15, max_guests: 90, default_duration: 120, menu: 'Salgadinhos e bolo de aniversário',
                                            offer_decoration: true, offer_drinks: false, offer_parking_service: false,
                                            default_address: :indicated_address, min_value: 8_000.00, additional_per_guest: 100.00,
                                            extra_hour_value: 900.00, weekend_min_value: 12_000.00,
                                            weekend_additional_per_guest: 200.00, weekend_extra_hour_value: 1_200.00,
                                            buffet: buffet)

      # Act
      get "/api/v1/buffets/#{buffet.id}/event_types"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      expect(json_response[0]['name']).to eq 'Festa de Casamento'
      expect(json_response[0]['description']).to eq 'Celebre seu dia do SIM com o nosso buffet'
      expect(json_response[0]['min_guests']).to eq 20
      expect(json_response[0]['max_guests']).to eq 100
      expect(json_response[0]['default_duration']).to eq 90
      expect(json_response[0]['menu']).to eq 'Bolo e Doces'
      expect(json_response[1]['name']).to eq 'Festa de Aniversário'
      expect(json_response[1]['description']).to eq 'Assopre as velinhas conosco'
      expect(json_response[1]['min_guests']).to eq 15
      expect(json_response[1]['max_guests']).to eq 90
      expect(json_response[1]['default_duration']).to eq 120
      expect(json_response[1]['menu']).to eq 'Salgadinhos e bolo de aniversário'
    end

    it 'Retorna vazio caso não haja nenhum tipo de evento cadastrado no buffet' do
      # Arrange
      loadBuffet
      buffet = Buffet.first

      # Act
      get "/api/v1/buffets/#{buffet.id}/event_types"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end

    it 'Falha se buffet não existe' do
      # Arrange

      # Act
      get '/api/v1/buffets/1/event_types'

      # Assert
      expect(response.status).to eq 404
    end

    it 'Ocorre um erro interno' do
      # Arrange
      loadBuffet
      buffet = Buffet.first
      allow(Buffet).to receive(:find).and_raise(ActiveRecord::QueryCanceled)

      # Act
      get "/api/v1/buffets/#{buffet.id}/event_types"

      # Assert
      expect(response.status).to eq 500
    end
  end
end
