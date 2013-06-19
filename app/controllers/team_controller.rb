class TeamsController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def new
  	@team = Team.new
  end

  def create
  	@team = Team.new(params[:team])

  	if @team.save
  		redirect_to team_invitations_path
  	else
  		render action: "new"
  	end
  end
end
