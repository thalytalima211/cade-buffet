require 'rails_helper'

RSpec.describe Photo, type: :model do
  it {should have_one_attached :image}
end
