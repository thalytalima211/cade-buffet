class Buffet < ApplicationRecord
  belongs_to :admin
  has_many :event_types
  has_many :orders
  has_many :events
  has_many :buffet_payment_methods
  has_many :payment_methods, through: :buffet_payment_methods

  validate :valid_registration_number
  validates :corporate_name, :brand_name, :registration_number, :number_phone, :email, :full_address,
            :neighborhood, :state, :city, :zip_code, :description, :payment_methods, presence: true
  validates :registration_number, uniqueness: true

  def location
    "#{full_address}, #{neighborhood}, #{city}-#{state}, CEP: #{zip_code}"
  end

  def contact
    "#{number_phone} - #{email}"
  end

  private

  def valid_registration_number
    if !CNPJ.valid?(self.registration_number, strict: true)
      self.errors.add :registration_number, 'deve ser válido'
    else
      self.registration_number = CNPJ.new(self.registration_number).formatted
    end
  end
end
