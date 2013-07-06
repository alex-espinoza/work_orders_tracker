require 'spec_helper'

describe TeamInvitation do
	let!(:team) { FactoryGirl.create(:invitations_test_team) }
	let!(:user) { FactoryGirl.create(:new_user) }
  let!(:manager) { FactoryGirl.create(:inviter_manager) }
	let!(:membership) { FactoryGirl.create(:invitations_test_membership, user: user, team: team, role: "worker") }
  let!(:invitation) { FactoryGirl.build(:test_invitation, team: team, sender: manager, recipient_email: user.email) }

  it { should belong_to(:team) }
  it { should belong_to(:sender) }

  it "ensure recipient_already_registered? method works correctly." do
  	team_invitation = TeamInvitation.new
  	team_invitation.recipient_already_registered?(invitation, team)
  	expect(team.team_memberships.all.count).to eq(2)
  end

  describe "if valid" do
  	before { subject.stub(:self_invitation_check) { false } }
  	before { subject.stub(:recipient_already_in_team) { false } }

  	it { should validate_presence_of(:recipient_email) }
	  it { should validate_presence_of(:sender_id) }
	  it { should validate_presence_of(:team_id) }

		it { should_not allow_value("blah").for(:recipient_email) }
		it { should allow_value("blah@blah.com").for(:recipient_email) }
		it { should ensure_length_of(:recipient_email).is_at_least(6).is_at_most(100) }
	end
end
