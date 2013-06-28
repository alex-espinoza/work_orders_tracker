require 'spec_helper'

describe "Orders" do
	describe "- a manager -" do
		let!(:manager) { FactoryGirl.create(:valid_manager) }
		let!(:worker) { FactoryGirl.create(:new_user) }
		let!(:team) { FactoryGirl.create(:invitations_test_team) }
		let!(:manager_membership) { FactoryGirl.create(:invitations_test_membership, role: "manager", user: manager, team: team) }
		let!(:worker_membership) { FactoryGirl.create(:invitations_test_membership, role: "worker", user: worker, team: team) }
		let(:valid_work_order) { FactoryGirl.build(:work_order) }

		it "can create and assign a work order if all fields are valid." do
			sign_in_as(manager)
			click_link "Test Maintenance Team"
			click_link "Create work order"
			save_and_open_page
			fill_in "Work order name", :with => "Wall needs to be repainted"
			fill_in "Description", :with => "Left wall in room 146 is chipping paint badly. Repaint when clients are out after 2 PM."
			select("#{worker.get_full_name}", :from => "Assign work order to")
			click_button "Create work order"
			expect(page).to have_content("Work order has been created and assigned to #{worker.first_name} #{worker.last_name}.")
		end

		it "cannot create or assign a work order if any fields are invalid." do
		end

		it "can edit an existing work order but changes will be saved only if all fields are valid." do
		end

		it "can edit an existing work order but changes will not be saved if any fields are invalid." do
		end

		it "can view the status of all of the team's work orders on the team show page." do
		end

		it "can re-assign work orders regardless of their status." do
			# make test for every status
		end

		it "can close work orders regardless of their status." do
			#make test for every status
		end

		it "can respond to work orders regardless of their status." do
			#make test for every status
		end
	end

	describe "- a worker -" do
		it "cannot create a work order." do
		end

		it "can only view the status of work orders assigned to them." do
		end

		it "can respond to work orders." do
		end

		it "can only change the status of a work order to completed." do
		end

		it "cannot change the high priority status of a work order." do
		end

		it "cannot respond to work orders that have a completed status." do
		end
	end
end
