require 'rails_helper'

describe 'API exibe buffets' do
  context 'GET /api/v1/buffets' do
    it 'Lista buffets em ordem alfabética' do
      # Arrange
      cash = PaymentMethod.create!(name: 'Dinheiro')
      first_admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
      first_buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                                    registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                                    email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                                    neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                                    description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                                    admin: first_admin, payment_methods: [cash])
      second_admin = Admin.create!(email: 'gourmet@email.com', password: 'senha123')
      second_buffet = Buffet.create!(corporate_name: 'Gourmet & Companhia Ltda.', brand_name: 'Gourmet & Companhia',
                                    registration_number: CNPJ.generate, number_phone: '(11)91234-5678',
                                    email: 'contato@gourmetecia.com',  full_address: 'Avenida Principal, 456',
                                    neighborhood: 'Jardins', city: 'São Paulo', state: 'SP', zip_code: '98765-432',
                                    description: 'Gourmet & Cia Buffet oferece serviços de buffet para eventos de todos os tamanhos.',
                                    admin: second_admin,payment_methods: [cash])
      third_admin = Admin.create!(email: 'contato@deliciasciabuffet.com', password: 'senha123')
      third_buffet = Buffet.create!(corporate_name: 'Delícias e Companhia Eventos Ltda.', brand_name: 'Delícias & Companhia Buffet',
                                    registration_number: CNPJ.generate, number_phone: '(21)98765-4321',
                                    email: 'contato@deliciasciabuffet.com', full_address: 'Rua dos Sabores, 789',
                                    neighborhood: 'Vila Gourmet', city: 'São Paulo', state: 'SP', zip_code: '12345-678',
                                    description: 'Delícias & Companhia Buffet é uma empresa especializada em criar experiências gastronômicas únicas para todos os tipos de eventos.',
                                    admin: third_admin, payment_methods: [cash])

      # Act
      get '/api/v1/buffets'

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 3
      expect(json_response[0]['id']).to eq third_buffet.id
      expect(json_response[0]['brand_name']).to eq 'Delícias & Companhia Buffet'
      expect(json_response[0]['city']).to eq 'São Paulo'
      expect(json_response[0]['state']).to eq 'SP'
      expect(json_response[1]['id']).to eq second_buffet.id
      expect(json_response[1]['brand_name']).to eq 'Gourmet & Companhia'
      expect(json_response[1]['city']).to eq 'São Paulo'
      expect(json_response[1]['state']).to eq 'SP'
      expect(json_response[2]['id']).to eq first_buffet.id
      expect(json_response[2]['brand_name']).to eq 'Sabores Divinos Buffet'
      expect(json_response[2]['city']).to eq 'São Paulo'
      expect(json_response[2]['state']).to eq 'SP'
    end

    it 'Retorna vazio se não há nenhum buffet' do
      # Arrange

      # Act
      get '/api/v1/buffets'

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end

    it 'Ocorre um erro interno' do
      # Arrange
      allow(Buffet).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

      # Act
      get '/api/v1/buffets'

      # Assert
      expect(response.status).to eq 500
    end
  end

  context 'GET /api/v1/buffets?search' do
    it 'Lista buffets encontrados em ordem alfabética' do
       # Arrange
      cash = PaymentMethod.create!(name: 'Dinheiro')
      first_admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
      first_buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                                    registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                                    email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                                    neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                                    description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                                    admin: first_admin, payment_methods: [cash])
      second_admin = Admin.create!(email: 'gourmet@email.com', password: 'senha123')
      second_buffet = Buffet.create!(corporate_name: 'Gourmet & Companhia Ltda.', brand_name: 'Gourmet & Companhia',
                                    registration_number: CNPJ.generate, number_phone: '(11)91234-5678',
                                    email: 'contato@gourmetecia.com',  full_address: 'Avenida Principal, 456',
                                    neighborhood: 'Jardins', city: 'São Paulo', state: 'SP', zip_code: '98765-432',
                                    description: 'Gourmet & Cia Buffet oferece serviços de buffet para eventos de todos os tamanhos.',
                                    admin: second_admin,payment_methods: [cash])
      third_admin = Admin.create!(email: 'contato@deliciasciabuffet.com', password: 'senha123')
      third_buffet = Buffet.create!(corporate_name: 'Delícias e Companhia Eventos Ltda.', brand_name: 'Delícias & Companhia Buffet',
                                    registration_number: CNPJ.generate, number_phone: '(21)98765-4321',
                                    email: 'contato@deliciasciabuffet.com', full_address: 'Rua dos Sabores, 789',
                                    neighborhood: 'Vila Gourmet', city: 'São Paulo', state: 'SP', zip_code: '12345-678',
                                    description: 'Delícias & Companhia Buffet é uma empresa especializada em criar experiências gastronômicas únicas para todos os tipos de eventos.',
                                    admin: third_admin, payment_methods: [cash])

      # Act
      get '/api/v1/buffets?search=buffet'

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      expect(json_response[0]['id']).to eq third_buffet.id
      expect(json_response[0]['brand_name']).to eq 'Delícias & Companhia Buffet'
      expect(json_response[0]['city']).to eq 'São Paulo'
      expect(json_response[0]['state']).to eq 'SP'
      expect(json_response[1]['id']).to eq first_buffet.id
      expect(json_response[1]['brand_name']).to eq 'Sabores Divinos Buffet'
      expect(json_response[1]['city']).to eq 'São Paulo'
      expect(json_response[1]['state']).to eq 'SP'
      expect(json_response).not_to include 'Gourmet & Companhia'
      expect(json_response).not_to include second_buffet.id
    end

    it 'Retorna vazio se não há nenhum buffet com o nome pesquisado' do
      # Arrange
      cash = PaymentMethod.create!(name: 'Dinheiro')
      admin = Admin.create!(email: 'gourmet@email.com', password: 'senha123')
      buffet = Buffet.create!(corporate_name: 'Gourmet & Companhia Ltda.', brand_name: 'Gourmet & Companhia',
                              registration_number: CNPJ.generate, number_phone: '(11)91234-5678',
                              email: 'contato@gourmetecia.com',  full_address: 'Avenida Principal, 456',
                              neighborhood: 'Jardins', city: 'São Paulo', state: 'SP', zip_code: '98765-432',
                              description: 'Gourmet & Cia Buffet oferece serviços de buffet para eventos de todos os tamanhos.',
                              admin: admin, payment_methods: [cash])

      # Act
      get '/api/v1/buffets?search=buffet'

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end

    it 'Ocorre um erro interno' do
      # Arrange
      allow(Buffet).to receive(:where).and_raise(ActiveRecord::QueryCanceled)

      # Act
      get '/api/v1/buffets?search=buffet'

      # Assert
      expect(response.status).to eq 500
    end
  end
end
