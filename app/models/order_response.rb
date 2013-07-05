require 'file_size_validator'

class OrderResponse < ActiveRecord::Base
  attr_accessible :file_attachment, :response, :order_id, :user_id

  mount_uploader :file_attachment, AttachmentUploader
  process_in_background :file_attachment

  belongs_to :order,
  	inverse_of: :order_responses

  belongs_to :user,
  	inverse_of: :order_responses

  validates_presence_of :response
  validates_presence_of :order_id
  validates_presence_of :user_id
  validates_length_of :response, :minimum => 4, :maximum => 400
  validates :file_attachment,
  :file_size => {
    :maximum => 5.megabytes.to_i
  }
end
