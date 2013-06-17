class Order < ActiveRecord::Base
  attr_accessible :description, :file_attachment, :high_priority, :name, :status, :team_id, :manager_id, :worker_id

  has_many :responses, :class_name => "OrderResponse"
  belongs_to :manager, :foreign_key => "manager_id", :class_name => "User"
  belongs_to :worker, :foreign_key => "worker_id", :class_name => "User"
  belongs_to :team


  validates_presence_of :description, :file_attachment, :high_priority, :name, :status, :team_id, :manager_id, :worker_id
end
