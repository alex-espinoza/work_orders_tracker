class User < ActiveRecord::Base
  ### Add DESTROY dependent associations
	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :first_name, :last_name, :encrypted_password, :password, :password_confirmation,
    :remember_me, :skip_invitation, :invitation_id, :invitation_token

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

  belongs_to :invitation,
    :class_name => "TeamInvitation"

  after_create :add_user_to_team, :unless => Proc.new { self.invitation.nil? }

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_presence_of :password
  validates_presence_of :password_confirmation
  validates_format_of :email, :with => /@/
  validates_uniqueness_of :email, :case_sensitive => false
  validates_length_of :email, :within => 6..100 # a@a.co
  validates_length_of :first_name, :maximum => 50
  validates_length_of :last_name, :maximum => 50
  validate :if_token_already_used

  def if_token_already_used
    errors.add :invitation_token, "has already been used." if check_if_token_already_used
  end

  def check_if_token_already_used
    if TeamInvitation.find_by_token(invitation_token)
      existing_token = TeamInvitation.find_by_token(invitation_token)
      User.find_by_invitation_id(existing_token)
    end
  end

  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = TeamInvitation.find_by_token(token)
  end

  def get_full_name
    "#{first_name} #{last_name}"
  end

private

  def add_user_to_team
    team_membership = TeamMembership.new
    team_membership.create_worker_membership(self)
  end
end
