class Event < ApplicationRecord
  belongs_to :payment_method
  belongs_to :order
  belongs_to :customer
  belongs_to :buffet

  validates :expiration_date, :surcharge, :discount, :description, :payment_method,  presence: true
  validates :surcharge, :discount, numericality: {greater_than_or_equal_to: 0}
  validate :expiration_date_validation

  before_save :calculate_final_value

  private

  def calculate_final_value
    self.final_value = self.order.default_value - self.discount + self.surcharge
  end

  def expiration_date_validation
    if self.expiration_date.present?
      if self.expiration_date <= Date.today
        self.errors.add :expiration_date, 'deve ser futura'
      end
      if self.order.present? && self.expiration_date >= self.order.estimated_date
        self.errors.add :expiration_date, 'deve ser anterior à data de realização do evento'
      end
    end
  end
end
