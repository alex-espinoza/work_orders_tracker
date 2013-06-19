class User < ActiveRecord::Base
	devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :first_name, :last_name, :encrypted_password, :role, :team_id, :manager_id, :password, :password_confirmation, :remember_me, :skip_invitation

  has_many :responses, :class_name => "OrderResponse"
  has_many :orders
  has_many :order_responses
  has_many :workers, :foreign_key => "manager_id"
  has_many :managers, :through => :workers
  belongs_to :team

  validates_presence_of :first_name, :last_name, :email, :password, :password_confirmation
  validates_format_of :email, :with => /@/
  validates_uniqueness_of :email
end
