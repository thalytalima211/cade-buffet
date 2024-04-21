require 'rails_helper'

describe 'Administrador registra tipo de evento' do
  it 'a partir da tela inicial' do
    # Arrange
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: '12.345.678/0001-90', number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin)

    # Act
    login_as(admin)
    visit root_path
    click_on 'Adicionar novo tipo de evento'

    # Assert
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Quantidade mínima de pessoas'
    expect(page).to have_field 'Quantidade máxima de pessoas'
    expect(page).to have_field 'Duração padrão'
    expect(page).to have_field 'Cardápio'
    expect(page).to have_field 'Bebidas Alcoólicas'
    expect(page).to have_field 'Decoração'
    expect(page).to have_field 'Serviço de Estacionamento'
    expect(page).to have_field 'Endereço do buffet'
    expect(page).to have_field 'Endereço indicado pelo contratante'
    expect(page).to have_field 'Valor mínimo'
    expect(page).to have_field 'Adicional por pessoa'
    expect(page).to have_field 'Valor por hora extra'
    expect(page).to have_field 'Valor mínimo no final de semana'
    expect(page).to have_field 'Adicional por pessoa no final de semana'
    expect(page).to have_field 'Valor por hora extra no final de semana'
  end

  it 'com sucesso' do
    # Arrange
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: '12.345.678/0001-90', number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin)

    # Act
    login_as(admin)
    visit root_path
    click_on 'Adicionar novo tipo de evento'
    fill_in 'Nome', with: 'Festa de Casamento'
    fill_in 'Descrição', with: 'Celebre seu dia do SIM com o nosso buffet'
      fill_in 'Quantidade mínima de pessoas', with: 20
      fill_in 'Quantidade máxima de pessoas', with: 100
    fill_in 'Duração padrão', with: 90
    fill_in 'Cardápio', with: 'Bolo e Doces'
    check 'Decoração'
    check 'Serviço de Estacionamento'
    choose 'Endereço indicado pelo contratante'
    fill_in 'Valor mínimo', with: 10_000.00
    fill_in 'Adicional por pessoa', with: 250.00
    fill_in 'Valor por hora extra', with: 1_000.00
    fill_in 'Valor mínimo no final de semana', with:  14_000.00
    fill_in 'Adicional por pessoa no final de semana', with: 300.00
    fill_in 'Valor por hora extra no final de semana', with: 1_500.00
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Tipo de evento cadastrado com sucesso'
    expect(page).to have_content 'Festa de Casamento'
    expect(page).to have_content 'Celebre seu dia do SIM com o nosso buffet'
    expect(page).to have_content 'Quantidade mínima de pessoas: 20'
    expect(page).to have_content 'Quantidade máxima de pessoas: 100'
    expect(page).to have_content 'Duração padrão: 90 minutos'
    expect(page).to have_content 'Cardápio: Bolo e Doces'
    expect(page).to have_content 'Serviços: Decoração Serviço de Estacionamento'
    expect(page).not_to have_content 'Bebidas Alcoólicas'
    expect(page).to have_content 'Endereço padrão: Endereço indicado pelo contratante'
    expect(page).not_to have_content 'Endereço do buffet'
    expect(page).to have_content 'Valor mínimo: R$ 10.000,00'
    expect(page).to have_content 'Adicional por pessoa: R$ 250,00'
    expect(page).to have_content 'Valor por hora extra: R$ 1.000,00'
    expect(page).to have_content 'Valor mínimo no final de semana: R$ 14.000,00'
    expect(page).to have_content 'Adicional por pessoa no final de semana: R$ 300,00'
    expect(page).to have_content 'Valor por hora extra no final de semana: R$ 1.500,00'
  end

  it 'com dados incompletos' do
    # Arrange
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: '12.345.678/0001-90', number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin)

    # Act
    login_as(admin)
    visit root_path
    click_on 'Adicionar novo tipo de evento'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Quantidade mínima de pessoas', with: ''
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Não foi possível salvar tipo de evento'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Quantidade mínima de pessoas não pode ficar em branco'
  end
end
