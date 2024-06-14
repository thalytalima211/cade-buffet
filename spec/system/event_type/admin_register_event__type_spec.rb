require 'rails_helper'

describe 'Administrador registra tipo de evento' do
  it 'e deve estar autenticado' do
    # Arrange
    loadBuffet

    # Act
    visit new_event_type_path

    # Assert
    expect(current_path).to eq new_admin_session_path
  end

  it 'e não vê botão para registrar novo tipo de evento se não estiver autenticado' do
    # Arrange
    loadBuffet
    buffet = Buffet.first

    # Act
    visit root_path
    click_on buffet.brand_name

    # Assert
    expect(page).not_to have_link 'Adicionar novo tipo de evento'
  end
  it 'a partir da tela inicial' do
    # Arrange
    loadBuffet
    admin = Admin.first

    # Act
    login_as(admin, scope: :admin)
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
    loadBuffet
    admin = Admin.first

    # Act
    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Adicionar novo tipo de evento'
    fill_in 'Nome', with: 'Festa de Casamento'
    fill_in 'Descrição', with: 'Celebre seu dia do SIM com o nosso buffet'
    fill_in 'Quantidade mínima de pessoas', with: 20
    fill_in 'Quantidade máxima de pessoas', with: 100
    fill_in 'Duração padrão', with: 90
    fill_in 'Cardápio', with: "Bolo e doces"
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
    expect(page).to have_content 'Cardápio: Bolo e doces'
    expect(page).to have_content "Serviços:\nDecoração Serviço de Estacionamento"
    expect(page).not_to have_content 'Bebidas Alcoólicas'
    expect(page).to have_content 'Endereço padrão: Endereço indicado pelo contratante'
    expect(page).not_to have_content 'Endereço do buffet'
    within('table') do
      expect(page).to have_content 'Valor mínimo R$ 10.000,00 R$ 14.000,00'
      expect(page).to have_content 'Adicional por pessoa R$ 250,00 R$ 300,00'
      expect(page).to have_content 'Valor por hora extra R$ 1.000,00 R$ 1.500,00'
    end
  end

  it 'com dados incompletos' do
    # Arrange
    loadBuffet
    admin = Admin.first

    # Act
    login_as(admin, scope: :admin)
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
