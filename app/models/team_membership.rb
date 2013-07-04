class TeamMembership < ActiveRecord::Base
  attr_accessible :role, :user_id, :team_id

  belongs_to :user
  belongs_to :team

  validates_presence_of :role
  validates_presence_of :user_id
  validates_presence_of :team_id

  def create_manager_membership(user, team)
    team_membership = team.team_memberships.build
    team_membership.role = "manager"
    team_membership.user = user
    team_membership.save
	end

  def create_worker_membership(user)
    team = TeamInvitation.find(user.invitation).team
    team_membership = team.team_memberships.build
    team_membership.user = user
    team_membership.save
  end
end
