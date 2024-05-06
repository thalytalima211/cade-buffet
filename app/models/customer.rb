class Customer < ApplicationRecord
  has_many :orders
  has_many :events

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :valid_cpf
  validates :name, :cpf, presence: true
  validates :cpf, uniqueness: true

  private

  def valid_cpf
    if !CPF.valid?(self.cpf, strict: true)
      self.errors.add :cpf, 'deve ser válido'
    else
      self.cpf = CPF.new(self.cpf).formatted
    end
  end
end
