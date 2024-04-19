require 'rails_helper'

RSpec.describe Buffet, type: :model do
  describe '#valid' do
    it 'deve ter Razão Social' do
      buffet = Buffet.new(corporate_name: '')
      expect(buffet.valid?).to eq false
    end

    it 'deve ter Nome Fantasia' do
      buffet = Buffet.new(brand_name: '')
      expect(buffet.valid?).to eq false
    end

    it 'deve ter CNPJ' do
      buffet = Buffet.new(registration_number: '')
      expect(buffet.valid?).to eq false
    end

    it 'deve ter Telefone para contato' do
      buffet = Buffet.new(number_phone: '')
      expect(buffet.valid?).to eq false
    end

    it 'deve ter Email para contato' do
      buffet = Buffet.new(email: '')
      expect(buffet.valid?).to eq false
    end

    it 'deve ter Endereço' do
      buffet = Buffet.new(full_address: '')
      expect(buffet.valid?).to eq false
    end

    it 'deve ter Bairro' do
      buffet = Buffet.new(neighborhood: '')
      expect(buffet.valid?).to eq false
    end

    it 'deve ter Estado' do
      buffet = Buffet.new(state: '')
      expect(buffet.valid?).to eq false
    end

    it 'deve ter Cidade' do
      buffet = Buffet.new(city: '')
      expect(buffet.valid?).to eq false
    end

    it 'deve ter CEP' do
      buffet = Buffet.new(zip_code: '')
      expect(buffet.valid?).to eq false
    end

    it 'deve ter Descrição' do
      buffet = Buffet.new(description: '')
      expect(buffet.valid?).to eq false
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
