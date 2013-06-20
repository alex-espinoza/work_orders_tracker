class TeamMembership < ActiveRecord::Base
  attr_accessible :role, :user_id, :team_id

  belongs_to :user
  belongs_to :team

  validates_presence_of :role, :user_id, :team_id
end
