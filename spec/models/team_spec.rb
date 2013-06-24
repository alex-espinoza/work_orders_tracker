require 'spec_helper'

describe Team do
	it { should validate_presence_of(:team_name) }

	it { should have_many(:users) }
	it { should have_many(:orders) }
	it { should have_many(:team_memberships) }
	it { should have_many(:team_invitations) }

	it { should ensure_length_of(:team_name).is_at_most(100)}
end