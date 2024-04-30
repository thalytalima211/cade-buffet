class OrdersController < ApplicationController
  before_action :authenticate_customer!, only: [:new, :create, :show]
  before_action :set_buffet_and_event_type, only: [:new, :create]

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.buffet = @buffet
    @order.event_type = @event_type
    @order.customer = current_customer
    if @event_type.buffet_address?
      @order.address = @buffet.full_address
    end
    if @order.save
      redirect_to buffet_event_type_order_path(@buffet, @event_type, @order), notice: 'Pedido enviado com sucesso'
    else
      flash.now[:notice] = 'Não foi possível efetuar o pedido'
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
    if @order.customer != current_customer
      redirect_to root_path, notice: 'Você não tem acesso a esse pedido'
    end
  end

  private

  def set_buffet_and_event_type
    @buffet = Buffet.find(params[:buffet_id])
    @event_type = EventType.find(params[:event_type_id])
  end

  def order_params
    params.require(:order).permit(:estimated_date, :number_of_guests, :details, :address)
  end
end
