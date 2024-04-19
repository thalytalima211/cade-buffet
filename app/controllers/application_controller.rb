class ApplicationController < ActionController::Base
  before_action :authenticate_profile

  private

  def authenticate_profile
    if admin_signed_in? && current_admin.buffet.nil? && request.path != new_buffet_path && request.path != destroy_admin_session_path && request.path != buffets_path
      redirect_to new_buffet_path, notice: 'Cadastre um buffet para continuar'
    end
  end
end
