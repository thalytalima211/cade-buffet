class Api::V1::EventTypesController < Api::V1::ApiController
  def index
    buffet = Buffet.find(params[:buffet_id])
    render status: 200, json: buffet.event_types.as_json(except: [:created_at, :updated_at])
  end

  def disponibility
    order = Order.new(params.permit(:estimated_date, :number_of_guests))
    order.event_type = EventType.find(params[:id])
    order.valid?(:api_validation)
    if order.errors.include?(:estimated_date) || order.errors.include?(:number_of_guests)
      order.errors.delete(:buffet)
      order.errors.delete(:address)
      order.errors.delete(:customer)
      render status: 412, json: {errors: order.errors.full_messages}
    else
      render status: 200, json: order.as_json(only: [:default_value])
    end
  end
end
