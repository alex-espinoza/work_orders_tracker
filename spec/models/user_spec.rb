require 'spec_helper'

describe User do
	it { should have_many(:manager_orders) }
	it { should have_many(:worker_orders) }
	it { should have_many(:order_responses) }
	it { should have_many(:teams) }
	it { should have_many(:team_memberships) }

	it { should validate_presence_of(:first_name) }
	it { should validate_presence_of(:last_name) }
	it { should validate_presence_of(:email) }
	it { should validate_presence_of(:password) }
	it { should validate_presence_of(:password_confirmation) }

	it { should_not allow_value("blah").for(:email) }
	it { should allow_value("blah@blah.com").for(:email) }

	it { should validate_uniqueness_of(:email) }
end