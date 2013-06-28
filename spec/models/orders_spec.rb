require 'spec_helper'

describe Order do
	it { should have_many(:order_responses) }
	it { should belong_to(:manager) }
	it { should belong_to(:worker) }
	it { should belong_to(:team) }

	it { should validate_presence_of(:description) }
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:status) }
	it { should validate_presence_of(:team_id) }
	it { should validate_presence_of(:manager_id) }
	it { should validate_presence_of(:worker_id) }

	it { should ensure_length_of(:name).is_at_most(140) }
end