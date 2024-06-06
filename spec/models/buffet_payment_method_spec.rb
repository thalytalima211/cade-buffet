require 'rails_helper'

RSpec.describe BuffetPaymentMethod, type: :model do
  it {should belong_to :buffet}
  it {should belong_to :payment_method}
end
