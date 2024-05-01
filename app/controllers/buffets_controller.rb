class BuffetsController < ApplicationController
  before_action :block_customer, only: [:edit, :update, :new, :create]
  before_action :authenticate_admin!, only: [:edit, :update, :new, :create]
  before_action :set_buffet, only: [:show]
  before_action :check_buffet, only: [:edit, :update, :orders]

  def new
    @buffet = Buffet.new
  end

  def create
    if current_admin.create_buffet!(buffet_params)
      params[:buffet][:payment_methods].each do |id|
        current_admin.buffet.payment_methods << PaymentMethod.find(id) if id != ''
      end
      redirect_to buffet_path(current_admin.buffet), notice: 'Buffet cadastrado com sucesso'
    else
      flash.now[:notice] = 'Buffet não cadastrado'
      render :new
    end
  end

  def show
    @event_types = @buffet.event_types
    @payment_methods = @buffet.payment_methods
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
    @buffets = Buffet.left_outer_joins(:event_types).where(search_query, "%#{@query}%", "%#{@query}%", "%#{@query}%").order(:brand_name)
  end

  def orders
    @pending_orders = Order.where(buffet: @buffet, status: :pending)
  end

  private

  def buffet_params
    params.require(:buffet).permit(:corporate_name, :brand_name, :registration_number, :number_phone, :email,
                                  :full_address, :neighborhood, :state, :city, :zip_code, :description)
  end

  def set_buffet
    @buffet = Buffet.find(params[:id])
  end

  def check_buffet
    set_buffet
    if @buffet.admin != current_admin
      return redirect_to buffet_path(current_admin.buffet), notice: 'Você não pode administrar este buffet'
    end
  end

  def block_customer
    if customer_signed_in?
      return redirect_to root_path, notice: 'Um cliente não pode administrar dados de buffets!'
    end
  end
end
