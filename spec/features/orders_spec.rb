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
			fill_in "Work order name", :with => "Wall needs to be repainted"
			fill_in "Description", :with => "Left wall in room 146 is chipping paint badly. Repaint when clients are out after 2 PM."
			select("#{worker.get_full_name}", :from => "Assign work order to")
			click_button "Create work order"
			expect(page).to have_content("Work order has been created and was assigned to #{worker.get_full_name}.")
			expect(page).to have_content("Wall needs to be repainted")
			expect(team.orders.all.count).to eq(1)
			expect(manager.manager_orders.all.count).to eq(1)
			expect(worker.worker_orders.all.count).to eq(1)
		end

		it "cannot create or assign a work order if any fields are invalid." do
			sign_in_as(manager)
			click_link "Test Maintenance Team"
			click_link "Create work order"
			fill_in "Work order name", :with => "Wall needs to be repainted"
			click_button "Create work order"
			expect(page).to have_content("errors prohibited this work order from being created")
			expect(team.orders.all.count).to eq(0)
			expect(manager.manager_orders.all.count).to eq(0)
			expect(worker.worker_orders.all.count).to eq(0)
		end

		it "can attach files with a maximum size of 5 MB to a work order." do
		end

		it "can mark a work order as high priority." do
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

	it "clicking on an work order's name will bring you to that order's page." do
	end
end
