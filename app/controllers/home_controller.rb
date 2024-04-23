class HomeController < ApplicationController
  before_action :redirect_profile

  def index
    @buffets = Buffet.all
  end

  def redirect_profile
    if admin_signed_in? && current_admin.buffet.present?
      redirect_to current_admin.buffet
    end
  end
end
