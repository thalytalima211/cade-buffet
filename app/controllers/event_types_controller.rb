class EventTypesController < ApplicationController
  before_action :authenticate_admin!, only: [:new, :create, :edit, :update]
  before_action :find_event_type, only: [:edit, :update]
  before_action :check_admin, only: [:edit, :update]

  def new
    @event_type = EventType.new
  end

  def create
    @event_type = EventType.new(event_type_params)
    @event_type.buffet = current_admin.buffet
    if @event_type.save
      redirect_to buffet_path(current_admin.buffet), notice: 'Tipo de evento cadastrado com sucesso'
    else
      flash.now[:notice] = 'Não foi possível salvar tipo de evento'
      render :new
    end
  end

  def edit;  end

  def update
    if @event_type.update(event_type_params)
      redirect_to buffet_path(current_admin.buffet), notice: 'Tipo de evento editado com sucesso'
    else
      flash.now[:notice] = 'Não foi possível editar tipo de evento'
      render :edit
    end
  end

  private

  def find_event_type
    @event_type = EventType.find(params[:id])
  end

  def check_admin
    find_event_type
    if current_admin.buffet != @event_type.buffet
      redirect_to buffet_path(current_admin.buffet), notice: 'Você não pode editar esse tipo de evento'
    end
  end

  def event_type_params
    params.require(:event_type).permit(:name, :description, :min_guests, :max_guests, :default_duration, :menu,
                                      :offer_drinks, :offer_decoration, :offer_parking_service, :default_address,
                                      :min_value, :additional_per_guest, :extra_hour_value, :weekend_min_value,
                                      :weekend_additional_per_guest, :weekend_extra_hour_value, :default_address)
  end
end
