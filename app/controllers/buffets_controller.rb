class BuffetsController < ApplicationController
  before_action :authenticate_admin!, only: [:edit, :update, :new, :create]
  before_action :set_buffet, only: [:show]
  before_action :check_buffet, only: [:edit, :update]
  def new
    @buffet = Buffet.new
  end

  def create
    @buffet = Buffet.new(buffet_params)
    @buffet.admin = current_admin
    if @buffet.save
      redirect_to buffet_path(@buffet.id), notice: 'Buffet cadastrado com sucesso'
    else
      @buffet.admin = nil
      flash.now[:notice] = 'Buffet não cadastrado'
      render :new
    end
  end

  def show
    @event_types = @buffet.event_types
  end

  def edit; end

  def update
    if @buffet.update(buffet_params)
      redirect_to buffet_path(@buffet), notice: 'Buffet editado com sucesso'
    else
      flash.now[:notice] = 'Não foi possível editar buffet'
      render :edit
    end
  end

  def search
    @query = params[:query]
    search_query = 'event_types.name LIKE ? OR buffets.brand_name LIKE ? OR buffets.city LIKE ?'
    @buffets = Buffet.joins(:event_types).where(search_query, "%#{@query}%", "%#{@query}%", "%#{@query}%").order(:brand_name)
  end

  private

  def buffet_params
    params.require(:buffet).permit(:corporate_name, :brand_name, :registration_number, :number_phone, :email,
                                  :full_address, :neighborhood, :state, :city, :zip_code, :description,
                                  :accepts_cash, :accepts_pix, :accepts_credit_card)
  end

  def set_buffet
    @buffet = Buffet.find(params[:id])
  end

  def check_buffet
    set_buffet
    if @buffet.admin != current_admin
      return redirect_to buffet_path(current_admin.buffet), notice: 'Você não pode editar este buffet'
    end
  end
end
