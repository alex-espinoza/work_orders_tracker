class InvitationMailer < ActionMailer::Base
  default :from => "donotreply@workorderstracker.com"

  def new_user_team_invitation(invitation)
  	@invitation = invitation
  	mail(:to => invitation.recipient_email, :subject => "Invitation")
  end
end
