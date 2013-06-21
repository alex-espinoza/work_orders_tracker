require 'spec_helper'

describe TeamMembership do
	it { should belong_to(:user) }
	it { should belong_to(:team) }

	it { should validate_presence_of(:role) }
	it { should validate_presence_of(:user_id) }
	it { should validate_presence_of(:team_id) }
end