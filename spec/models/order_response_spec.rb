require 'spec_helper'

describe OrderResponse do
	it { should belong_to(:order) }
	it { should belong_to(:user) }

	it { should validate_presence_of(:response) }
	it { should validate_presence_of(:order_id) }
	it { should validate_presence_of(:user_id) }

	it { should ensure_length_of(:response).is_at_least(4).is_at_most(400) }
end