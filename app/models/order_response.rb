class OrderResponse < ActiveRecord::Base
  attr_accessible :file_attachment, :response, :order_id, :user_id

  belongs_to :order
  belongs_to :user

  validates_presence_of :file_attachment, :response, :order_id, :user_id
end
