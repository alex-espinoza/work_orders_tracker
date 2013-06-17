FactoryGirl.define do
	factory :user_registration, class: User do
		first_name "Alex"
		last_name "Espinoza"
		email "aespinoza@aspria.net"
		password "12341234"
		password_confirmation "12341234"
	end
end