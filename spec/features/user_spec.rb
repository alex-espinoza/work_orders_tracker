require 'spec_helper'

describe "User" do
	let(:new_user_1) { FactoryGirl.build(:valid_user) }
	let(:new_user_2) { FactoryGirl.build(:invalid_user) }

	describe "- when signing up -" do
		it "will be redirected to the team index page on successful registration." do
			sign_up_as(new_user_1)
			expect(page).to have_content("Teams")
			expect(User.all.count).to eq(1)
		end

		it "will show an error and stay on the sign up page on an invalid registration attempt." do
			sign_up_as(new_user_2)
			expect(page).to have_content("errors occured")
			expect(User.all.count).to eq(0)
		end
	end
end