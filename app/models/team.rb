class Team < ActiveRecord::Base
  attr_accessible :team_name

  has_many :users,
  	through: :team_memberships

  has_many :team_memberships,
  	inverse_of: :team

  has_many :orders,
  	inverse_of: :team

  has_many :team_invitations,
  	inverse_of: :team

  validates_presence_of :team_name
  validates_length_of :team_name, :maximum => 100

  def managed_by?(user)
    team_memberships.where(user_id: user.id, role: "manager").present?
  end
end
