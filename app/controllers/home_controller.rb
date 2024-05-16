class HomeController < ApplicationController
  before_action :redirect_profile, :check_expired_orders

  def index
    @buffets = Buffet.all
  end

  def redirect_profile
    if admin_signed_in? && current_admin.buffet.present?
      redirect_to buffet_path(current_admin.buffet)
    end
  end

  def check_expired_orders
    expired_orders = Order.left_outer_joins(:event).where("events.expiration_date < ? AND orders.status = ?", Date.today, 7)
    expired_orders.each do |order|
      order.expired!
    end
  end
end
