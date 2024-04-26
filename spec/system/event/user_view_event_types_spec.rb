require 'rails_helper'

describe 'Usuário vê tipos de eventos' do
  it 'a partir da tela inicial' do
    # Arrange
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: '12.345.678/0001-90', number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin)
    event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                  min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                  offer_decoration: true, offer_drinks: true, offer_parking_service: false,
                                  default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                  extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                  weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                  buffet: buffet)

    # Act
    visit root_path
    click_on 'Sabores Divinos Buffet'

    # Assert
    expect(page).to have_content 'Festa de Casamento'

  end
  it 'e não vê outros tipos de evento em seu buffet' do
    # Arrange
    first_admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    first_buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                                  registration_number: '12.345.678/0001-90', number_phone: '(55)5555-5555',
                                  email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                                  neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                                  description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                                  admin: first_admin)
    first_event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                        min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                        offer_decoration: true, offer_drinks: true, offer_parking_service: false,
                                        default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                        extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                        weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                        buffet: first_buffet)

    second_admin = Admin.create!(email: 'gourmet@email.com', password: 'senha123')
    second_buffet = Buffet.create!(corporate_name: 'Gourmet & Companhia Ltda.', brand_name: 'Gourmet & Companhia Ltda',
                                  registration_number: '98.765.432/0001-12', number_phone: '(11)91234-5678',
                                  email: 'contato@gourmetecia.com',  full_address: 'Avenida Principal, 456',
                                  neighborhood: 'Jardins', city: 'Metropolis', state: 'SP', zip_code: '98765-432',
                                  description: 'Gourmet & Cia Buffet oferece serviços de buffet para eventos de todos os tamanhos.',
                                  admin: second_admin)
    second_event_type = EventType.create!(name: 'Festa de Aniversário', description: 'Assopre as velinhas conosco',
                                        min_guests: 15, max_guests: 90, default_duration: 120, menu: 'Salgadinhos e bolo de aniversário',
                                        offer_decoration: true, offer_drinks: false, offer_parking_service: false,
                                        default_address: :indicated_address, min_value: 8_000.00, additional_per_guest: 100.00,
                                        extra_hour_value: 900.00, weekend_min_value: 12_000.00,
                                        weekend_additional_per_guest: 200.00, weekend_extra_hour_value: 1_200.00,
                                        buffet: second_buffet)

    # Act
    visit root_path
    click_on 'Sabores Divinos Buffet'

    # Assert
    expect(page).not_to have_content 'Festa de Aniverário'
    expect(page).to have_content 'Festa de Casamento'
  end

  it 'e não existem tipos de eventos cadastrados' do
    # Arrange
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: '12.345.678/0001-90', number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin)

    # Act
    visit root_path
    click_on 'Sabores Divinos Buffet'

    # Assert
    expect(page).to have_content 'Não há nenhum tipo de evento cadastrado'
  end
end
