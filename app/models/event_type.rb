class EventType < ApplicationRecord
  has_many :orders
  enum default_address: {buffet_address: 0, indicated_address: 1}
  belongs_to :buffet
  validates :name, :description, :min_guests, :max_guests, :default_duration, :menu, :default_address, :min_value,
            :additional_per_guest, :extra_hour_value, :weekend_min_value, :weekend_additional_per_guest,
            :weekend_extra_hour_value, presence: true
  validates :min_guests, :max_guests, :min_value, :additional_per_guest, :extra_hour_value, :weekend_min_value,
            :weekend_additional_per_guest, :weekend_extra_hour_value, :default_duration, numericality: {greater_than: 0}
  validates :max_guests, numericality: {greater_than_or_equal_to: :min_guests}, unless: -> { min_guests.blank? }
end
