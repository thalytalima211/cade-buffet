require 'rails_helper'

describe 'Administrador cadastra buffet' do
  it 'e deve estar autenticado' do
    # Arrange

    # Act
    visit new_buffet_path

    # Assert
    expect(current_path).to eq new_admin_session_path
  end

  it 'ao criar uma conta' do
    # Arrange

    # Act
    visit root_path
    click_on 'Entrar como administrador'
    click_on 'Criar uma conta'
    fill_in 'E-mail', with: 'thalyta@email.com'
    fill_in 'Senha', with: 'senha123'
    fill_in 'Confirme sua senha', with: 'senha123'
    click_on 'Cadastre-se'

    # Assert
    expect(current_path).to eq new_buffet_path
    expect(page).to have_field 'Razão Social'
    expect(page).to have_field 'Nome Fantasia'
    expect(page).to have_field 'CNPJ'
    expect(page).to have_field 'Telefone para contato'
    expect(page).to have_field 'Email para contato'
    expect(page).to have_field 'Endereço'
    expect(page).to have_field 'Bairro'
    expect(page).to have_field 'Estado'
    expect(page).to have_field 'Cidade'
    expect(page).to have_field 'CEP'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Dinheiro'
    expect(page).to have_field 'PIX'
    expect(page).to have_field 'Cartão de Crédito'
    expect(page).to have_button 'Enviar'
  end

  it 'e continua vendo tela de cadastro enquanto não conclui-la' do
    # Arrange
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123', buffet: nil)

    # Act
    login_as(admin, scope: :admin)
    visit root_path

    # Assert
    expect(page).to have_content 'Cadastre um buffet para continuar'
    expect(current_path).to eq new_buffet_path
  end

  it 'com sucesso' do
    # Arrange
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')

    # Act
    login_as(admin, scope: :admin)
    visit root_path
    fill_in 'Razão Social', with: 'Sabores Divinos Eventos Ltda.'
    fill_in 'Nome Fantasia', with: 'Sabores Divinos Buffet'
    fill_in 'CNPJ', with: '12.345.678/0001-90'
    fill_in 'Telefone para contato', with: '(55)5555-5555'
    fill_in 'Email para contato', with: 'contato@saboresdivinos.com'
    fill_in 'Endereço', with: 'Av. das Delícias, 1234'
    fill_in 'Bairro', with: 'Centro'
    fill_in 'Cidade', with: 'São Paulo'
    fill_in 'Estado', with: 'SP'
    fill_in 'CEP', with: '01234-567'
    fill_in 'Descrição', with: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis'
    check 'Dinheiro'
    check 'PIX'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Buffet cadastrado com sucesso'
    expect(page).to have_content 'Sabores Divinos Buffet'
    expect(page).to have_content 'Razão Social: Sabores Divinos Eventos Ltda.'
    expect(page).to have_content 'CNPJ: 12.345.678/0001-90'
    expect(page).to have_content 'Av. das Delícias, 1234, Centro, São Paulo-SP, CEP: 01234-567'
    expect(page).to have_content 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis'
    expect(page).to have_content '(55)5555-5555 - contato@saboresdivinos.com'
  end

  it 'com dados incompletos' do
    # Arrange
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123', buffet: nil)

    # Act
    login_as(admin, scope: :admin)
    visit root_path
    fill_in 'Razão Social', with: ''
    fill_in 'Nome Fantasia', with: ''
    fill_in 'CNPJ', with: ''
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Buffet não cadastrado'
    expect(page).to have_content 'Razão Social não pode ficar em branco'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
  end
end
