class CreateOrderTableIds < ActiveRecord::Migration
  def up
  	add_column :orders, :team_id, :integer
  	add_column :orders, :manager_id, :integer
  	add_column :orders, :worker_id, :integer
  end

  def down
  	remove_column :orders, :team_id
  	remove_column :orders, :manager_id
  	remove_column :orders, :worker_id
  end
end
