class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :password, :role

  has_many :responses
  has_many :orders
  belongs_to :team
end
