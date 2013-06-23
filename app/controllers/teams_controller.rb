class TeamsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @team = current_user.teams.all
  end

  def show
    @team = Team.find(params[:id])
  end

  def new
  	@team = Team.new
  end

  def create
  	@team = Team.new(params[:team])
    @team_membership = TeamMembership.new

  	if @team.save
      @team_membership.create_manager_membership(current_user, @team)
  		redirect_to teams_path
  	else
  		render action: "new"
  	end
  end
end
