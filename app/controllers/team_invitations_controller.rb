class TeamInvitationsController < ApplicationController
	load_and_authorize_resource
	before_filter :authenticate_user!

	def new
		@team = Team.find(params[:team_id])
		@invitation = TeamInvitation.new
	end

	def create
		@team = Team.find(params[:team_id])
		@invitation = TeamInvitation.new(params[:team_invitation])
		@invitation.sender = current_user
		@invitation.team = @team

		if @invitation.save
			if @invitation.recipient_already_registered?(@invitation.recipient_email, @team)
				@invitation.set_as_existed_when_invited
				flash[:notice] = "#{@invitation.recipient_email} has been added to your team."
				redirect_to new_team_team_invitation_path(params[:team_id])
			else
				InvitationMailer.new_user_team_invitation(@invitation).deliver
				flash[:notice] = "Your invitation has been sent to #{@invitation.recipient_email}."
				redirect_to new_team_team_invitation_path(params[:team_id])
			end
		else
			render action: "new"
		end
	end
end
