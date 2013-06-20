require 'spec_helper'

describe "Team" do
	let(:new_manager) { FactoryGirl.build(:valid_manager) }

	describe "- when being created -" do
		it "will redirect to team index page on successful team creation." do
			sign_up_as(new_manager)
			click_link "Create new team"
			fill_in "Team name", :with => "Launch Academy Maintenance Team"
			click_button "Create team"
			expect(page).to have_content("Teams#index")
			expect(Team.all.count).to eq(1)
		end
	end

	describe "- when being created -" do
		it "will show an error and stay on the team creation page on an invalid creation attempt." do
			sign_up_as(new_manager)
			click_link "Create new team"
			fill_in "Team name", :with => ""
			click_button "Create team"
			expect(page).to have_content("error prohibited this app from being saved")
			expect(Team.all.count).to eq(0)
		end
	end
end