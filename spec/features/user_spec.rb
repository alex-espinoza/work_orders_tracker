require 'spec_helper'

describe "User" do
	describe "when signing up" do
		it "if they are a manager, they should be brought to the team creation page." do
			visit new_user_registration_path
			fill_in "First name", :with => "Alex"
			fill_in "Last name", :with => "Espinoza"
			select "Manager - I will be issuing work orders.", :from => "Role"
			fill_in "Email address", :with => "aespinoza@aspria.net"
			fill_in "Password", :with => "12341234"
			fill_in "Password confirmation", :with => "12341234"
			click_button "Sign up"
			expect(page).to have_content("Create your team")
		end

		it "if they are a worker, they should be brought to the order view page." do
		end
	end
end