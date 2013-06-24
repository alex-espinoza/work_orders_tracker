class User < ActiveRecord::Base
  ### Add DESTROY dependent associations
	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

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

  has_many :sent_invitations,
    :foreign_key => "sender_id",
    :class_name => "TeamInvitation"

  belongs_to :invitation

  validates_presence_of :first_name, :last_name, :email, :password, :password_confirmation
  validates_format_of :email, :with => /@/
  validates_uniqueness_of :email, :case_sensitive => false
  validates_length_of :email, :within => 6..100 # a@a.co
  validates_length_of :first_name, :maximum => 50
  validates_length_of :last_name, :maximum => 50
end
