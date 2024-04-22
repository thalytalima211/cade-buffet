class HomeController < ApplicationController
  def index
    @buffets = Buffet.all
  end
end
