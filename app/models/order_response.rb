class OrderResponse < ActiveRecord::Base
  attr_accessible :file_attachment, :response

  belongs_to :order
  belongs_to :user
end
