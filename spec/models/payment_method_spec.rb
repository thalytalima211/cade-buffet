require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  it {should validate_presence_of :name}
end
