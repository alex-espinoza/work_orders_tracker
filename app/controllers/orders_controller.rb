class OrdersController < ApplicationController
	before_filter :authenticate_user!
	before_filter :load_team

  def index
  end

  def new
  	@order = Order.new
  end

private

	def load_team
		@team = Team.find(params[:team_id])
	end
end
