require 'spec_helper'

describe "Team Memberships" do
	let!(:manager_1) { FactoryGirl.create(:valid_manager) }
	let!(:manager_2) { FactoryGirl.create(:valid_manager, email: "manager2@manager.com") }
	let!(:team_1) { FactoryGirl.create(:invitations_test_team) }
	let!(:team_2) { FactoryGirl.create(:invitations_test_team, team_name: "Test Gardening Team") }
	let!(:manager_1_membership) { FactoryGirl.create(:invitations_test_membership, role: "manager", user: manager_1, team: team_1) }
	let!(:manager_2_membership) { FactoryGirl.create(:invitations_test_membership, role: "manager", user: manager_2, team: team_2) }

	it "a user can only see a list of teams they are members of on the team show page." do
		sign_in_as(manager_1)
		expect(page).to have_link("Test Maintenance Team")
		expect(page).to_not have_link("Test Gardening Team")
		click_link "(sign out)"
		sign_in_as(manager_2)
		expect(page).to have_link("Test Gardening Team")
		expect(page).to_not have_link("Test Maintenance Team")
	end
end