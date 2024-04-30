class CustomersController < ApplicationController
  before_action :authenticate_customer!, only: [:show]

  def show
    customer = Customer.find(params[:id])
    if current_customer != customer
      redirect_to customer_path(current_customer), notice: 'Você não tem acesso aos pedidos deste usuário'
    end
    @orders = Order.where(customer: customer)
  end
end
