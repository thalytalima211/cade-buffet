require 'cpf_cnpj'

class Buffet < ApplicationRecord
  belongs_to :admin
  has_many :event_types

  validates :corporate_name, :brand_name, :registration_number, :number_phone, :email, :full_address,
            :neighborhood, :state, :city, :zip_code, :description, presence: true
  validates :registration_number, uniqueness: true
  validate :valid_registration_number

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
    end
  end
end
