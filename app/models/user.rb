class User < ApplicationRecord
  self.table_name = "public.users"

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validações
  validates :username, presence: true, uniqueness: true
  validates :username, length: { minimum: 3, maximum: 20 }
  validates :email, presence: true, uniqueness: true

  # relacionamentos
  has_and_belongs_to_many :roles, join_table: :users_roles
  has_many :permissions, through: :roles
  has_one :perfil, inverse_of: :user, dependent: :destroy

  belongs_to :escola, optional: true

  # Checa se o usuário tem um role específico pelo nome
  def has_role?(role_name)
    roles.exists?(nome: role_name.to_s)
  end

  # métodos de conveniência para verificar roles comuns
  def admin?
    has_role?("admin")
  end

  def funcionario?
    has_role?("funcionario")
  end

  def responsavel?
    has_role?("responsavel")
  end

  def aluno?
    has_role?("aluno")
  end

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

  def has_permission?(resource, action)
     return true if admin?

    permissions.exists?(recurso: resource.to_s, acao: action.to_s)
  end
end
