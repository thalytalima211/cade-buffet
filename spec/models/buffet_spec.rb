require 'rails_helper'

RSpec.describe Buffet, type: :model do
  describe '#valid' do
    it 'deve ter Razão Social' do
      buffet = Buffet.new(corporate_name: '')
      buffet.valid?
      expect(buffet.errors.include? :corporate_name).to eq true
    end

    it 'deve ter Nome Fantasia' do
      buffet = Buffet.new(brand_name: '')
      buffet.valid?
      expect(buffet.errors.include? :brand_name).to eq true
    end

    it 'deve ter CNPJ' do
      buffet = Buffet.new(registration_number: '')
      buffet.valid?
      expect(buffet.errors.include? :registration_number).to eq true
    end

    it 'CNPJ deve ser único' do
      # Arrange
      registration_number = CNPJ.generate
      admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
      Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                    registration_number: registration_number, number_phone: '(55)5555-5555',
                    email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                    neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                    description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                    admin: admin)

      buffet = Buffet.new(registration_number: registration_number)

      # Act
      buffet.valid?

      # Assert
      expect(buffet.errors.include? :registration_number).to be true
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

    it 'deve ter Telefone para contato' do
      buffet = Buffet.new(number_phone: '')
      buffet.valid?
      expect(buffet.errors.include? :number_phone).to eq true
    end

    it 'deve ter Email para contato' do
      buffet = Buffet.new(email: '')
      buffet.valid?
      expect(buffet.errors.include? :email).to eq true
    end

    it 'deve ter Endereço' do
      buffet = Buffet.new(full_address: '')
      buffet.valid?
      expect(buffet.errors.include? :full_address).to eq true
    end

    it 'deve ter Bairro' do
      buffet = Buffet.new(neighborhood: '')
      buffet.valid?
      expect(buffet.errors.include? :neighborhood).to eq true
    end

    it 'deve ter Estado' do
      buffet = Buffet.new(state: '')
      buffet.valid?
      expect(buffet.errors.include? :state).to eq true
    end

    it 'deve ter Cidade' do
      buffet = Buffet.new(city: '')
      buffet.valid?
      expect(buffet.errors.include? :city).to eq true
    end

    it 'deve ter CEP' do
      buffet = Buffet.new(zip_code: '')
      buffet.valid?
      expect(buffet.errors.include? :zip_code).to eq true
    end

    it 'deve ter Descrição' do
      buffet = Buffet.new(description: '')
      buffet.valid?
      expect(buffet.errors.include? :description).to eq true
    end
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
end
