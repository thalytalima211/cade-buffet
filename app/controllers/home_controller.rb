class HomeController < ApplicationController
  before_action :redirect_profile, only: [:index]
  def index
  end

  private

  def redirect_profile
    if user_signed_in?

    elsif admin_signed_in? && current_admin.buffet.present?
        redirect_to buffet_path(current_admin.buffet)
    end
  end
end
