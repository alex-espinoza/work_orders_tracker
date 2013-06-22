require 'spec_helper'

describe "Team Invitations" do
	let!(:team) { FactoryGirl.create(:invitations_test_team) }
	let!(:manager) { FactoryGirl.create(:inviter_manager) }
	let!(:worker) { FactoryGirl.create(:invited_user) }
	let!(:manager_membership) { FactoryGirl.create(:invitations_test_membership, role: "manager", user: manager, team: team) }
	let!(:total_memberships) { TeamMembership.all.count }

	describe "- when inviting a user to a team -" do
		it "only a team manager should be able to invite users." do
			sign_in_as(manager)
			visit team_path(team)
			expect(page).to have_content("Add worker to team")
		end

		it "a worker cannot invite users to a team." do
			sign_in_as(worker)
			visit team_path(team)
			expect(page).to_not have_content("Add worker to team")
		end

		it "if the user is not yet registered, send them an invitation email." do
			sign_in_as(manager)
			visit team_path(team)
			click_link "Add worker to team"
			fill_in "Email", with: "user_does_not_exist@test.com"
			click_button "Add worker"
			expect(email).to have_content("Click here to accept invitation.")
		end

		it "if the user is registered, automatically add them to the team." do
			sign_in_as(manager)
			visit team_path(team)
			click_link "Add worker to team"
			fill_in "Email", with: worker.email
			click_button "Add worker"
			expect(page).to have_content("#{worker.email} has been added to the team.")
			expect(total_memberships).to eq(total_memberships + 1)
		end
	end
end