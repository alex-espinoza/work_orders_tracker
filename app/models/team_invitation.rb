class TeamInvitation < ActiveRecord::Base
	attr_accessible :recipient_email, :sender_id, :team_id, :token, :existed_when_invited

	belongs_to :team, inverse_of: :team_invitations
  belongs_to :sender, :class_name => "User"
  has_one :recipient, :class_name => "User", :foreign_key => "recipient_email"

  validates_presence_of :recipient_email
  validates_format_of :recipient_email, :with =>/@/
  validates_length_of :recipient_email, :within => 6..100
  validates_uniqueness_of :sender_id, :scope => [:recipient_email, :team_id], :if => lambda { |invitation| !invitation.existed_when_invited.nil? }
  validate :self_invitation_check
  validate :recipient_already_in_team

  before_create :generate_token

  def self_invitation_check
  	errors.add :recipient_email, "You are already on the team." if recipient_email == User.find(sender_id).email
  end

  def recipient_already_in_team
  	errors.add :recipient_email, "#{recipient_email} is already on your team." if check_recipient_already_in_team
  end

  def check_recipient_already_in_team
  	if User.find_by_email(recipient_email)
  		recipient = User.find_by_email(recipient_email)
  		Team.find(team).team_memberships.find_by_user_id(recipient)
  	end
  end

  def recipient_already_registered?(email, team)
  	if User.find_by_email(email)
  		team_membership = team.team_memberships.build
  		team_membership.user = User.find_by_email(email)
  		team_membership.save
  	end
  end

  def set_as_existed_when_invited
  	self.update_attribute(:existed_when_invited, "yes")
  end

private

	def generate_token
		self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
	end
end