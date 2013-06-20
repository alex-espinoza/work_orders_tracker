require 'spec_helper'

describe User do
	# it { should have_many(:orders) } ### Find another way to test, orders will not have a user_id, instead will have worker_id and manager_id
	it { should have_many(:order_responses) }

	it { should validate_presence_of(:first_name) }
	it { should validate_presence_of(:last_name) }
	it { should validate_presence_of(:email) }
	it { should validate_presence_of(:password) }
	it { should validate_presence_of(:password_confirmation) }

	it { should_not allow_value("blah").for(:email) }
	it { should allow_value("blah@blah.com").for(:email) }

	it { should validate_uniqueness_of(:email) }
end