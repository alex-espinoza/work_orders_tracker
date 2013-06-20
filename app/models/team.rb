class Team < ActiveRecord::Base
  attr_accessible :team_name

  has_many :users,
  	through: :team_memberships,
  	inverse_of: :team

  has_many :orders,
  	inverse_of: :team

  validates_presence_of :team_name
end
