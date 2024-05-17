class EventsController < ApplicationController
  before_action :set_event_type_and_order, only: [:new, :create, :show, :confirmed]

  def new
    if !admin_signed_in? || current_admin.buffet != @order.buffet
      redirect_to root_path
    else
      @payment_methods = @event_type.buffet.payment_methods
      @event = Event.new
    end
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      @order.pending_confirmation!
      redirect_to event_type_order_event_path(@event_type, @order, @event), notice: 'Pedido aceito!'
    else
      @payment_methods = @event_type.buffet.payment_methods
      flash.now[:notice] = 'Não foi possível aceitar pedido'
      render :new
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def confirmed
    @order.accepted!
    redirect_to customer_path(current_customer), notice: 'Evento confirmado com sucesso'
  end

  private

  def event_params
    params.require(:event).permit(:expiration_date, :discount, :surcharge, :description,
                                  :payment_method_id).merge({customer: @order.customer, buffet: @event_type.buffet,
                                  order: @order})
  end

  def set_event_type_and_order
    @event_type = EventType.find(params[:event_type_id])
    @order = Order.find(params[:order_id])
  end
end
