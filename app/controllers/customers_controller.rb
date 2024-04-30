class CustomersController < ApplicationController
  def show
    customer = Customer.find(params[:id])
    @orders = Order.where(customer: customer)
  end
end
