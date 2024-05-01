class BuffetPaymentMethod < ApplicationRecord
  belongs_to :buffet
  belongs_to :payment_method
end
