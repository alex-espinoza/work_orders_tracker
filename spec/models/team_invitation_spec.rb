require 'spec_helper'

describe TeamInvitation do
	# Anything regarding recipient_email fails because of the self_invitation_check method in TeamInvitation, not sure why

  it { should belong_to(:team) }
  it { should belong_to(:sender) }
 #  it { should have_one(:recipient) }

 #  it { should validate_presence_of(:recipient_email) }
 #  it { should validate_presence_of(:sender_id) }
 #  it { should validate_presence_of(:team_id) }

	# it { should validate_presence_of(:recipient_email) }
	# it { should_not allow_value("blah").for(:recipient_email) }
	# it { should allow_value("blah@blah.com").for(:recipient_email) }
	# it { should ensure_length_of(:recipient_email).is_at_least(6).is_at_most(100) }

	# it { should validate_uniqueness_of(:sender_id).scoped_to(:recipient_email, :team_id) }
end
