require 'rails_helper'

describe 'Usuário cria um novo pedido' do
  it 'sem autenticação e é redirecionado' do
    # Arrange
    loadBuffetAndEventType
    event_type = EventType.first

    # Act
    post event_type_orders_path(event_type)

    # Assert
    expect(response).to redirect_to new_customer_session_path
  end
end
