require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe '#valid?' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :cpf}

    it 'CPF deve ser único' do
      # Arrange
      cpf = CPF.generate
      Customer.create!(cpf: cpf, name: 'Maria', email: 'maria@email.com', password: 'senha123')
      customer = Customer.new(cpf: cpf)

      # Act
      customer.valid?

      # Assert
      expect(customer.errors.include? :cpf).to be true
    end

    it 'CPF deve ser válido' do
      first_customer = Customer.new(cpf: '01234567890')
      second_customer = Customer.new(cpf: CPF.generate)

      first_customer.valid?
      second_customer.valid?

      expect(first_customer.errors.include? :cpf).to be true
      expect(second_customer.errors.include? :cpf).to be false
    end

    it 'CPF deve ser formatado com traços e pontos' do
      customer = Customer.new(cpf: '68292799257')
      customer.valid?
      expect(customer.errors.include? :cpf).to be false
      expect(customer.cpf).to eq '682.927.992-57'
    end
  end

  context 'Associações' do
    it {should have_many :orders}
    it {should have_many :events}
  end
end
