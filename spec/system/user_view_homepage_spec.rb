require 'rails_helper'

describe 'Usuário entra na página inicial' do
  it 'e vê botões de login caso não esteja registrado' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(page).to have_link 'Entrar como cliente'
    expect(page).to have_link 'Entrar como administrador'
  end

  it 'e não vê botões de login caso esteja registrado como administrador' do
    # Arrange
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')

    # Act
    login_as(admin, scope: :admin)
    visit root_path

    # Assert
    expect(page).not_to have_link 'Entrar como cliente'
    expect(page).not_to have_link 'Entrar como administrador'
  end

  it 'e vê buffets cadastrados' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
    buffet_photo = Photo.create!()
    buffet_photo.image.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')),
                              filename: 'buffet_image.jpg')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [cash], photo: buffet_photo)

    # Act
    visit root_path

    # Assert
    expect(page).to have_content 'Sabores Divinos Buffet'
    expect(page).to have_content 'São Paulo'
    expect(page).to have_content 'SP'
  end

  it 'e vê detalhes de um buffet' do
    # Arrange
    cnpj = CNPJ.new(CNPJ.generate).formatted
    cash = PaymentMethod.create!(name: 'Dinheiro')
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
    buffet_photo = Photo.create!()
    buffet_photo.image.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')),
                              filename: 'buffet_image.jpg')
    buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: cnpj, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin, payment_methods: [cash], photo: buffet_photo)

    # Act
    visit root_path
    click_on 'Sabores Divinos Buffet'

    # Assert
    expect(page).to have_content 'Sabores Divinos Buffet'
    expect(page).not_to have_content 'Razão Social: Sabores Divinos Eventos Ltda.'
    expect(page).to have_content "CNPJ: #{cnpj}"
    expect(page).to have_content 'Av. das Delícias, 1234, Centro, São Paulo-SP, CEP: 01234-567'
    expect(page).to have_content 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis'
    expect(page).to have_content '(55)5555-5555 - contato@saboresdivinos.com'
  end
end
