require 'rails_helper'

describe 'Cliente acessa buffet' do
  it 'e tenta criar um novo buffet' do
    # Arrange
    customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')

    # Act
    login_as(customer, scope: :customer)
    visit new_buffet_path

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Um cliente não pode administrar dados de buffets!'
  end

  it 'e tenta editar um buffet' do
    # Arrange
    loadBuffet
    buffet = Buffet.first
    customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')

    # Act
    login_as(customer, scope: :customer)
    visit edit_buffet_path(buffet)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Um cliente não pode administrar dados de buffets!'
  end
end
