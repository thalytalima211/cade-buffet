require 'rails_helper'

describe 'API exibe detalhes de um buffet' do
  context 'GET /api/v1/buffets/1' do
    it 'Sucesso' do
      # Arrange
      cash = PaymentMethod.create!(name: 'Dinheiro')
      admin = Admin.create!(email: 'gourmet@email.com', password: 'senha123')
      buffet_photo = Photo.create!()
      buffet_photo.image.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')),
                                filename: 'buffet_image.jpg')
      buffet = Buffet.create!(corporate_name: 'Gourmet & Companhia Ltda.', brand_name: 'Gourmet & Companhia',
                              registration_number: CNPJ.generate, number_phone: '(11)91234-5678',
                              email: 'contato@gourmetecia.com',  full_address: 'Avenida Principal, 456',
                              neighborhood: 'Jardins', city: 'São Paulo', state: 'SP', zip_code: '98765-432',
                              description: 'Gourmet & Cia Buffet oferece serviços de buffet para eventos de todos os tamanhos.',
                              admin: admin, payment_methods: [cash], photo: buffet_photo)

      # Act
      get "/api/v1/buffets/#{buffet.id}"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['brand_name']).to eq 'Gourmet & Companhia'
      expect(json_response['number_phone']).to eq '(11)91234-5678'
      expect(json_response['email']).to eq 'contato@gourmetecia.com'
      expect(json_response['full_address']).to eq 'Avenida Principal, 456'
      expect(json_response['neighborhood']).to eq 'Jardins'
      expect(json_response['city']).to eq 'São Paulo'
      expect(json_response['state']).to eq 'SP'
      expect(json_response['zip_code']).to eq '98765-432'
      expect(json_response['description']).to eq 'Gourmet & Cia Buffet oferece serviços de buffet para eventos de todos os tamanhos.'
      expect(json_response['payment_methods']).to eq [{'name' => 'Dinheiro'}]
      expect(json_response.keys).not_to include 'registration_number'
      expect(json_response.keys).not_to include 'corporate_name'
    end

    it 'Falha se buffet não existe' do
      # Arrange

      # Act
      get "/api/v1/buffets/1"

      # Assert
      expect(response.status).to eq 404
    end

    it 'Ocorre um erro interno' do
      # Arrange
      loadBuffet
      buffet = Buffet.first
      allow(Buffet).to receive(:find).and_raise(ActiveRecord::QueryCanceled)

      # Act
      get "/api/v1/buffets/#{buffet.id}"

      # Assert
      expect(response.status).to eq 500
    end
  end
end
