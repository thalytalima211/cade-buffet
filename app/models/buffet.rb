class Buffet < ApplicationRecord
  belongs_to :admin
  has_many :event_types

  validates :corporate_name, :brand_name, :registration_number, :number_phone, :email, :full_address,
            :neighborhood, :state, :city, :zip_code, :description, presence: true
  def location
    "#{full_address}, #{neighborhood}, #{city}-#{state}, CEP: #{zip_code}"
  end

  def contact
    "#{number_phone} - #{email}"
  end
end
