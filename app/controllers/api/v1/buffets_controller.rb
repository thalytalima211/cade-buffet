class Api::V1::BuffetsController < Api::V1::ApiController
  def index
    if params[:search]
      buffets = Buffet.where('brand_name LIKE ?', "%#{params[:search]}%").order(:brand_name)
    else
      buffets = Buffet.all.order(:brand_name)
    end
    render status: 200, json: buffets.as_json(only: [:id, :brand_name, :city, :state])
  end

  def show
    buffet = Buffet.find(params[:id])
    render status: 200, json: buffet.as_json(include: {payment_methods: {only: :name}}, except: [:registration_number,
                                            :corporate_name, :created_at, :updated_at, :admin_id])
  end
end
