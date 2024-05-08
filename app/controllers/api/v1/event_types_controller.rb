class Api::V1::EventTypesController < Api::V1::ApiController
  def index
    buffet = Buffet.find(params[:buffet_id])
    render status: 200, json: buffet.event_types.as_json(except: [:created_at, :updated_at])
  end
end
