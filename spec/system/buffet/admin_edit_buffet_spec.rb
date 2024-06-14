require 'rails_helper'

describe 'Administrador edita buffet' do
  it 'e deve estar autenticado' do
    # Arrange
    loadBuffet
    buffet = Buffet.first

    # Act
    visit edit_buffet_path(buffet.id)

    # Assert
    expect(current_path).to eq new_admin_session_path
  end

  it 'e não vê botão para editar buffet se não estiver autenticado' do
    # Arrange
    loadBuffet
    buffet = Buffet.first

    # Act
    visit root_path
    click_on buffet.brand_name

    # Assert
    expect(page).not_to have_link 'Editar'
  end

  it 'e não vê botão para editar buffet se não foi o dono do buffet' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    first_admin = Admin.create!(email: 'contato@saboresdivinos.com', password: 'senha123')
    buffet_photo = Photo.create!()
    buffet_photo.image.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')),
                              filename: 'buffet_image.jpg')
    first_buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                                  registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                                  email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                                  neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                                  description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                                  admin: first_admin, payment_methods: [cash], photo: buffet_photo)
    second_admin = Admin.create!(email: 'contato@gourmetecia.com', password: 'senha123')
    second_buffet = Buffet.create!(corporate_name: 'Gourmet & Companhia Ltda.', brand_name: 'Gourmet & Companhia Ltda',
                                  registration_number: CNPJ.generate, number_phone: '(11)91234-5678',
                                  email: 'contato@gourmetecia.com',  full_address: 'Avenida Principal, 456',
                                  neighborhood: 'Jardins', city: 'Metropolis', state: 'SP', zip_code: '98765-432',
                                  description: 'Gourmet & Cia Buffet oferece serviços de buffet para eventos de todos os tamanhos.',
                                  admin: second_admin, payment_methods: [cash], photo: buffet_photo)

    # Act
    login_as(second_admin, scope: :admin)
    visit buffet_path(first_buffet)

    # Assert
    expect(page).not_to have_link 'Editar'
  end

  it 'e vê pré-visualização da imagem anexada', js: true do
    loadBuffet
    admin = Admin.first

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Editar'
    attach_file 'Imagem do Buffet', Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')

    within('#imagePreview') do
      expect(page).to have_css 'img'
    end
  end

  it 'e remove imagem anexada', js: true do
    loadBuffet
    admin = Admin.first

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Editar'
    attach_file 'Imagem do Buffet', Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')
    find('button#remove-image').click

    within('#imageForm') do
      expect(page).not_to have_css 'img'
    end
  end

  it 'com sucesso' do
    # Arrange
    loadBuffet
    cnpj = CNPJ.new(CNPJ.generate).formatted
    admin = Admin.first

    # Act
    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Editar'
    fill_in 'Cidade', with: 'Sorocaba'
    fill_in 'Bairro', with: 'Campolim'
    fill_in 'CNPJ', with: cnpj
    attach_file 'Imagem do Buffet', Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')
    check 'Dinheiro'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Buffet editado com sucesso'
    expect(page).to have_content 'Av. das Delícias, 1234, Campolim, Sorocaba-SP, CEP: 01234-567'
    expect(page).to have_content "CNPJ: #{cnpj}"
    expect(page).to have_css 'img[src*="buffet_image.jpg"]'
  end

  it 'caso seja o responsável' do
    # Arrange
    cash = PaymentMethod.create!(name: 'Dinheiro')
    admin1 = Admin.create!(email: 'admin1@email.com', password: 'senha123')
    admin2 = Admin.create!(email: 'admin2@email.com', password: 'senha123')
    buffet_photo = Photo.create!()
    buffet_photo.image.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')),
                              filename: 'buffet_image.jpg')
    buffet1 = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin1, payment_methods: [cash], photo: buffet_photo)
    buffet2 = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                            registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                            email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                            neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                            description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                            admin: admin2, payment_methods: [cash], photo: buffet_photo)

    # Act
    login_as(admin2, scope: :admin)
    visit edit_buffet_path(buffet1)

    # Assert
    expect(current_path).to eq buffet_path(admin2.buffet)
    expect(page).to have_content 'Você não pode administrar este buffet'
  end

  it 'com dados incompletos' do
    # Arrange
    loadBuffet
    admin = Admin.first

    # Act
    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Editar'
    fill_in 'Cidade', with: ''
    fill_in 'Bairro', with: ''
    fill_in 'CNPJ', with: ''
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Não foi possível editar buffet'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'Bairro não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
  end
end
