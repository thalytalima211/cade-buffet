require 'rails_helper'

describe 'Autenticação - Event Type' do
  it 'Usuário edita tipo de evento e não está autenticado' do
    # Arrange
    loadBuffetAndEventType
    event_type = EventType.first

    # Act
    patch event_type_path(event_type)

    # Assert
    expect(response).to redirect_to new_admin_session_path
  end

  it 'Administrador edita tipo de evento e não é o dono' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    first_admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet_photo = Photo.create!()
    buffet_photo.image.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')),
                              filename: 'buffet_image.jpg')
    first_buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                                  registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                                  email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                                  neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                                  description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                                  admin: first_admin, payment_methods: [cash], photo: buffet_photo)
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                  default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: first_buffet)
    second_admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
    second_buffet = Buffet.create!(corporate_name: 'Gourmet & Companhia Ltda.', brand_name: 'Gourmet & Companhia Ltda',
                                  registration_number: CNPJ.generate, number_phone: '(11)91234-5678',
                                  email: 'contato@gourmetecia.com',  full_address: 'Avenida Principal, 456',
                                  neighborhood: 'Jardins', city: 'Metropolis', state: 'SP', zip_code: '98765-432',
                                  description: 'Gourmet & Cia Buffet oferece serviços de buffet para eventos de todos os tamanhos.',
                                  admin: second_admin, payment_methods: [cash], photo: buffet_photo)

    # Act
    login_as(second_admin, scope: :admin)
    patch event_type_path(event_type)

    # Assert
    expect(response).to redirect_to buffet_path(second_buffet)
  end

  it 'Usuário cadastra novo tipo de evento e não está autenticado' do
    # Arrange

    # Act
    post event_types_path

    # Assert
    expect(response).to redirect_to new_admin_session_path
  end
end
