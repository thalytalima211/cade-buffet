require 'rails_helper'

describe 'Usuário pesquisa buffet' do
  it 'a partir do menu' do
    # Arrange

    # Act
    visit root_path

    # Assert
    within('header') do
      expect(page).to have_field 'Buscar Buffet'
      expect(page).to have_button 'Buscar'
    end
  end

  it 'e não vê campo de busca se estiver logado com administrador' do
    # Arrange
    admin = Admin.create!(email: 'admin@email.com', password: 'senha123')

    # Act
    login_as(admin, scope: :admin)
    visit root_path

    # Assert
    within('header') do
      expect(page).not_to have_field 'Buscar Buffet'
      expect(page).not_to have_button 'Buscar'
    end
  end

  it 'e encontra resultados em ordem alfabética' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    first_admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
    first_buffet_photo = Photo.create!()
    first_buffet_photo.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'first_buffet.jpeg')),
                                  filename: 'first_buffet.jpeg')
    first_buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                                  registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                                  email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                                  neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                                  description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                                  admin: first_admin, payment_methods: [cash], photo: first_buffet_photo)
    second_admin = Admin.create!(email: 'gourmet@email.com', password: 'senha123')
    second_buffet_photo = Photo.create!()
    second_buffet_photo.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'second_buffet.jpeg')),
                                  filename: 'second_buffet.jpeg')
    second_buffet = Buffet.create!(corporate_name: 'Gourmet & Companhia Ltda.', brand_name: 'Gourmet & Companhia',
                                  registration_number: CNPJ.generate, number_phone: '(11)91234-5678',
                                  email: 'contato@gourmetecia.com',  full_address: 'Avenida Principal, 456',
                                  neighborhood: 'Jardins', city: 'São Paulo', state: 'SP', zip_code: '98765-432',
                                  description: 'Gourmet & Cia Buffet oferece serviços de buffet para eventos de todos os tamanhos.',
                                  admin: second_admin,payment_methods: [cash], photo: second_buffet_photo)
    third_admin = Admin.create!(email: 'contato@deliciasciabuffet.com', password: 'senha123')
    third_buffet_photo = Photo.create!()
    third_buffet_photo.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'third_buffet.jpeg')),
                                  filename: 'third_buffet.jpeg')
    third_buffet = Buffet.create!(corporate_name: 'Delícias e Companhia Eventos Ltda.', brand_name: 'Delícias & Companhia Buffet',
                                  registration_number: CNPJ.generate, number_phone: '(21)98765-4321',
                                  email: 'contato@deliciasciabuffet.com', full_address: 'Rua dos Sabores, 789',
                                  neighborhood: 'Vila Gourmet', city: 'São Paulo', state: 'SP', zip_code: '12345-678',
                                  description: 'Delícias & Companhia Buffet é uma empresa especializada em criar experiências gastronômicas únicas para todos os tipos de eventos.',
                                  admin: third_admin, payment_methods: [cash], photo: third_buffet_photo)

    # Act
    visit root_path
    fill_in 'Buscar Buffet', with: 'São Paulo'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content '3 buffets encontrados'
    within("#buffet-#{third_buffet.id}") do
      expect(page).to have_css 'img[src*="third_buffet.jpeg"]'
      expect(page).to have_content 'Delícias & Companhia Buffet'
      expect(page).to have_content 'São Paulo'
      expect(page).to have_content 'SP'
    end
    within("#buffet-#{second_buffet.id}") do
      expect(page).to have_css 'img[src*="second_buffet.jpeg"]'
      expect(page).to have_content 'Gourmet & Companhia'
      expect(page).to have_content 'São Paulo'
      expect(page).to have_content 'SP'
    end
    within("#buffet-#{first_buffet.id}") do
      expect(page).to have_css 'img[src*="first_buffet.jpeg"]'
      expect(page).to have_content 'Sabores Divinos Buffet'
      expect(page).to have_content 'São Paulo'
      expect(page).to have_content 'SP'
    end
  end

  it 'e encontra um buffet pelo nome' do
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

    second_admin = Admin.create!(email: 'gourmet@email.com', password: 'senha123')
    second_buffet = Buffet.create!(corporate_name: 'Gourmet & Companhia Ltda.', brand_name: 'Gourmet & Companhia Ltda',
                                  registration_number: CNPJ.generate, number_phone: '(11)91234-5678',
                                  email: 'contato@gourmetecia.com',  full_address: 'Avenida Principal, 456',
                                  neighborhood: 'Jardins', city: 'Metropolis', state: 'SP', zip_code: '98765-432',
                                  description: 'Gourmet & Cia Buffet oferece serviços de buffet para eventos de todos os tamanhos.',
                                  admin: second_admin, payment_methods: [cash], photo: buffet_photo)

    # Act
    visit root_path
    fill_in 'Buscar Buffet', with: 'Sabores Divinos Buffet'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content 'Resultado da Busca por: Sabores Divinos Buffet'
    expect(page).to have_content '1 buffet encontrado'
    expect(page).to have_content 'Sabores Divinos Buffet'
    expect(page).to have_content 'São Paulo'
    expect(page).to have_content 'SP'
    expect(page).not_to have_content 'Gourmet & Companhia Ltda.'
  end

  it 'e encontra um buffet pelo tipo de festa' do
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
    first_event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                        min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                        offer_decoration: true, offer_drinks: true, offer_parking_service: false,
                                        default_address: :buffet_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                        extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                        weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                        buffet: first_buffet)

    second_admin = Admin.create!(email: 'gourmet@email.com', password: 'senha123')
    second_buffet = Buffet.create!(corporate_name: 'Gourmet & Companhia Ltda.', brand_name: 'Gourmet & Companhia',
                                  registration_number: CNPJ.generate, number_phone: '(11)91234-5678',
                                  email: 'contato@gourmetecia.com',  full_address: 'Avenida Principal, 456',
                                  neighborhood: 'Jardins', city: 'Metropolis', state: 'SP', zip_code: '98765-432',
                                  description: 'Gourmet & Cia Buffet oferece serviços de buffet para eventos de todos os tamanhos.',
                                  admin: second_admin, payment_methods: [cash], photo: buffet_photo)
    second_event_type = EventType.create!(name: 'Festa de Aniversário', description: 'Assopre as velinhas conosco',
                                        min_guests: 15, max_guests: 90, default_duration: 120, menu: 'Salgadinhos e bolo de aniversário',
                                        offer_decoration: true, offer_drinks: false, offer_parking_service: false,
                                        default_address: :indicated_address, min_value: 8_000.00, additional_per_guest: 100.00,
                                        extra_hour_value: 900.00, weekend_min_value: 12_000.00,
                                        weekend_additional_per_guest: 200.00, weekend_extra_hour_value: 1_200.00,
                                        buffet: second_buffet)

    # Act
    visit root_path
    fill_in 'Buscar Buffet', with: 'Festa'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content '2 buffets encontrados'
    expect(page).to have_content 'Gourmet & Companhia'
    expect(page).to have_content 'Sabores Divinos Buffet'
  end

  it 'e encontra um buffet pela cidade' do
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

    second_admin = Admin.create!(email: 'gourmet@email.com', password: 'senha123')
    second_buffet = Buffet.create!(corporate_name: 'Gourmet & Companhia Ltda.', brand_name: 'Gourmet & Companhia',
                                  registration_number: CNPJ.generate, number_phone: '(11)91234-5678',
                                  email: 'contato@gourmetecia.com',  full_address: 'Avenida Principal, 456',
                                  neighborhood: 'Jardins', city: 'Metropolis', state: 'SP', zip_code: '98765-432',
                                  description: 'Gourmet & Cia Buffet oferece serviços de buffet para eventos de todos os tamanhos.',
                                  admin: second_admin, payment_methods: [cash], photo: buffet_photo)

    # Act
    visit root_path
    fill_in 'Buscar Buffet', with: 'São Paulo'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content '1 buffet encontrado'
    expect(page).not_to have_content 'Gourmet & Companhia'
    expect(page).to have_content 'Sabores Divinos Buffet'
  end

  it 'e vê detalhes' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    cnpj = CNPJ.new(CNPJ.generate).formatted
    admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
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
    fill_in 'Buscar Buffet', with: 'Sabores Divinos Buffet'
    click_on 'Buscar'
    click_on 'Sabores Divinos Buffet'

    # Assert
    expect(current_path).to eq buffet_path(buffet)
    expect(page).to have_content 'Sabores Divinos Buffet'
    expect(page).not_to have_content 'Razão Social: Sabores Divinos Eventos Ltda.'
    expect(page).to have_content "CNPJ: #{cnpj}"
    expect(page).to have_content 'Av. das Delícias, 1234, Centro, São Paulo-SP, CEP: 01234-567'
    expect(page).to have_content 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis'
    expect(page).to have_content '(55)5555-5555 - contato@saboresdivinos.com'
  end
end
