class Order < ActiveRecord::Base
  attr_accessible :description, :file_attachment, :high_priority, :name, :status, :team_id, :manager_id, :worker_id

  mount_uploader :file_attachment, AttachmentUploader

  has_many :order_responses,
  	inverse_of: :order

  belongs_to :manager,
  	:foreign_key => "manager_id",
  	:class_name => "User"

	belongs_to :worker,
  	:foreign_key => "worker_id",
  	:class_name => "User"

  belongs_to :team

  validates_presence_of :description, :name, :status, :team_id, :manager_id, :worker_id
  validates_length_of :name, :maximum => 140

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
end
