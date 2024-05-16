class CustomersController < ApplicationController
  before_action :authenticate_customer!, only: [:show]

  def show
    customer = Customer.find(params[:id])
    if current_customer != customer
      redirect_to customer_path(current_customer), notice: 'Você não tem acesso aos pedidos deste usuário'
    end
    @pending_orders = Order.where(customer: customer, status: :pending)
    @canceled_orders = Order.where(customer: customer, status: :cancelled)
    @pending_confirmation_orders = Order.where(customer: customer, status: :pending_confirmation)
    @expired_orders = Order.where(customer: customer, status: :expired)
    @accepted_orders = Order.where(customer: customer, status: :accepted)
  end
end
