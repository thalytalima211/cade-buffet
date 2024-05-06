class Event < ApplicationRecord
  belongs_to :payment_method
  belongs_to :order
  belongs_to :customer
  belongs_to :buffet

  enum status: {pending: 0, confirmed: 5}

  validates :expiration_date, :surcharge, :discount, :description, :payment_method,  presence: true
  validates :surcharge, :discount, numericality: {greater_than_or_equal_to: 0}
  validates :expiration_date, comparison: {greater_than: Date.today}

  before_save :calculate_final_value

  private

  def calculate_final_value
    self.final_value = self.order.default_value - self.discount + self.surcharge
  end
end
