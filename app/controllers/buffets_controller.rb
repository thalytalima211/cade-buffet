class BuffetsController < ApplicationController
  before_action :authenticate_admin!
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
      flash.now[:notice] = 'Buffet não cadastrado'
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @buffet.update(buffet_params)
      redirect_to buffet_path(@buffet), notice: 'Buffet editado com sucesso'
    end
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
