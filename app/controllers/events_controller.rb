class EventsController < ApplicationController
  before_action :set_event_type_and_order, only: [:new, :create, :show, :confirmed]

  def new
    @payment_methods = @event_type.buffet.payment_methods
    @event = Event.new
  end

  def create
    if @order.create_event!(event_params)
      @order.accepted!
      redirect_to event_type_order_event_path(@event_type, @order, @order.event), notice: 'Pedido aceito!'
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def confirmed
    @event = Event.find(params[:id])
    @event.confirmed!
    redirect_to event_type_order_event_path(@event_type, @order, @event), notice: 'Evento confirmado com sucesso'
  end

  private

  def event_params
    params.require(:event).permit(:expiration_date, :discount, :surcharge, :description,
                                  :payment_method_id).merge({customer: @order.customer, buffet: @event_type.buffet})
  end

  def set_event_type_and_order
    @event_type = EventType.find(params[:event_type_id])
    @order = Order.find(params[:order_id])
  end
end
