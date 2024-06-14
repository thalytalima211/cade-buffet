require 'rails_helper'

describe 'Cliente acessa buffet' do
  it 'e tenta criar um novo buffet' do
    # Arrange
    customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')

    # Act
    login_as(customer, scope: :customer)
    post buffets_path

    # Assert
    expect(response).to redirect_to root_path
  end

  it 'e tenta editar um buffet' do
    # Arrange
    loadBuffet
    buffet = Buffet.first
    customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')

    # Act
    login_as(customer, scope: :customer)
    patch buffet_path(buffet)

    # Assert
    expect(response).to redirect_to root_path
  end
end
