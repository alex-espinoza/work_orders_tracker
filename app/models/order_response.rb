class OrderResponse < ActiveRecord::Base
  attr_accessible :file_attachment, :response, :order_id, :user_id

  belongs_to :order,
  	inverse_of: :order_responses

  belongs_to :user,
  	inverse_of: :order_responses

  validates_presence_of :file_attachment, :response, :order_id, :user_id
end
