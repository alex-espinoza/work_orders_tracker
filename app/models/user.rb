class User < ActiveRecord::Base
	devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :first_name, :last_name, :encrypted_password, :password, :password_confirmation, :remember_me, :skip_invitation

  has_many :manager_orders,
    :foreign_key => "manager_id",
    :class_name => "Order"

  has_many :worker_orders,
    :foreign_key => "worker_id",
    :class_name => "Order"

  has_many :order_responses,
    inverse_of: :user

  has_many :teams,
    through: :team_memberships

  has_many :team_memberships,
    inverse_of: :user

  validates_presence_of :first_name, :last_name, :email, :password, :password_confirmation
  validates_format_of :email, :with => /@/
  validates_uniqueness_of :email
end
