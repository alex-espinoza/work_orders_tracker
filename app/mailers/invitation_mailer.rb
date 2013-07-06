class InvitationMailer < ActionMailer::Base
  default :from => "donotreply@workorderstracker.com"

  def new_user_team_invitation(invitation)
  	@invitation = invitation
  	mail(:to => invitation.recipient_email, :subject => "Invitation")
  end

  def existing_user_team_invitation(invitation, team)
  	@invitation = invitation
  	@team = team
  	mail(:to => invitation.recipient_email, :subject => "You have been added to a team")
  end
end
