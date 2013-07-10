require 'file_size_validator'

class Order < ActiveRecord::Base
  attr_accessible :description, :file_attachment, :high_priority, :name, :status, :team_id, :manager_id, :worker_id

  mount_uploader :file_attachment, AttachmentUploader
  # process_in_background :file_attachment

  has_many :order_responses,
  	inverse_of: :order

  belongs_to :manager,
  	:foreign_key => "manager_id",
  	:class_name => "User"

	belongs_to :worker,
  	:foreign_key => "worker_id",
  	:class_name => "User"

  belongs_to :team

  validates_presence_of :description
  validates_presence_of :name
  validates_presence_of :status
  validates_presence_of :team_id
  validates_presence_of :manager_id
  validates_presence_of :worker_id
  validates_length_of :name, :minimum => 4, :maximum => 140
  validates_length_of :description, :minimum => 4, :maximum => 800
  validates :file_attachment,
    :file_size => {
      :maximum => 5.megabytes.to_i
    }

  state_machine :status, :initial => :assigned do
    event :complete do
      transition :assigned => :completed
    end

    event :reassign do
      transition :completed => :assigned
    end

    event :close do
      transition :assigned => :closed, :completed => :closed
    end
  end

  def assign_order_to_user(team, worker_id_param)
    worker_email = worker_id_param.split(" ").last
    worker_id = User.find_by_email(worker_email)
    self.worker = team.team_memberships.find_by_user_id(worker_id).user
    self.save
  end

  def assigned_to?(user)
    manager_id == user.id || worker_id == user.id
  end

  def check_status_for_row_color(status)
    case status
    when "assigned"
      "warning"
    when "completed"
      "success"
    when "closed"
      "error"
    else
      ""
    end
  end

  def check_status_for_label_color(status)
    case status
    when "assigned"
      "label label-warning"
    when "completed"
      "label label-success"
    when "closed"
      "label label-important"
    else
      ""
    end
  end
end
