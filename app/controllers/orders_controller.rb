class OrdersController < ApplicationController
	before_filter :authenticate_user!
	before_filter :load_team

  def index
  end

  def new
  	@order = Order.new
  end

  def create
  	@order = Order.new(params[:order])
		@order.manager = current_user
		@order.team = @team

		if @order.save
			@order.assign_order_to_user(@team, params[:order][:worker_id])
			flash[:notice] = "Work order has been created and was assigned to #{@order.worker.get_full_name}."
			redirect_to team_path(@team)
		else
			render action: "new"
		end
  end

private

	def load_team
		@team = Team.find(params[:team_id])
	end
end
