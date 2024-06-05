class Buffet < ApplicationRecord
  belongs_to :admin
  has_many :event_types
  has_many :orders
  has_many :events
  has_many :buffet_payment_methods
  has_many :payment_methods, through: :buffet_payment_methods
  has_one :buffet_photo
  has_one :photo, through: :buffet_photo
  accepts_nested_attributes_for :photo

  validate :valid_registration_number
  validates :corporate_name, :brand_name, :registration_number, :number_phone, :email, :full_address,
            :neighborhood, :state, :city, :zip_code, :description, :payment_methods, :photo, presence: true
  validates :registration_number, uniqueness: true

  def location
    "#{full_address}, #{neighborhood}, #{city}-#{state}, CEP: #{zip_code}"
  end

  def contact
    "#{number_phone} - #{email}"
  end

  def self.searchBuffet(search)
    search_query = 'event_types.name LIKE ? OR buffets.brand_name LIKE ? OR buffets.city LIKE ?'
    Buffet.left_outer_joins(:event_types).where(search_query, "%#{search}%", "%#{search}%", "%#{search}%").order(:brand_name).distinct
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
