class User < ActiveRecord::Base
	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :first_name, :last_name, :encrypted_password, :role, :team_id, :manager_id, :password, :password_confirmation, :remember_me

  has_many :responses
  has_many :orders
  has_many :workers, :foreign_key => "manager_id"
  has_many :managers, :through => :workers
  belongs_to :team

  # validates_presence_of :email, :first_name, :last_name, :encrypted_password, :role, :team_id, :manager_id, :password, :password_confirmation, :remember_me
  validates_presence_of :email, :password, :password_confirmation

  def self.role_select
  	[
  		["Manager - I will be issuing work orders.", "manager"],
  		["Worker - I will be receiving work orders.", "worker"]
  	]
  end
end
