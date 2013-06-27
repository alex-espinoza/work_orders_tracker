require 'spec_helper'

describe TeamMembership do
	let!(:team) { FactoryGirl.create(:invitations_test_team) }
	let!(:user) { FactoryGirl.create(:invited_user) }
	let!(:manager) { FactoryGirl.create(:inviter_manager) }
	let!(:invitation) { FactoryGirl.create(:test_invitation, team: team, sender: manager, recipient_email: user.email) }

	it { should belong_to(:user) }
	it { should belong_to(:team) }

	it { should validate_presence_of(:role) }
	it { should validate_presence_of(:user_id) }
	it { should validate_presence_of(:team_id) }

	it "ensure create_manager_membership method works correctly." do
		team_membership = TeamMembership.new
		team_membership.create_manager_membership(user, team)
		expect(TeamMembership.all.count).to eq(1)
	end

	it "ensure create_worker_membership method is works correctly." do
		team_membership = TeamMembership.new
		user.invitation = invitation
		team_membership.create_worker_membership(user)
		expect(TeamMembership.all.count).to eq(1)
	end
end