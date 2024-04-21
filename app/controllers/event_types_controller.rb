class EventTypesController < ApplicationController
  def new
    @event_type = EventType.new
  end

  def create
    @event_type = EventType.new(event_type_params)
    @event_type.default_address = params[:default_address].to_i
    @event_type.buffet = current_admin.buffet
    if @event_type.save
      redirect_to event_type_path(@event_type), notice: 'Tipo de evento cadastrado com sucesso'
    else
      flash.now[:notice] = 'Não foi possível salvar tipo de evento'
      render :new
    end
  end

  def show
    @event_type = EventType.find(params[:id])
    if @event_type.buffet != current_admin.buffet
      redirect_to root_path, notice: 'Você não pode ver os detalhes desse tipo de evento pois não pertence ao seu buffet'
    end
  end

  private

  def event_type_params
    params.require(:event_type).permit(:name, :description, :min_guests, :max_guests, :default_duration, :menu,
                                      :offer_drinks, :offer_decoration, :offer_parking_service, :default_address,
                                      :min_value, :additional_per_guest, :extra_hour_value, :weekend_min_value,
                                      :weekend_additional_per_guest, :weekend_extra_hour_value)
  end
end
