FactoryGirl.define do
	factory :valid_manager, class: User do
		first_name "Manager"
		last_name "Guy"
		email "manager@company.com"
		password "12341234"
		password_confirmation "12341234"
	end
end