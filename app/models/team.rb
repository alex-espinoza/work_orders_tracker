class Team < ActiveRecord::Base
  attr_accessible :team_name

  has_many :users
  has_many :orders

  validates_presence_of :team_name
end
