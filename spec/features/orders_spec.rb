require 'spec_helper'

describe "Orders" do
	let!(:manager) { FactoryGirl.create(:valid_manager) }
	let!(:worker) { FactoryGirl.create(:new_user) }
	let!(:team) { FactoryGirl.create(:invitations_test_team) }
	let!(:manager_membership) { FactoryGirl.create(:invitations_test_membership, role: "manager", user: manager, team: team) }
	let!(:worker_membership) { FactoryGirl.create(:invitations_test_membership, role: "worker", user: worker, team: team) }
	let(:valid_work_order) { FactoryGirl.create(:work_order, team: team, manager: manager, worker: worker) }
	let(:team_worker_1) { FactoryGirl.create(:team_of_workers) }
	let(:team_worker_2) { FactoryGirl.create(:team_of_workers) }
	let(:team_worker_3) { FactoryGirl.create(:team_of_workers) }
	let(:orders_for_worker_1) { 3.times {FactoryGirl.create(:many_work_orders, team: team, manager: manager, worker: team_worker_1)} }
	let(:orders_for_worker_2) { 3.times {FactoryGirl.create(:many_work_orders, team: team, manager: manager, worker: team_worker_2)} }
	let(:orders_for_worker_3) { 3.times {FactoryGirl.create(:many_work_orders, team: team, manager: manager, worker: team_worker_3)} }
	let(:create_worker_team_and_orders) do
		team_worker_1
		team_worker_2
		team_worker_3
		orders_for_worker_1
		orders_for_worker_2
		orders_for_worker_3
	end
	after(:each) { Sidekiq::Extensions::DelayedMailer.jobs.clear }

	describe "- a manager -" do
		let(:completed_work_order) { FactoryGirl.create(:completed_work_order, team: team, manager: manager, worker: worker) }
		let(:closed_work_order) { FactoryGirl.create(:closed_work_order, team: team, manager: manager, worker: worker) }

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

		it "can mark a work order as high priority." do
			sign_in_as(manager)
			click_link "Test Maintenance Team"
			click_link "Create work order"
			fill_in "Work order name", :with => "Wall needs to be repainted"
			fill_in "Description", :with => "Left wall in room 146 is chipping paint badly. Repaint when clients are out after 2 PM."
			select("#{worker.get_full_name}", :from => "Assign work order to")
			check("Mark this work order as high priority")
			click_button "Create work order"
			expect(team.orders.all.first.high_priority).to be_true
		end

		it "can edit an existing work order but changes will be saved only if all fields are valid." do
			valid_work_order
			sign_in_as(manager)
			click_link "Test Maintenance Team"
			click_link "Wall needs to be repainted"
			click_link "Edit"
			fill_in "Work order name", :with => "Wall needs to be sanded and painted"
			fill_in "Description", :with => "Left wall in room 146 is chipping paint badly. Sand away and repaint when clients are out after 2 PM."
			click_button "Save changes"
			expect(page).to have_content("Work order has been successfully updated.")
			expect(team.orders.all.first.name).to eq("Wall needs to be sanded and painted")
			expect(team.orders.all.first.description).to eq("Left wall in room 146 is chipping paint badly. Sand away and repaint when clients are out after 2 PM.")
		end

		it "can edit an existing work order but changes will not be saved if any fields are invalid." do
			valid_work_order
			sign_in_as(manager)
			click_link "Test Maintenance Team"
			click_link "Wall needs to be repainted"
			click_link "Edit"
			fill_in "Work order name", :with => "asd"
			fill_in "Description", :with => "asd"
			click_button "Save changes"
			expect(page).to have_content("errors prohibited this work order from being updated")
		end

		it "can assign a work order to themself." do
			sign_in_as(manager)
			click_link "Test Maintenance Team"
			click_link "Create work order"
			fill_in "Work order name", :with => "Wall needs to be repainted"
			fill_in "Description", :with => "Left wall in room 146 is chipping paint badly. Repaint when clients are out after 2 PM."
			select("#{manager.get_full_name}", :from => "Assign work order to")
			click_button "Create work order"
			expect(page).to have_content("Work order has been created and was assigned to #{manager.get_full_name}.")
			expect(team.orders.all.count).to eq(1)
			expect(manager.manager_orders.all.count).to eq(1)
			expect(manager.worker_orders.all.count).to eq(1)
		end

		it "can change who a work order is assigned to." do
			valid_work_order
			sign_in_as(manager)
			click_link "Test Maintenance Team"
			click_link "Wall needs to be repainted"
			click_link "Edit"
			select("#{manager.get_full_name}", :from => "Assign work order to")
			click_button "Save changes"
			expect(page).to have_content("Work order has been successfully updated.")
			expect(manager.manager_orders.all.count).to eq(1)
			expect(manager.worker_orders.all.count).to eq(1)
			expect(worker.worker_orders.all.count).to eq(0)
		end

		it "can view the status of all of the team's work orders on the team show page." do
			create_worker_team_and_orders
			sign_in_as(manager)
			click_link "Test Maintenance Team"
			expect(page).to have_content("Floor 1 conference rooms need to be cleaned")
			expect(page).to have_content("Floor 2 conference rooms need to be cleaned")
			expect(page).to have_content("Floor 3 conference rooms need to be cleaned")
			expect(page).to have_content("Floor 4 conference rooms need to be cleaned")
			expect(page).to have_content("Floor 5 conference rooms need to be cleaned")
			expect(page).to have_content("Floor 6 conference rooms need to be cleaned")
			expect(page).to have_content("Floor 7 conference rooms need to be cleaned")
			expect(page).to have_content("Floor 8 conference rooms need to be cleaned")
			expect(page).to have_content("Floor 9 conference rooms need to be cleaned")
			expect(page).to have_content("Assigned")
		end

		it "can re-assign work orders only if they are completed." do
			completed_work_order
			sign_in_as(manager)
			click_link "Test Maintenance Team"
			click_link "Replace spotlight lightbulb"
			click_link "Reassign"
			expect(page).to have_content("Work order has been reassigned.")
			expect(page).to_not have_link("Reassign")
			expect(page).to have_content("Assigned")
			expect(team.orders.first.status).to eq("assigned")
		end

		it "cannot re-assign work orders if they are not completed." do
			valid_work_order
			closed_work_order
			sign_in_as(manager)
			click_link "Test Maintenance Team"
			click_link "Wall needs to be repainted"
			expect(page).to_not have_link("Reassign")
			expect(page).to have_content("Assigned")
			expect(team.orders.find_by_id(valid_work_order).status).to eq("assigned")
			click_link "Back"
			click_link "Shrubs need to be trimmed"
			expect(page).to_not have_link("Reassign")
			expect(page).to have_content("Closed")
			expect(team.orders.find_by_id(closed_work_order).status).to eq("closed")
		end

		it "can close work orders if they are completed." do
			completed_work_order
			sign_in_as(manager)
			click_link "Test Maintenance Team"
			click_link "Replace spotlight lightbulb"
			click_link "Close"
			expect(page).to have_content("Work order has been closed.")
			expect(page).to_not have_link("Reassign")
			expect(page).to_not have_link("Close")
			expect(page).to have_content("Closed")
			expect(team.orders.first.status).to eq("closed")
		end

		it "can close work orders if they are assigned." do
			valid_work_order
			sign_in_as(manager)
			click_link "Test Maintenance Team"
			click_link "Wall needs to be repainted"
			click_link "Close"
			expect(page).to have_content("Work order has been closed.")
			expect(page).to_not have_link("Reassign")
			expect(page).to_not have_link("Close")
			expect(page).to have_content("Closed")
			expect(team.orders.first.status).to eq("closed")
		end

		it "can complete work orders if they are assigned." do
			valid_work_order
			sign_in_as(manager)
			click_link "Test Maintenance Team"
			click_link "Wall needs to be repainted"
			click_link "Complete"
			expect(page).to have_content("Work order has been completed.")
			expect(page).to have_link("Reassign")
			expect(page).to have_link("Close")
			expect(page).to have_content("Completed")
			expect(team.orders.first.status).to eq("completed")
		end
	end

	describe "- a worker -" do
		it "cannot create a work order." do
			sign_in_as(worker)
			click_link "Test Maintenance Team"
			expect(page).to_not have_content("Create work order")
		end

		it "can only view work orders assigned to them." do
			create_worker_team_and_orders
			sign_in_as(worker)
			click_link "Test Maintenance Team"
			expect(page).to_not have_content("conference rooms need to be cleaned")
		end

		it "can only change the status of a work order to completed." do
			valid_work_order
			sign_in_as(worker)
			click_link "Test Maintenance Team"
			click_link "Wall needs to be repainted"
			expect(page).to have_link("Complete")
			expect(page).to_not have_link("Reassign")
			expect(page).to_not have_link("Close")
			click_link "Complete"
			expect(page).to have_content("Work order has been completed.")
			expect(page).to have_content("Complete")
			expect(team.orders.first.status).to eq("completed")
		end

		it "cannot edit a work order." do
			valid_work_order
			sign_in_as(worker)
			click_link "Test Maintenance Team"
			click_link "Wall needs to be repainted"
			expect(page).to_not have_link("Edit work order")
		end
	end

	it "send an email notification to a worker when they are assigned a new work order." do
		sign_in_as(manager)
		click_link "Test Maintenance Team"
		click_link "Create work order"
		fill_in "Work order name", :with => "Wall needs to be repainted"
		fill_in "Description", :with => "Left wall in room 146 is chipping paint badly. Repaint when clients are out after 2 PM."
		select("#{worker.get_full_name}", :from => "Assign work order to")
		click_button "Create work order"
		expect(Sidekiq::Extensions::DelayedMailer.jobs.first).to have_content("Wall needs to be repainted")
		expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(1)
	end

	it "clicking on an work order's name will bring you to that order's page." do
		valid_work_order
		sign_in_as(worker)
		click_link "Test Maintenance Team"
		click_link "Wall needs to be repainted"
		expect(page).to have_content("Wall needs to be repainted")
	end
end
