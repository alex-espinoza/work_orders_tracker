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
		association :worker
	end

	factory :many_work_orders, class: Order do
		sequence(:name) { |n| "Floor #{n} conference rooms need to be cleaned" }
		description "Vacuum floor and put everything back in its place."
		association :team
		association :manager
		association :worker
	end

	factory :team_of_workers, class: User do
		first_name "Worker"
		sequence(:last_name) { |n| "Person #{n}" }
		sequence(:email) { |e| "worker#{e}@person.com"}
		password "12341234"
		password_confirmation "12341234"
	end

	factory :completed_work_order, class: Order do
		name "Replace spotlight lightbulb"
		description "Spotlight outside tool shed went out, replace it before dark."
		status "completed"
		association :team
		association :manager
		association :worker
	end
end