class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validações
  validates :username, presence: true, uniqueness: true
  validates :username, length: { minimum: 3, maximum: 20 }
  validates :email, presence: true, uniqueness: true

  # relacionamentos
  has_and_belongs_to_many :roles
  has_many :permissions, through: :role
  belongs_to :perfil, optional: true

  # atributos aninhados para perfil
  accepts_nested_attributes_for :perfil, reject_if: proc { |attributes| attributes["nome"].blank? }

  # atributo virtual para login com email ou username
  attr_accessor :login

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)&.downcase

    where(conditions).where(
      "lower(email) = :value OR lower(username) = :value",
      value: login
    ).first
  end
end
