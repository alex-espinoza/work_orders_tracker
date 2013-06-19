require 'spec_helper'

describe Team do
	it { should validate_presence_of(:team_name) }

	it { should have_many(:users) }
	it { should have_many(:orders) }
end