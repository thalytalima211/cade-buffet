class EventTypesController < ApplicationController
  before_action :load_buffet, only: [:new, :create]

  def new
    @event_type = EventType.new
  end

  def create
    @event_type = EventType.new(event_type_params)
    @event_type.default_address = params[:default_address].to_i
    @event_type.buffet = @buffet
    if @event_type.save
      redirect_to buffet_event_type_path(@buffet, @event_type), notice: 'Tipo de evento cadastrado com sucesso'
    else
      flash.now[:notice] = 'Não foi possível salvar tipo de evento'
      render :new
    end
  end

  def show
    @event_type = EventType.find(params[:id])
  end

  private

  def load_buffet
    @buffet = Buffet.find(params[:buffet_id])
  end

  def event_type_params
    params.require(:event_type).permit(:name, :description, :min_guests, :max_guests, :default_duration, :menu,
                                      :offer_drinks, :offer_decoration, :offer_parking_service, :default_address,
                                      :min_value, :additional_per_guest, :extra_hour_value, :weekend_min_value,
                                      :weekend_additional_per_guest, :weekend_extra_hour_value)
  end
end
