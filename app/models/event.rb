class Event < ApplicationRecord
  belongs_to :payment_method
  belongs_to :order

  enum status: {pending: 0, confirmed: 5}
end
