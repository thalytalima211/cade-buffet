require 'rails_helper'

describe 'Administrador edita buffet' do
  it 'e não é o dono' do
    # Arrange
    admin1 = Admin.create!(email: 'admin1@email.com', password: 'senha123')
    admin2 = Admin.create!(email: 'admin2@email.com', password: 'senha123')
    buffet1 = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin1)
    buffet2 = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin2)

    # Act
    login_as(admin1, scope: :admin)
    patch buffet_path(buffet2), params: {buffet: {admin_id: 3}}

    # Assert
    expect(response).to redirect_to buffet_path(admin1.buffet)
  end
end
