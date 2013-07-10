require 'spec_helper'

describe "Order Responses" do
	let!(:manager) { FactoryGirl.create(:valid_manager) }
	let!(:worker_1) { FactoryGirl.create(:new_user) }
	let!(:worker_2) { FactoryGirl.create(:new_user, email: "cool@cool.com") }
	let!(:team) { FactoryGirl.create(:invitations_test_team) }
	let!(:manager_membership) { FactoryGirl.create(:invitations_test_membership, role: "manager", user: manager, team: team) }
	let!(:worker_membership_1) { FactoryGirl.create(:invitations_test_membership, role: "worker", user: worker_1, team: team) }
	let!(:worker_membership_2) { FactoryGirl.create(:invitations_test_membership, role: "worker", user: worker_2, team: team) }
	let!(:work_order_1) { FactoryGirl.create(:work_order, team: team, manager: manager, worker: worker_1) }
	let!(:work_order_2) { FactoryGirl.create(:work_order, name: "Wall needs to be destroyed", team: team, manager: manager, worker: worker_2) }

	it "should be displayed on the order show page." do
		sign_in_as(manager)
		click_on "Test Maintenance Team"
		click_on "Wall needs to be destroyed"
		expect(page).to have_content("No responses have been left")
	end

	it "should redirect back to the order show page after creating a response." do
		sign_in_as(manager)
		click_on "Test Maintenance Team"
		click_on "Wall needs to be destroyed"
		fill_in "Leave a response", :with => "Should I use the hammer or jackhammer?"
		click_button "Leave response"
		expect(page).to have_content("You have successfully left a response")
		expect(page).to have_content("Should I use the hammer or jackhammer?")
	end

	it "should not be created if the response is invalid." do
		sign_in_as(manager)
		click_on "Test Maintenance Team"
		click_on "Wall needs to be destroyed"
		fill_in "Leave a response", :with => "asd"
		click_button "Leave response"
		expect(page).to have_content("error prohibited this response from being made")
	end

	describe "- a manager -" do
		it "can respond to any order that they have issued." do
			sign_in_as(manager)
			click_on "Test Maintenance Team"
			click_on "Wall needs to be destroyed"
			fill_in "Leave a response", :with => "Should I use the hammer or jackhammer?"
			click_button "Leave response"
			expect(page).to have_content("You have successfully left a response")
		end

		it "cannot respond to an order that has been closed." do
			sign_in_as(manager)
			click_on "Test Maintenance Team"
			click_on "Wall needs to be destroyed"
			click_on "Close"
			expect(page).to_not have_button("Leave comment")
		end
	end

	describe "- a worker -" do
		it "can only respond to orders that have been issued to them." do
			sign_in_as(worker_1)
			click_on "Test Maintenance Team"
			expect(page).to have_content("Wall needs to be repainted")
			expect(page).to_not have_content("Wall needs to be destroyed")
			click_on "Wall needs to be repainted"
			fill_in "Leave a response", :with => "Should I use the hammer or paintbrush?"
			click_on "Leave response"
			expect(page).to have_content("You have successfully left a response")
			expect(page).to have_content("Should I use the hammer or paintbrush?")
		end

		it "cannot respond to an order that has been closed." do
			sign_in_as(manager)
			click_link "Test Maintenance Team"
			click_link "Wall needs to be destroyed"
			click_link "Close"
			click_link "(sign out)"
			sign_in_as(worker_2)
			click_link "Test Maintenance Team"
			click_link "Wall needs to be destroyed"
			expect(page).to_not have_button("Leave comment")
		end
	end
end