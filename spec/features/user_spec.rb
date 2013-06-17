require 'spec_helper'

describe "User" do
	let(:register_new_user) do
		user = FactoryGirl.build(:user_registration)
		visit new_user_registration_path
		fill_in "First name", :with => user.first_name
		fill_in "Last name", :with => user.last_name
		fill_in "Email address", :with => user.email
		fill_in "Password", :with => user.password
		fill_in "Password confirmation", :with => user.password_confirmation
	end

	describe "- when signing up -" do
		it "should be redirected to the order index page on successful registration." do
			register_new_user
			click_button "Sign up"
			expect(page).to have_content("Order#index")
		end

		it "should show an error and stay on the sign up page on an invalid registration attempt." do
			register_new_user
			fill_in "First name", :with => ""
			fill_in "Email address", :with => ""
			click_button "Sign up"
			expect(page).to have_content("errors prohibited this user from being saved")
		end
	end
end