class EventsController < ApplicationController
  before_action :set_event_type_and_order, only: [:new, :create, :show, :confirmed]
  before_action :set_default_value, only: [:new, :create]

  def new
    @payment_methods = @event_type.buffet.payment_methods
    @event = Event.new
  end

  def create
    @event = Event.new(params.require(:event).permit(:expiration_date, :discount, :surcharge, :description, :payment_method_id))
    @event.default_value = @default_value
    @event.final_value = @default_value - @event.discount + @event.surcharge
    @event.customer = @order.customer
    @event.buffet = @event_type.buffet
    @event.order = @order
    if @event.save
      @order.accepted!
      redirect_to event_type_order_event_path(@event_type, @order, @event), notice: 'Pedido aceito!'
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

  def set_event_type_and_order
    @event_type = EventType.find(params[:event_type_id])
    @order = Order.find(params[:order_id])
  end

  def set_default_value
    if @order.estimated_date.sunday? || @order.estimated_date.saturday?
      @default_value = @event_type.weekend_min_value + (@order.number_of_guests - @event_type.min_guests) * @event_type.weekend_additional_per_guest
    else
      @default_value = @event_type.min_value + (@order.number_of_guests - @event_type.min_guests) * @event_type.additional_per_guest
    end
  end
end
