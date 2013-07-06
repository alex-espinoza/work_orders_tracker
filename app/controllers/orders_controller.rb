class OrdersController < ApplicationController
	load_and_authorize_resource
	before_filter :authenticate_user!
	before_filter :load_team

  def new
  	@order = Order.new
  end

  def create
  	@order = Order.new(params[:order])
		@order.manager = current_user
		@order.team = @team

		if @order.save
			@order.assign_order_to_user(@team, params[:order][:worker_id])
			OrderMailer.delay.new_work_order_assigned(@order) if @order.worker.email != current_user.email
			flash[:notice] = "Work order has been created and was assigned to #{@order.worker.get_full_name}."
			redirect_to team_path(@team)
		else
			render action: "new"
		end
  end

  def show
  	@order = Order.find(params[:id])
  	@order_response = OrderResponse.new
  end

  def edit
  	@order = Order.find(params[:id])
  end

	def update
		@order = Order.find(params[:id])

		if @order.update_attributes(params[:order])
			@order.assign_order_to_user(@team, params[:order][:worker_id])
			redirect_to team_order_path(@team, @order), notice: "Work order has been successfully updated."
		else
			@order.assign_order_to_user(@team, params[:order][:worker_id])
			render action: "edit"
		end
	end

	def reassign
		@order = Order.find(params[:order_id])

		if @order.completed?
			@order.reassign
			redirect_to team_order_path(@team, @order), notice: "Work order has been reassigned."
		else
			render action: "show"
		end
	end

	def close
		@order = Order.find(params[:order_id])

		if @order.completed? || @order.assigned?
			@order.close
			redirect_to team_order_path(@team, @order), notice: "Work order has been closed."
		else
			render action: "show"
		end
	end

	def complete
		@order = Order.find(params[:order_id])

		if @order.assigned?
			@order.complete
			redirect_to team_order_path(@team, @order), notice: "Work order has been completed."
		else
			render action: "show"
		end
	end

private

	def load_team
		@team = Team.find(params[:team_id])
	end
end
