class TeamMembership < ActiveRecord::Base
  attr_accessible :role, :user_id, :team_id

  belongs_to :user
  belongs_to :team

  validates_presence_of :role, :user_id, :team_id

  def create_manager_membership(user, team)
    team_membership = team.team_memberships.build
    team_membership.role = "manager"
    team_membership.user = user
    team_membership.save
	end
end
