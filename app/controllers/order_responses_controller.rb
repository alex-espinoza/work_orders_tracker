class OrderResponsesController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!

  def create
  	@order = Order.find(params[:order_id])
  	@order_response = @order.order_responses.build(params[:order_response])
  	@order_response.user = current_user
  	@team = @order.team

  	if @order_response.save
			flash[:notice] = "You have successfully left a response."
			redirect_to team_order_path(@order.team, @order)
		else
			@order_response.destroy
			@order.order_responses.reload
			render 'orders/show'
		end
  end
end
