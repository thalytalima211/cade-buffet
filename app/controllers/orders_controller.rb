class OrdersController < ApplicationController
  before_action :authenticate_customer!, only: [:new, :create]
  before_action :set_event_type, only: [:new, :create, :show, :cancelled, :accepted]
  before_action :set_order, only: [:show, :cancelled, :accepted]

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.event_type = @event_type
    @order.buffet = @event_type.buffet
    @order.customer = current_customer
    if @event_type.buffet_address?
      @order.address = @event_type.buffet.full_address
    end
    if @order.save
      redirect_to event_type_order_path(@event_type, @order), notice: 'Pedido enviado com sucesso'
    else
      flash.now[:notice] = 'Não foi possível efetuar o pedido'
      render :new
    end
  end

  def show
    if (!admin_signed_in? && !customer_signed_in?) || (customer_signed_in? && @order.customer != current_customer) || (admin_signed_in? && @order.buffet.admin != current_admin)
      redirect_to root_path, notice: 'Você não tem acesso a esse pedido'
    end
  end

  def cancelled
    if !admin_signed_in? || current_admin.buffet != @event_type.buffet
      redirect_to root_path
    else
      @order.cancelled!
      redirect_to orders_buffet_path(@event_type.buffet)
    end
  end

  def accepted
    if !admin_signed_in? || current_admin.buffet != @event_type.buffet
      redirect_to root_path
    else
      redirect_to new_event_type_order_event_path(@event_type, @order)
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_event_type
    @event_type = EventType.find(params[:event_type_id])
  end

  def order_params
    params.require(:order).permit(:estimated_date, :number_of_guests, :details, :address)
  end
end
