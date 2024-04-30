require 'rails_helper'

describe 'Usuário vê detalhes de um tipo de evento' do
  it 'com sucesso' do
    # Arrange
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin)
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
    expect(current_path).to eq buffet_event_type_path(buffet, event_type)
    expect(page).to have_content 'Festa de Casamento'
    expect(page).to have_content 'Celebre seu dia do SIM com o nosso buffet'
    expect(page).to have_content 'Quantidade mínima de pessoas: 20'
    expect(page).to have_content 'Quantidade máxima de pessoas: 100'
    expect(page).to have_content 'Duração padrão: 90 minutos'
    expect(page).to have_content 'Cardápio: Bolo e Doces'
    expect(page).to have_content 'Serviços: Decoração Serviço de Estacionamento'
    expect(page).to have_content 'Endereço padrão: Endereço indicado pelo contratante'
    expect(page).to have_content 'Valor mínimo: R$ 10.000,00'
    expect(page).to have_content 'Adicional por pessoa: R$ 250,00'
    expect(page).to have_content 'Valor por hora extra: R$ 1.000,00'
    expect(page).to have_content 'Valor mínimo no final de semana: R$ 14.000,00'
    expect(page).to have_content 'Adicional por pessoa no final de semana: R$ 300,00'
    expect(page).to have_content 'Valor por hora extra no final de semana: R$ 1.500,00'
  end

  it 'e volta para a página do buffet' do
    # Arrange
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin)
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
    click_on 'Voltar para buffet'

    # Assert
    expect(current_path).to eq buffet_path(buffet)
  end
end
