class Order < ApplicationRecord
  belongs_to :buffet
  belongs_to :event_type
  belongs_to :customer
  has_one :event

  enum status: {pending: 0, cancelled: 5, pending_confirmation: 7, expired: 8, accepted: 10}

  validates :estimated_date, :number_of_guests, :address, presence: true
  validates :estimated_date, comparison: {greater_than: Date.today}, unless: -> { estimated_date.blank? }
  validate :min_number_of_guests, :max_number_of_guests

  before_validation :calculate_default_value
  before_validation :generate_code, on: :create
  before_validation :check_event_availability, on: :api_validation

  private

  def check_event_availability
    if self.event_type.present? && self.estimated_date.present? && Order.where(estimated_date: self.estimated_date, event_type: self.event_type, status: :accepted).any?
      self.errors.add :estimated_date, 'já está agendada em outro pedido'
    end
  end

  def calculate_default_value
    if self.event_type.present? && self.number_of_guests.present? && self.estimated_date.present?
      additional_guests = self.number_of_guests - self.event_type.min_guests
      if self.estimated_date.on_weekend?
        self.default_value = self.event_type.weekend_min_value + additional_guests * self.event_type.weekend_additional_per_guest
      else
        self.default_value = self.event_type.min_value + additional_guests * self.event_type.additional_per_guest
      end
    end
  end

  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
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
