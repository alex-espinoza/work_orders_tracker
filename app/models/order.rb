class Order < ActiveRecord::Base
  attr_accessible :description, :file_attachment, :high_priority, :name, :status

  has_many :responses, foreign_key => "order_id", class_name => "OrderResponse"
  belongs_to :manager, foreign_key => "manager_id", class_name => "User"
  belongs_to :worker, foreign_key => "worker_id", class_name => "User"
  belongs_to :team
end