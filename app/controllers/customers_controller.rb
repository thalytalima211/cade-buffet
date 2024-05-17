class CustomersController < ApplicationController
  def show
    customer = Customer.find(params[:id])
    if !customer_signed_in? || current_customer != customer
      redirect_to root_path, notice: 'Você não tem acesso aos pedidos deste usuário'
    end
    @pending_orders = Order.where(customer: customer, status: :pending)
    @canceled_orders = Order.where(customer: customer, status: :cancelled)
    @pending_confirmation_orders = Order.where(customer: customer, status: :pending_confirmation)
    @expired_orders = Order.where(customer: customer, status: :expired)
    @accepted_orders = Order.where(customer: customer, status: :accepted)
  end
end
