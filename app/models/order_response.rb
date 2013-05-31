class OrderResponse < ActiveRecord::Base
  attr_accessible :file_attachment, :response, :order_id, :user_id

  belongs_to :order
  belongs_to :user
end
