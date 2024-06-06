require 'rails_helper'

RSpec.describe Buffet, type: :model do
  describe '#valid' do
    it {should validate_presence_of(:corporate_name) }
    it {should validate_presence_of(:brand_name) }


    context 'CNPJ' do
      it {should validate_presence_of(:registration_number) }

      it 'CNPJ deve ser único' do
        # Arrange
        registration_number = CNPJ.generate
        cash = PaymentMethod.create!(name: 'Dinheiro')
        admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
        buffet_photo = Photo.create!()
        buffet_photo.image.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')),
                                  filename: 'buffet_image.jpg')
        first_buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                                      registration_number: registration_number, number_phone: '(55)5555-5555',
                                      email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                                      neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                                      description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                                      admin: admin, payment_methods: [cash], photo: buffet_photo)

        second_buffet = Buffet.new(registration_number: registration_number)

        # Act
        second_buffet.valid?

        # Assert
        expect(second_buffet.errors.include? :registration_number).to be true
      end

      it 'CNPJ deve ser válido' do
        # Arrange
        first_buffet = Buffet.new(registration_number: CNPJ.generate)
        second_buffet = Buffet.new(registration_number: '01.234.567/0001-12')

        # Act
        first_buffet.valid?
        second_buffet.valid?

        # Assert
        expect(first_buffet.errors.include? :registration_number).to be false
        expect(second_buffet.errors.include? :registration_number).to be true
      end

      it 'CNPJ deve ser formatado com traços e pontos' do
        buffet = Buffet.new(registration_number: '25518757000100')
        buffet.valid?
        expect(buffet.errors.include? :registration_number).to be false
        expect(buffet.registration_number).to eq '25.518.757/0001-00'
      end
    end

    it {should validate_presence_of(:number_phone) }
    it {should validate_presence_of(:email) }
    it {should validate_presence_of(:full_address) }
    it {should validate_presence_of(:neighborhood) }
    it {should validate_presence_of(:state) }
    it {should validate_presence_of(:city) }
    it {should validate_presence_of(:zip_code) }
    it {should validate_presence_of(:description) }
    it {should validate_presence_of(:payment_methods) }
    it {should validate_presence_of(:photo) }

  end

  describe '#location' do
   it 'exibe o endereço, bairro, cidade, estado e CEP' do
    buffet = Buffet.new(full_address: 'Av. das Delícias, 1234', neighborhood: 'Centro',
                        city: 'São Paulo', state: 'SP', zip_code: '01234-567')
    result = buffet.location
    expect(result).to eq 'Av. das Delícias, 1234, Centro, São Paulo-SP, CEP: 01234-567'
   end
  end

  describe '#contact' do
    it 'exibe o telefone para contato e o email' do
      buffet = Buffet.new(number_phone: '(55)5555-5555', email: 'contato@saboresdivinos.com')
      result = buffet.contact
      expect(result).to eq '(55)5555-5555 - contato@saboresdivinos.com'
    end
  end

  context 'Associações' do
    it {should belong_to :admin}
    it {should have_many :event_types}
    it {should have_many :orders}
    it {should have_many :events}
    it {should have_many :buffet_payment_methods}
    it {should have_many(:payment_methods).through(:buffet_payment_methods)}
    it {should have_one :buffet_photo}
    it {should have_one(:photo).through(:buffet_photo)}
    it {should accept_nested_attributes_for :photo}
  end
end
