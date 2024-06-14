class EventsController < ApplicationController
  before_action :set_event_type_and_order, only: [:new, :create, :show, :confirmed]
  before_action :authenticate_customer!, only: [:confirmed]
  before_action :authenticate_admin!, only: [:new, :create]

  def new
    if current_admin.buffet != @order.buffet
      redirect_to root_path, notice: 'Você não pode criar um evento para este buffet'
    else
      @payment_methods = @event_type.buffet.payment_methods
      @event = Event.new
    end
  end

  def create
    if @order.buffet == current_admin.buffet
      @event = Event.new(event_params)
      if @event.save
        @order.pending_confirmation!
        redirect_to event_type_order_event_path(@event_type, @order, @event), notice: 'Pedido aceito!'
      else
        @payment_methods = @event_type.buffet.payment_methods
        flash.now[:notice] = 'Não foi possível aceitar pedido'
        render :new
      end
    else
      redirect_to buffet_path(current_admin.buffet), notice: 'Você não pode criar um evento para este buffet'
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def confirmed
    if current_customer == @order.customer
      @order.accepted!
      redirect_to customer_path(current_customer), notice: 'Evento confirmado com sucesso'
    else
      redirect_to root_path, notice: 'Você não pode confirmar um pedido no qual não é o dono'
    end
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
