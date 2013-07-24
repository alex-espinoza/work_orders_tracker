class OrderMailer < ActionMailer::Base
  default :from => "donotreply@workorderstracker.com"

  def new_work_order_assigned(order)
  	@order = order
  	mail(:to => order.worker.email, :subject => "You have been assigned a new work order")
  end

  def work_order_completed(order)
  	@order = order
  	mail(:to => order.manager.email, :subject => "A work order has been marked as complete")
  end
end