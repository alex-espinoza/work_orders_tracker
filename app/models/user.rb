class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :password, :role, :team_id, :manager_id

  has_many :responses
  has_many :orders
  has_many :workers, foreign_key => "manager_id"
  has_many :managers, through => :workers
  belongs_to :team

  validates_presence_of :email, :first_name, :last_name, :password, :role, :team_id, :manager_id
end
