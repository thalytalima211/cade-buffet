class Event < ApplicationRecord
  belongs_to :payment_method
  belongs_to :order
  belongs_to :customer
  belongs_to :buffet

  enum status: {pending: 0, confirmed: 5}
end
