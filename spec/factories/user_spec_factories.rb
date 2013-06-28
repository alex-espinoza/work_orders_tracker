FactoryGirl.define do
	factory :valid_user, class: User do
		first_name "Alex"
		last_name "Espinoza"
		email "aespinoza@aspria.net"
		password "12341234"
		password_confirmation "12341234"
	end

	factory :invalid_user, class: User do
		first_name "Alex"
		last_name ""
		email ""
		password "12341234"
		password_confirmation "12341234"
	end

	factory :work_order, class: Order do
		name "Wall needs to be repainted"
		description "Left wall in room 146 is chipping paint badly. Repaint when clients are out after 2 PM."
		association :team
		association :manager
		# select("#{worker.first_name} #{worker.last_name}", :from => "Assign work order to")
	end
end