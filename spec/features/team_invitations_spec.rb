require 'spec_helper'

describe "Team Invitations" do
	let!(:team) { FactoryGirl.create(:invitations_test_team) }
	let!(:manager) { FactoryGirl.create(:inviter_manager) }
	let!(:worker) { FactoryGirl.create(:invited_user) }
	let!(:manager_membership) { FactoryGirl.create(:invitations_test_membership, role: "manager", user: manager, team: team) }
	let(:existing_worker_membership) { FactoryGirl.create(:invitations_test_membership, role: "worker", user: worker, team: team) }
	let(:new_worker) { FactoryGirl.create(:new_user) }
	let(:new_worker_membership) { FactoryGirl.create(:invitations_test_membership, role: "worker", user: new_worker, team: team) }

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

		it "a valid email address must be input." do
			sign_in_as(manager)
			visit team_path(team)
			click_link "Add worker to team"
			fill_in "Email address", with: "asd123"
			click_button "Invite worker"
			expect(page).to have_content("prohibited this invitation from being sent")
			fill_in "Email address", with: "a@a.c"
			click_button "Invite worker"
			expect(page).to have_content("prohibited this invitation from being sent")
		end

		it "a manager cannot invite themselves." do
			sign_in_as(manager)
			visit team_path(team)
			click_link "Add worker to team"
			fill_in "Email address", with: manager.email
			click_button "Invite worker"
			expect(page).to have_content("You are already on the team.")
			expect(team.team_memberships.all.count).to eq(1)
			expect(team.team_invitations.all.count).to eq(0)
		end

		it "if the user is not yet registered, send them an invitation email." do
			sign_in_as(manager)
			visit team_path(team)
			click_link "Add worker to team"
			fill_in "Email address", with: "user_does_not_exist@test.com"
			click_button "Invite worker"
			expect(page).to have_content("Your invitation has been sent")
			last_invitation = ActionMailer::Base.deliveries.last
			expect(last_invitation.body.raw_source).to have_content("asdedededad23")
			expect(team.team_invitations.all.count).to eq(1)
		end

		it "if the user is registered, automatically add them to the team." do
			sign_in_as(manager)
			visit team_path(team)
			click_link "Add worker to team"
			fill_in "Email address", with: worker.email
			click_button "Invite worker"
			expect(page).to have_content("#{worker.email} has been added to your team.")
			expect(team.team_invitations.find_by_recipient_email(worker.email).existed_when_invited).to eq("yes")
			expect(team.team_memberships.all.count).to eq(2)
			expect(team.team_invitations.all.count).to eq(1)
		end

		it "a manager cannot invite a worker that is already on the team." do
			existing_worker_membership
			sign_in_as(manager)
			visit team_path(team)
			click_link "Add worker to team"
			fill_in "Email address", with: worker.email
			click_button "Invite worker"
			expect(page).to have_content("#{worker.email} is already on your team")
			expect(team.team_memberships.all.count).to eq(2)
			expect(team.team_invitations.all.count).to eq(0)
		end

		it "they can be sent multiple invitation requests until they accept, create an account and join the team." do
			sign_in_as(manager)
			visit team_path(team)
			click_link "Add worker to team"
			fill_in "Email address", with: "johndoe@test.com"
			click_button "Invite worker"
			expect(page).to have_content("Your invitation has been sent")
			expect(team.team_invitations.all.count).to eq(1)
			fill_in "Email address", with: "johndoe@test.com"
			click_button "Invite worker"
			expect(page).to have_content("Your invitation has been sent")
			expect(team.team_invitations.all.count).to eq(2)
			new_worker_membership
			fill_in "Email address", with: "johndoe@test.com"
			click_button "Invite worker"
			expect(page).to have_content("johndoe@test.com is already on your team")
			expect(team.team_invitations.all.count).to eq(2)
		end
	end
end