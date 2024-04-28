require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe '#valid?' do
    it 'deve ter nome' do
      customer = Customer.new(name: '')
      customer.valid?
      expect(customer.errors.include? :name).to be true
    end

    it 'deve ter CPF' do
      customer = Customer.new(cpf: '')
      customer.valid?
      expect(customer.errors.include? :cpf).to be true
    end

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
  end
end
