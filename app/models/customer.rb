require 'cpf_cnpj'

class Customer < ApplicationRecord
  has_many :orders

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :cpf, presence: true
  validates :cpf, uniqueness: true
  validate :valid_cpf

  private

  def valid_cpf
    if !CPF.valid?(self.cpf, strict: true)
      self.errors.add :cpf, 'deve ser válido'
    end
  end
end
