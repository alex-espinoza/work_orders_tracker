FactoryGirl.define do
	factory :invitations_test_team, class: Team do
		team_name "Test Maintenance Team"
	end

	factory :invitations_test_membership, class: TeamMembership do
		role ""
		association :user
		association :team
	end

	factory :inviter_manager, class: User do
		first_name "Manager"
		last_name "Guy"
		email "manager@company.com"
		password "12341234"
		password_confirmation "12341234"
	end

	factory :invited_user, class: User do
		first_name "John"
		last_name "Smith"
		email "johnsmith@test.com"
		password "12341234"
		password_confirmation "12341234"
	end
end