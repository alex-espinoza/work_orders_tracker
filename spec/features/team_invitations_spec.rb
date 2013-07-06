require 'spec_helper'

describe "Team Invitations" do
	let!(:team) { FactoryGirl.create(:invitations_test_team) }
	let!(:manager) { FactoryGirl.create(:inviter_manager) }
	let(:worker) { FactoryGirl.create(:invited_user) }
	let!(:manager_membership) { FactoryGirl.create(:invitations_test_membership, role: "manager", user: manager, team: team) }
	let(:test_invitation) { FactoryGirl.create(:test_invitation, recipient_email: "johndoe@test.com", team: team, sender: manager) }
	let(:existing_worker_membership) { FactoryGirl.create(:invitations_test_membership, role: "worker", user: worker, team: team) }
	let(:new_worker) { FactoryGirl.create(:new_user) }
	let(:new_worker_membership) { FactoryGirl.create(:invitations_test_membership, role: "worker", user: new_worker, team: team) }

	def test_invitation_sign_up
		fill_in "First name", with: "JustGot"
		fill_in "Last name", with: "Invited"
		fill_in "Email address", with: "justgotinvited@test.com"
		fill_in "Password", with: "123qwe56"
		fill_in "Password confirmation", with: "123qwe56"
		click_button "Sign up"
	end

	describe "- when inviting a user to a team -" do
		it "only a team manager should be able to invite users." do
			sign_in_as(manager)
			click_link "Test Maintenance Team"
			expect(page).to have_link("Add worker to team")
		end

		it "a worker cannot invite users to a team." do
			existing_worker_membership
			sign_in_as(worker)
			click_link "Test Maintenance Team"
			expect(page).to_not have_link("Add worker to team")
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
			invitation_email = ActionMailer::Base.deliveries.last
			expect(invitation_email.body.raw_source).to have_content("#{manager.email} has invited you to join")
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

		it "when a registered user is auto-added to the team, send them a notifcation email." do
			sign_in_as(manager)
			visit team_path(team)
			click_link "Add worker to team"
			fill_in "Email address", with: worker.email
			click_button "Invite worker"
			invitation_email = ActionMailer::Base.deliveries.last
			expect(invitation_email.body.raw_source).to have_content("#{manager.email} has added you to their team on WorkOrdersTracker!")
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

	describe "- when an invited user is signing up -" do
		it "they can create an account if they follow the valid token URL from the invitation email." do
			test_invitation
			visit "/users/sign_up/#{test_invitation.token}"
			test_invitation_sign_up
			expect(page).to have_content("Teams#index")
			expect(team.team_memberships.all.count).to eq(2)
			expect(User.all.count).to eq(2)
			expect(User.find_by_email("justgotinvited@test.com").invitation_token).to eq(test_invitation.token)
		end
	end

	describe "- when trying to sign up with a fake/invalid token -" do

		it "they can create an account, but they won't be auto-added to a team." do
			test_invitation
			visit "/users/sign_up/andn827hdbs123boguskey"
			fill_in "First name", with: "JustGot"
			fill_in "Last name", with: "Invited"
			fill_in "Email address", with: "justgotinvited@test.com"
			fill_in "Password", with: "123qwe56"
			fill_in "Password confirmation", with: "123qwe56"
			click_button "Sign up"
			expect(page).to have_content("Teams#index")
			expect(team.team_memberships.all.count).to eq(1)
			expect(User.all.count).to eq(2)
			expect(User.find_by_email("justgotinvited@test.com").invitation_token).to_not eq(test_invitation.token)
			expect(User.find_by_email("justgotinvited@test.com").invitation).to be_nil
		end

		it "they cannot create an account if the token has already been used by another user." do
			test_invitation
			visit "/users/sign_up/#{test_invitation.token}"
			test_invitation_sign_up
			click_link "Sign Out"
			visit "/users/sign_up/#{test_invitation.token}"
			test_invitation_sign_up
			expect(page).to have_content("Invitation token has already been used")
		end
	end
end