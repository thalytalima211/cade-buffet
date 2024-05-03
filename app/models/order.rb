class Order < ApplicationRecord
  belongs_to :buffet
  belongs_to :event_type
  belongs_to :customer
  has_one :event

  enum status: {pending: 0, accepted: 5, cancelled: 10}

  validates :estimated_date, :number_of_guests, :address, presence: true
  validate :estimated_date_is_future, :min_number_of_guests, :max_number_of_guests

  before_validation :generate_code, on: :create

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def estimated_date_is_future
    if self.estimated_date.present? && self.estimated_date <= Date.today
      self.errors.add :estimated_date, 'deve ser futura'
    end
  end

  def min_number_of_guests
    if self.number_of_guests.present? && self.number_of_guests < self.event_type.min_guests
      self.errors.add :number_of_guests, "deve ser maior ou igual a #{self.event_type.min_guests}"
    end
  end

  def max_number_of_guests
    if self.number_of_guests.present? && self.number_of_guests > self.event_type.max_guests
      self.errors.add :number_of_guests, "deve ser menor ou igual a #{self.event_type.max_guests}"
    end
  end
end
