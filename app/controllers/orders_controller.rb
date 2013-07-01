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

  def show
  	@order = Order.find(params[:id])
  end

  def edit
  	@order = Order.find(params[:id])
  end

	def update
		@order = Order.find(params[:id])

		if @order.update_attributes(params[:order])
			redirect_to team_order_path(@team, @order), notice: "Work order has been successfully updated."
		else
			render action: "edit"
		end
	end

private

	def load_team
		@team = Team.find(params[:team_id])
	end
end
